import { AppDataSource } from '../../config/database';
import { User } from '../../models/User';
import { UserRole } from '../../types';
import { logInfo, logError } from '../../utils/logger';

const seedDatabase = async (): Promise<void> => {
  try {
    await AppDataSource.initialize();
    logInfo('🌱 Starting database seeding...');

    const userRepository = AppDataSource.getRepository(User);

    // Check if admin user already exists
    const existingAdmin = await userRepository.findOne({
      where: { email: 'admin@edgecore.com' },
    });

    if (!existingAdmin) {
      // Create admin user
      const adminUser = userRepository.create({
        email: 'admin@edgecore.com',
        firstName: 'Admin',
        lastName: 'User',
        password: 'admin123456', // This will be hashed by the entity
        role: UserRole.ADMIN,
        isEmailVerified: true,
        isActive: true,
      });

      await userRepository.save(adminUser);
      logInfo('✅ Admin user created: admin@edgecore.com / admin123456');
    } else {
      logInfo('ℹ️  Admin user already exists');
    }

    // Check if test user already exists
    const existingTestUser = await userRepository.findOne({
      where: { email: 'test@edgecore.com' },
    });

    if (!existingTestUser) {
      // Create test user
      const testUser = userRepository.create({
        email: 'test@edgecore.com',
        firstName: 'Test',
        lastName: 'User',
        password: 'test123456', // This will be hashed by the entity
        role: UserRole.USER,
        isEmailVerified: true,
        isActive: true,
      });

      await userRepository.save(testUser);
      logInfo('✅ Test user created: test@edgecore.com / test123456');
    } else {
      logInfo('ℹ️  Test user already exists');
    }

    logInfo('🎉 Database seeding completed successfully!');
  } catch (error) {
    logError(error as Error, 'Database seeding');
    throw error;
  } finally {
    await AppDataSource.destroy();
  }
};

// Run seeding if this file is executed directly
if (require.main === module) {
  seedDatabase()
    .then(() => {
      logInfo('✅ Seeding completed');
      process.exit(0);
    })
    .catch((error) => {
      logError(error as Error, 'Seeding failed');
      process.exit(1);
    });
}

export default seedDatabase;
