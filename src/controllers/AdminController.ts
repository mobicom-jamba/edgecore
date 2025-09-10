import { Request, Response } from 'express';
import { UserService } from '../services/UserService';
import { AuthenticatedRequest, ApiResponse, SearchQuery } from '../types';
import { logError, logInfo, businessLogger } from '../utils/logger';

export class AdminController {
  private userService: UserService;

  constructor() {
    this.userService = new UserService();
  }

  // Get all users with pagination and filtering
  getAllUsers = async (req: Request, res: Response): Promise<void> => {
    try {
      const query: SearchQuery = {
        page: parseInt(req.query.page as string) || 1,
        limit: parseInt(req.query.limit as string) || 10,
        search: req.query.search as string,
        sortBy: req.query.sortBy as string || 'createdAt',
        sortOrder: (req.query.sortOrder as 'ASC' | 'DESC') || 'DESC',
        filters: {
          role: req.query.role as string,
          isActive: req.query.isActive ? req.query.isActive === 'true' : undefined,
          isEmailVerified: req.query.isEmailVerified ? req.query.isEmailVerified === 'true' : undefined,
        },
      };

      const result = await this.userService.getAllUsers(query);

      const response: ApiResponse = {
        success: true,
        message: 'Users retrieved successfully',
        data: result.users,
        pagination: result.pagination,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.getAllUsers');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve users',
      };

      res.status(500).json(response);
    }
  };

  // Get user by ID
  getUserById = async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const user = await this.userService.getUserById(id);

      if (!user) {
        const response: ApiResponse = {
          success: false,
          message: 'User not found',
        };
        res.status(404).json(response);
        return;
      }

      const response: ApiResponse = {
        success: true,
        message: 'User retrieved successfully',
        data: { user: user.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.getUserById');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve user',
      };

      res.status(500).json(response);
    }
  };

  // Update user
  updateUser = async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const updateData = req.body;

      const user = await this.userService.updateUser(id, updateData);

      businessLogger('user_updated', id, { updatedFields: Object.keys(updateData) });

      const response: ApiResponse = {
        success: true,
        message: 'User updated successfully',
        data: { user: user.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.updateUser');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to update user',
      };

      res.status(400).json(response);
    }
  };

  // Deactivate user
  deactivateUser = async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;

      await this.userService.deactivateUser(id);

      businessLogger('user_deactivated', id);

      const response: ApiResponse = {
        success: true,
        message: 'User deactivated successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.deactivateUser');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to deactivate user',
      };

      res.status(400).json(response);
    }
  };

  // Activate user
  activateUser = async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;

      await this.userService.activateUser(id);

      businessLogger('user_activated', id);

      const response: ApiResponse = {
        success: true,
        message: 'User activated successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.activateUser');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to activate user',
      };

      res.status(400).json(response);
    }
  };

  // Get user activity log
  getUserActivity = async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.params;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;

      const result = await this.userService.getUserActivity(id, page, limit);

      const response: ApiResponse = {
        success: true,
        message: 'User activity retrieved successfully',
        data: result.activities,
        pagination: result.pagination,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.getUserActivity');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve user activity',
      };

      res.status(500).json(response);
    }
  };

  // Bulk user operations
  bulkUserOperations = async (req: Request, res: Response): Promise<void> => {
    try {
      const { operation, userIds, data } = req.body;

      const result = await this.userService.bulkUserOperations(operation, userIds, data);

      businessLogger('bulk_user_operation', undefined, { operation, count: userIds.length });

      const response: ApiResponse = {
        success: true,
        message: `Bulk ${operation} completed successfully`,
        data: result,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.bulkUserOperations');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to perform bulk operation',
      };

      res.status(400).json(response);
    }
  };

  // Get system statistics
  getSystemStats = async (req: Request, res: Response): Promise<void> => {
    try {
      const stats = await this.userService.getSystemStats();

      const response: ApiResponse = {
        success: true,
        message: 'System statistics retrieved successfully',
        data: stats,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.getSystemStats');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve system statistics',
      };

      res.status(500).json(response);
    }
  };

  // Get user analytics
  getUserAnalytics = async (req: Request, res: Response): Promise<void> => {
    try {
      const period = req.query.period as string || '30d';
      const analytics = await this.userService.getUserAnalytics(period);

      const response: ApiResponse = {
        success: true,
        message: 'User analytics retrieved successfully',
        data: analytics,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.getUserAnalytics');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve user analytics',
      };

      res.status(500).json(response);
    }
  };

  // Export users
  exportUsers = async (req: Request, res: Response): Promise<void> => {
    try {
      const { format = 'csv', filters } = req.query;
      const exportData = await this.userService.exportUsers(format as string, filters as any);

      res.setHeader('Content-Type', format === 'csv' ? 'text/csv' : 'application/json');
      res.setHeader('Content-Disposition', `attachment; filename=users-export-${Date.now()}.${format}`);
      
      res.send(exportData);
    } catch (error) {
      logError(error as Error, 'AdminController.exportUsers');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to export users',
      };

      res.status(500).json(response);
    }
  };

  // Import users
  importUsers = async (req: Request, res: Response): Promise<void> => {
    try {
      const { users } = req.body;
      const result = await this.userService.importUsers(users);

      businessLogger('users_imported', undefined, { count: result.successCount, failed: result.failedCount });

      const response: ApiResponse = {
        success: true,
        message: 'Users imported successfully',
        data: result,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AdminController.importUsers');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to import users',
      };

      res.status(400).json(response);
    }
  };
}
