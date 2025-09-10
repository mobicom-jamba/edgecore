import { Router } from 'express';
import { AdminController } from '../controllers/AdminController';
import { AuthMiddleware } from '../middleware/auth';
import { validateRequest } from '../middleware/validation';
import { UserRole } from '../types';
import Joi from 'joi';

const router = Router();
const adminController = new AdminController();
const authMiddleware = new AuthMiddleware();

// Apply admin authentication to all routes
router.use(authMiddleware.authenticate);
router.use(authMiddleware.authorize(UserRole.ADMIN));

/**
 * @swagger
 * components:
 *   schemas:
 *     UserUpdate:
 *       type: object
 *       properties:
 *         firstName:
 *           type: string
 *           minLength: 2
 *         lastName:
 *           type: string
 *           minLength: 2
 *         role:
 *           type: string
 *           enum: [user, admin, moderator]
 *         isActive:
 *           type: boolean
 *         avatar:
 *           type: string
 *           format: uri
 *     
 *     BulkUserOperation:
 *       type: object
 *       required:
 *         - operation
 *         - userIds
 *       properties:
 *         operation:
 *           type: string
 *           enum: [activate, deactivate, updateRole]
 *         userIds:
 *           type: array
 *           items:
 *             type: string
 *         data:
 *           type: object
 *           properties:
 *             role:
 *               type: string
 *               enum: [user, admin, moderator]
 *     
 *     UserImport:
 *       type: object
 *       required:
 *         - users
 *       properties:
 *         users:
 *           type: array
 *           items:
 *             type: object
 *             required:
 *               - email
 *               - firstName
 *               - lastName
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *               firstName:
 *                 type: string
 *               lastName:
 *                 type: string
 *               password:
 *                 type: string
 *                 minLength: 6
 *               role:
 *                 type: string
 *                 enum: [user, admin, moderator]
 *               isActive:
 *                 type: boolean
 *               isEmailVerified:
 *                 type: boolean
 */

/**
 * @swagger
 * /api/v1/admin/users:
 *   get:
 *     summary: Get all users (Admin only)
 *     description: Retrieve a paginated list of all users with filtering and search capabilities
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 10
 *         description: Number of users per page
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search term for name or email
 *       - in: query
 *         name: role
 *         schema:
 *           type: string
 *           enum: [user, admin, moderator]
 *         description: Filter by user role
 *       - in: query
 *         name: isActive
 *         schema:
 *           type: boolean
 *         description: Filter by active status
 *       - in: query
 *         name: isEmailVerified
 *         schema:
 *           type: boolean
 *         description: Filter by email verification status
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *           enum: [createdAt, updatedAt, firstName, lastName, email]
 *           default: createdAt
 *         description: Field to sort by
 *       - in: query
 *         name: sortOrder
 *         schema:
 *           type: string
 *           enum: [ASC, DESC]
 *           default: DESC
 *         description: Sort order
 *     responses:
 *       200:
 *         description: Users retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: array
 *                       items:
 *                         $ref: '#/components/schemas/User'
 *                     pagination:
 *                       $ref: '#/components/schemas/Pagination'
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.get('/users', adminController.getAllUsers);

/**
 * @swagger
 * /api/v1/admin/users/{id}:
 *   get:
 *     summary: Get user by ID (Admin only)
 *     description: Retrieve detailed information about a specific user
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     responses:
 *       200:
 *         description: User retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         user:
 *                           $ref: '#/components/schemas/User'
 *       404:
 *         description: User not found
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.get('/users/:id', adminController.getUserById);

/**
 * @swagger
 * /api/v1/admin/users/{id}:
 *   put:
 *     summary: Update user (Admin only)
 *     description: Update user information including role and status
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UserUpdate'
 *     responses:
 *       200:
 *         description: User updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         user:
 *                           $ref: '#/components/schemas/User'
 *       400:
 *         description: Bad request
 *       404:
 *         description: User not found
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.put('/users/:id', 
  validateRequest({
    body: Joi.object({
      firstName: Joi.string().min(2).optional(),
      lastName: Joi.string().min(2).optional(),
      role: Joi.string().valid('user', 'admin', 'moderator').optional(),
      isActive: Joi.boolean().optional(),
      avatar: Joi.string().uri().optional(),
    }),
  }),
  adminController.updateUser
);

/**
 * @swagger
 * /api/v1/admin/users/{id}/deactivate:
 *   post:
 *     summary: Deactivate user (Admin only)
 *     description: Deactivate a user account
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     responses:
 *       200:
 *         description: User deactivated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiResponse'
 *       404:
 *         description: User not found
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.post('/users/:id/deactivate', adminController.deactivateUser);

/**
 * @swagger
 * /api/v1/admin/users/{id}/activate:
 *   post:
 *     summary: Activate user (Admin only)
 *     description: Activate a user account
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *     responses:
 *       200:
 *         description: User activated successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiResponse'
 *       404:
 *         description: User not found
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.post('/users/:id/activate', adminController.activateUser);

/**
 * @swagger
 * /api/v1/admin/users/{id}/activity:
 *   get:
 *     summary: Get user activity log (Admin only)
 *     description: Retrieve activity log for a specific user
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: User ID
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 10
 *         description: Number of activities per page
 *     responses:
 *       200:
 *         description: User activity retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           id:
 *                             type: string
 *                           userId:
 *                             type: string
 *                           action:
 *                             type: string
 *                           details:
 *                             type: object
 *                           createdAt:
 *                             type: string
 *                             format: date-time
 *                     pagination:
 *                       $ref: '#/components/schemas/Pagination'
 *       404:
 *         description: User not found
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.get('/users/:id/activity', adminController.getUserActivity);

/**
 * @swagger
 * /api/v1/admin/users/bulk:
 *   post:
 *     summary: Bulk user operations (Admin only)
 *     description: Perform bulk operations on multiple users
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/BulkUserOperation'
 *     responses:
 *       200:
 *         description: Bulk operation completed successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         successCount:
 *                           type: integer
 *                         failedCount:
 *                           type: integer
 *                         errors:
 *                           type: array
 *                           items:
 *                             type: object
 *                             properties:
 *                               userId:
 *                                 type: string
 *                               error:
 *                                 type: string
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.post('/users/bulk',
  validateRequest({
    body: Joi.object({
      operation: Joi.string().valid('activate', 'deactivate', 'updateRole').required(),
      userIds: Joi.array().items(Joi.string().uuid()).min(1).required(),
      data: Joi.object({
        role: Joi.string().valid('user', 'admin', 'moderator').optional(),
      }).optional(),
    }),
  }),
  adminController.bulkUserOperations
);

/**
 * @swagger
 * /api/v1/admin/stats:
 *   get:
 *     summary: Get system statistics (Admin only)
 *     description: Retrieve system-wide statistics and metrics
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: System statistics retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         totalUsers:
 *                           type: integer
 *                         activeUsers:
 *                           type: integer
 *                         totalFiles:
 *                           type: integer
 *                         totalStorageUsed:
 *                           type: number
 *                         systemUptime:
 *                           type: number
 *                         apiRequests:
 *                           type: integer
 *                         errorRate:
 *                           type: number
 *                         averageResponseTime:
 *                           type: number
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.get('/stats', adminController.getSystemStats);

/**
 * @swagger
 * /api/v1/admin/analytics/users:
 *   get:
 *     summary: Get user analytics (Admin only)
 *     description: Retrieve detailed user analytics and trends
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: period
 *         schema:
 *           type: string
 *           enum: [7d, 30d, 90d]
 *           default: 30d
 *         description: Analytics period
 *     responses:
 *       200:
 *         description: User analytics retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         totalUsers:
 *                           type: integer
 *                         activeUsers:
 *                           type: integer
 *                         newUsers:
 *                           type: integer
 *                         userGrowth:
 *                           type: number
 *                         roleDistribution:
 *                           type: object
 *                         emailVerificationRate:
 *                           type: number
 *                         lastLoginDistribution:
 *                           type: object
 *                         userActivity:
 *                           type: array
 *                           items:
 *                             type: object
 *                             properties:
 *                               date:
 *                                 type: string
 *                               registrations:
 *                                 type: integer
 *                               logins:
 *                                 type: integer
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.get('/analytics/users', adminController.getUserAnalytics);

/**
 * @swagger
 * /api/v1/admin/users/export:
 *   get:
 *     summary: Export users (Admin only)
 *     description: Export users data in CSV or JSON format
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: format
 *         schema:
 *           type: string
 *           enum: [csv, json]
 *           default: csv
 *         description: Export format
 *       - in: query
 *         name: filters
 *         schema:
 *           type: object
 *         description: Filter criteria
 *     responses:
 *       200:
 *         description: Users exported successfully
 *         content:
 *           text/csv:
 *             schema:
 *               type: string
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/User'
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.get('/users/export', adminController.exportUsers);

/**
 * @swagger
 * /api/v1/admin/users/import:
 *   post:
 *     summary: Import users (Admin only)
 *     description: Import users from CSV or JSON data
 *     tags: [Admin]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/UserImport'
 *     responses:
 *       200:
 *         description: Users imported successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         successCount:
 *                           type: integer
 *                         failedCount:
 *                           type: integer
 *                         errors:
 *                           type: array
 *                           items:
 *                             type: object
 *                             properties:
 *                               userId:
 *                                 type: string
 *                               error:
 *                                 type: string
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       403:
 *         description: Forbidden - Admin role required
 *       500:
 *         description: Internal server error
 */
router.post('/users/import',
  validateRequest({
    body: Joi.object({
      users: Joi.array().items(
        Joi.object({
          email: Joi.string().email().required(),
          firstName: Joi.string().min(2).required(),
          lastName: Joi.string().min(2).required(),
          password: Joi.string().min(6).required(),
          role: Joi.string().valid('user', 'admin', 'moderator').optional(),
          isActive: Joi.boolean().optional(),
          isEmailVerified: Joi.boolean().optional(),
        })
      ).min(1).required(),
    }),
  }),
  adminController.importUsers
);

export default router;
