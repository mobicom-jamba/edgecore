import { Repository, Like, Between, In } from 'typeorm';
import { AppDataSource } from '../config/database';
import { User } from '../models/User';
import { UserRole, SearchQuery, ApiResponse } from '../types';
import { logError, logInfo, businessLogger } from '../utils/logger';

export interface UserAnalytics {
  totalUsers: number;
  activeUsers: number;
  newUsers: number;
  userGrowth: number;
  roleDistribution: Record<string, number>;
  emailVerificationRate: number;
  lastLoginDistribution: {
    last24h: number;
    last7d: number;
    last30d: number;
    never: number;
  };
  userActivity: {
    date: string;
    registrations: number;
    logins: number;
  }[];
}

export interface SystemStats {
  totalUsers: number;
  activeUsers: number;
  totalFiles: number;
  totalStorageUsed: number;
  systemUptime: number;
  apiRequests: number;
  errorRate: number;
  averageResponseTime: number;
}

export interface UserActivity {
  id: string;
  userId: string;
  action: string;
  details: any;
  ipAddress?: string;
  userAgent?: string;
  createdAt: Date;
}

export interface BulkOperationResult {
  successCount: number;
  failedCount: number;
  errors: Array<{ userId: string; error: string }>;
}

export class UserService {
  private userRepository: Repository<User>;

  constructor() {
    this.userRepository = AppDataSource.getRepository(User);
  }

  async getAllUsers(query: SearchQuery): Promise<{
    users: User[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  }> {
    const { page = 1, limit = 10, search, sortBy = 'createdAt', sortOrder = 'DESC', filters = {} } = query;
    
    const queryBuilder = this.userRepository.createQueryBuilder('user');

    // Apply search
    if (search) {
      queryBuilder.andWhere(
        '(user.firstName ILIKE :search OR user.lastName ILIKE :search OR user.email ILIKE :search)',
        { search: `%${search}%` }
      );
    }

    // Apply filters
    if (filters.role) {
      queryBuilder.andWhere('user.role = :role', { role: filters.role });
    }
    if (filters.isActive !== undefined) {
      queryBuilder.andWhere('user.isActive = :isActive', { isActive: filters.isActive });
    }
    if (filters.isEmailVerified !== undefined) {
      queryBuilder.andWhere('user.isEmailVerified = :isEmailVerified', { isEmailVerified: filters.isEmailVerified });
    }

    // Apply sorting
    queryBuilder.orderBy(`user.${sortBy}`, sortOrder);

    // Apply pagination
    const skip = (page - 1) * limit;
    queryBuilder.skip(skip).take(limit);

    const [users, total] = await queryBuilder.getManyAndCount();

    return {
      users,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getUserById(id: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { id },
      relations: ['files'],
    });
  }

  async updateUser(id: string, updateData: Partial<User>): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id } });
    
    if (!user) {
      throw new Error('User not found');
    }

    // Prevent updating sensitive fields directly
    const allowedFields = ['firstName', 'lastName', 'role', 'isActive', 'avatar'];
    const filteredData: Partial<User> = {};
    
    for (const key of allowedFields) {
      if (key in updateData) {
        (filteredData as any)[key] = (updateData as any)[key];
      }
    }

    Object.assign(user, filteredData);
    return this.userRepository.save(user);
  }

  async deactivateUser(id: string): Promise<void> {
    const user = await this.userRepository.findOne({ where: { id } });
    
    if (!user) {
      throw new Error('User not found');
    }

    user.isActive = false;
    await this.userRepository.save(user);
  }

  async activateUser(id: string): Promise<void> {
    const user = await this.userRepository.findOne({ where: { id } });
    
    if (!user) {
      throw new Error('User not found');
    }

    user.isActive = true;
    await this.userRepository.save(user);
  }

  async getUserActivity(userId: string, page: number = 1, limit: number = 10): Promise<{
    activities: UserActivity[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  }> {
    // This would typically come from an activity log table
    // For now, we'll simulate with basic user data
    const user = await this.userRepository.findOne({ where: { id: userId } });
    
    if (!user) {
      throw new Error('User not found');
    }

    // Simulate activity data - in a real implementation, this would query an activity log table
    const activities: UserActivity[] = [
      {
        id: '1',
        userId: user.id,
        action: 'login',
        details: { timestamp: user.lastLoginAt },
        createdAt: user.lastLoginAt || new Date(),
      },
      {
        id: '2',
        userId: user.id,
        action: 'profile_updated',
        details: { updatedAt: user.updatedAt },
        createdAt: user.updatedAt,
      },
      {
        id: '3',
        userId: user.id,
        action: 'account_created',
        details: { createdAt: user.createdAt },
        createdAt: user.createdAt,
      },
    ];

    const total = activities.length;
    const startIndex = (page - 1) * limit;
    const endIndex = startIndex + limit;
    const paginatedActivities = activities.slice(startIndex, endIndex);

    return {
      activities: paginatedActivities,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async bulkUserOperations(operation: string, userIds: string[], data: any): Promise<BulkOperationResult> {
    const result: BulkOperationResult = {
      successCount: 0,
      failedCount: 0,
      errors: [],
    };

    for (const userId of userIds) {
      try {
        switch (operation) {
          case 'activate':
            await this.activateUser(userId);
            break;
          case 'deactivate':
            await this.deactivateUser(userId);
            break;
          case 'updateRole':
            await this.updateUser(userId, { role: data.role });
            break;
          default:
            throw new Error(`Unknown operation: ${operation}`);
        }
        result.successCount++;
      } catch (error) {
        result.failedCount++;
        result.errors.push({
          userId,
          error: error instanceof Error ? error.message : 'Unknown error',
        });
      }
    }

    return result;
  }

  async getSystemStats(): Promise<SystemStats> {
    const totalUsers = await this.userRepository.count();
    const activeUsers = await this.userRepository.count({ where: { isActive: true } });
    
    // These would typically come from other services or monitoring systems
    const stats: SystemStats = {
      totalUsers,
      activeUsers,
      totalFiles: 0, // Would come from FileService
      totalStorageUsed: 0, // Would come from FileService
      systemUptime: process.uptime(),
      apiRequests: 0, // Would come from monitoring system
      errorRate: 0, // Would come from monitoring system
      averageResponseTime: 0, // Would come from monitoring system
    };

    return stats;
  }

  async getUserAnalytics(period: string): Promise<UserAnalytics> {
    const now = new Date();
    let startDate: Date;

    switch (period) {
      case '7d':
        startDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        break;
      case '30d':
        startDate = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
        break;
      case '90d':
        startDate = new Date(now.getTime() - 90 * 24 * 60 * 60 * 1000);
        break;
      default:
        startDate = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
    }

    const totalUsers = await this.userRepository.count();
    const activeUsers = await this.userRepository.count({ where: { isActive: true } });
    const newUsers = await this.userRepository.count({
      where: { createdAt: Between(startDate, now) },
    });

    // Get role distribution
    const roleDistribution = await this.userRepository
      .createQueryBuilder('user')
      .select('user.role', 'role')
      .addSelect('COUNT(*)', 'count')
      .groupBy('user.role')
      .getRawMany();

    const roleDist: Record<string, number> = {};
    roleDistribution.forEach(item => {
      roleDist[item.role] = parseInt(item.count);
    });

    // Get email verification rate
    const verifiedUsers = await this.userRepository.count({ where: { isEmailVerified: true } });
    const emailVerificationRate = totalUsers > 0 ? (verifiedUsers / totalUsers) * 100 : 0;

    // Get last login distribution
    const last24h = new Date(now.getTime() - 24 * 60 * 60 * 1000);
    const last7d = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
    const last30d = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);

    const lastLoginDistribution = {
      last24h: await this.userRepository.count({
        where: { lastLoginAt: Between(last24h, now) },
      }),
      last7d: await this.userRepository.count({
        where: { lastLoginAt: Between(last7d, now) },
      }),
      last30d: await this.userRepository.count({
        where: { lastLoginAt: Between(last30d, now) },
      }),
      never: await this.userRepository.count({
        where: { lastLoginAt: null as any },
      }),
    };

    // Calculate user growth
    const previousPeriodStart = new Date(startDate.getTime() - (now.getTime() - startDate.getTime()));
    const previousPeriodUsers = await this.userRepository.count({
      where: { createdAt: Between(previousPeriodStart, startDate) },
    });
    const userGrowth = previousPeriodUsers > 0 ? ((newUsers - previousPeriodUsers) / previousPeriodUsers) * 100 : 0;

    // Generate daily activity data (simplified)
    const userActivity = [];
    for (let i = 0; i < 30; i++) {
      const date = new Date(now.getTime() - i * 24 * 60 * 60 * 1000);
      const dayStart = new Date(date.getFullYear(), date.getMonth(), date.getDate());
      const dayEnd = new Date(dayStart.getTime() + 24 * 60 * 60 * 1000);

      const registrations = await this.userRepository.count({
        where: { createdAt: Between(dayStart, dayEnd) },
      });

      // Simulate login data - in real implementation, this would come from activity logs
      const logins = Math.floor(registrations * 0.8);

      userActivity.unshift({
        date: dayStart.toISOString().split('T')[0],
        registrations,
        logins,
      });
    }

    return {
      totalUsers,
      activeUsers,
      newUsers,
      userGrowth,
      roleDistribution: roleDist,
      emailVerificationRate,
      lastLoginDistribution,
      userActivity,
    };
  }

  async exportUsers(format: string, filters: any): Promise<string> {
    const users = await this.userRepository.find({
      where: filters,
      select: ['id', 'email', 'firstName', 'lastName', 'role', 'isActive', 'isEmailVerified', 'createdAt'],
    });

    if (format === 'csv') {
      const headers = ['ID', 'Email', 'First Name', 'Last Name', 'Role', 'Active', 'Email Verified', 'Created At'];
      const rows = users.map(user => [
        user.id,
        user.email,
        user.firstName,
        user.lastName,
        user.role,
        user.isActive ? 'Yes' : 'No',
        user.isEmailVerified ? 'Yes' : 'No',
        user.createdAt.toISOString(),
      ]);

      return [headers, ...rows].map(row => row.join(',')).join('\n');
    } else {
      return JSON.stringify(users, null, 2);
    }
  }

  async importUsers(users: any[]): Promise<BulkOperationResult> {
    const result: BulkOperationResult = {
      successCount: 0,
      failedCount: 0,
      errors: [],
    };

    for (const userData of users) {
      try {
        // Validate required fields
        if (!userData.email || !userData.firstName || !userData.lastName || !userData.password) {
          throw new Error('Missing required fields');
        }

        // Check if user already exists
        const existingUser = await this.userRepository.findOne({
          where: { email: userData.email },
        });

        if (existingUser) {
          throw new Error('User with this email already exists');
        }

        // Create user
        const user = this.userRepository.create({
          email: userData.email,
          firstName: userData.firstName,
          lastName: userData.lastName,
          password: userData.password,
          role: userData.role || UserRole.USER,
          isActive: userData.isActive !== undefined ? userData.isActive : true,
          isEmailVerified: userData.isEmailVerified || false,
        });

        await this.userRepository.save(user);
        result.successCount++;
      } catch (error) {
        result.failedCount++;
        result.errors.push({
          userId: userData.email || 'unknown',
          error: error instanceof Error ? error.message : 'Unknown error',
        });
      }
    }

    return result;
  }
}
