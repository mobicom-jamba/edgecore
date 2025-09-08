import { Router } from 'express';
import multer from 'multer';
import Joi from 'joi';
import { FileController } from '../controllers/FileController';
import { authMiddleware } from '../middleware/auth';
import { validateRequest, fileSchemas } from '../middleware/validation';
import { uploadRateLimit, fileUploadSecurity } from '../middleware/security';
import { UserRole } from '../types';

const router = Router();
const fileController = new FileController();

// Configure multer for file uploads
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
});

// All file routes require authentication
router.use(authMiddleware.authenticate);
router.use(authMiddleware.requireActiveUser);

/**
 * @swagger
 * /files/upload:
 *   post:
 *     summary: Upload a file
 *     description: Upload a file to the server with optional description and visibility settings
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - file
 *             properties:
 *               file:
 *                 type: string
 *                 format: binary
 *                 description: File to upload (max 10MB)
 *               description:
 *                 type: string
 *                 description: Optional file description
 *                 example: My important document
 *               isPublic:
 *                 type: boolean
 *                 description: Whether the file should be publicly accessible
 *                 default: false
 *     responses:
 *       201:
 *         description: File uploaded successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       $ref: '#/components/schemas/File'
 *       400:
 *         description: Bad request - validation error or file too large
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       413:
 *         description: File too large
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       429:
 *         description: Too many requests
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post('/upload', 
  uploadRateLimit,
  upload.single('file') as any,
  fileUploadSecurity,
  validateRequest({ body: fileSchemas.upload }),
  fileController.uploadFile
);

/**
 * @swagger
 * /files/{fileId}:
 *   get:
 *     summary: Get file details
 *     description: Get detailed information about a specific file
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: fileId
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: File unique identifier
 *     responses:
 *       200:
 *         description: File details retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       $ref: '#/components/schemas/File'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       403:
 *         description: Forbidden - user account is inactive
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       404:
 *         description: File not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/:fileId', 
  validateRequest({ params: Joi.object({ fileId: Joi.string().uuid().required() }) }),
  fileController.getFile
);

/**
 * @swagger
 * /files:
 *   get:
 *     summary: Get user's files
 *     description: Get a paginated list of files belonging to the authenticated user
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number for pagination
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 10
 *         description: Number of files per page
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search term for filename or description
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *           enum: [image, document, video, audio, other]
 *         description: Filter by file type
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *           enum: [createdAt, updatedAt, filename, size]
 *           default: createdAt
 *         description: Sort field
 *       - in: query
 *         name: sortOrder
 *         schema:
 *           type: string
 *           enum: [asc, desc]
 *           default: desc
 *         description: Sort order
 *     responses:
 *       200:
 *         description: Files retrieved successfully
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
 *                         $ref: '#/components/schemas/File'
 *                     pagination:
 *                       $ref: '#/components/schemas/ApiResponse/properties/pagination'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       403:
 *         description: Forbidden - user account is inactive
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/', 
  validateRequest({ query: fileSchemas.list }),
  fileController.getUserFiles
);

/**
 * @swagger
 * /files/{fileId}:
 *   put:
 *     summary: Update file
 *     description: Update file metadata (description, visibility)
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: fileId
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: File unique identifier
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               description:
 *                 type: string
 *                 description: File description
 *                 example: Updated file description
 *               isPublic:
 *                 type: boolean
 *                 description: Whether the file should be publicly accessible
 *                 example: true
 *     responses:
 *       200:
 *         description: File updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       $ref: '#/components/schemas/File'
 *       400:
 *         description: Bad request - validation error
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       403:
 *         description: Forbidden - user account is inactive or not file owner
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       404:
 *         description: File not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.put('/:fileId', 
  validateRequest({ 
    params: Joi.object({ fileId: Joi.string().uuid().required() }),
    body: fileSchemas.update 
  }),
  fileController.updateFile
);

/**
 * @swagger
 * /files/{fileId}:
 *   delete:
 *     summary: Delete file
 *     description: Delete a file (soft delete - marks as deleted but doesn't remove from storage)
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: fileId
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: File unique identifier
 *     responses:
 *       200:
 *         description: File deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiResponse'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       403:
 *         description: Forbidden - user account is inactive or not file owner
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       404:
 *         description: File not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.delete('/:fileId', 
  validateRequest({ params: Joi.object({ fileId: Joi.string().uuid().required() }) }),
  fileController.deleteFile
);

/**
 * @swagger
 * /files/{fileId}/download:
 *   get:
 *     summary: Get file download URL
 *     description: Get a secure download URL for a file
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: fileId
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: File unique identifier
 *     responses:
 *       200:
 *         description: Download URL generated successfully
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
 *                         downloadUrl:
 *                           type: string
 *                           format: uri
 *                           description: Secure download URL (expires in 1 hour)
 *                           example: https://s3.amazonaws.com/bucket/file.pdf?signature=...
 *                         expiresAt:
 *                           type: string
 *                           format: date-time
 *                           description: URL expiration time
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       403:
 *         description: Forbidden - user account is inactive or not file owner
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       404:
 *         description: File not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/:fileId/download', 
  validateRequest({ params: Joi.object({ fileId: Joi.string().uuid().required() }) }),
  fileController.getDownloadUrl
);

/**
 * @swagger
 * /files/stats/overview:
 *   get:
 *     summary: Get user file statistics
 *     description: Get overview statistics for the authenticated user's files
 *     tags: [Files]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: File statistics retrieved successfully
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
 *                         totalFiles:
 *                           type: integer
 *                           description: Total number of files
 *                           example: 25
 *                         totalSize:
 *                           type: integer
 *                           description: Total size in bytes
 *                           example: 104857600
 *                         filesByType:
 *                           type: object
 *                           properties:
 *                             image:
 *                               type: integer
 *                               example: 10
 *                             document:
 *                               type: integer
 *                               example: 8
 *                             video:
 *                               type: integer
 *                               example: 3
 *                             audio:
 *                               type: integer
 *                               example: 2
 *                             other:
 *                               type: integer
 *                               example: 2
 *                         publicFiles:
 *                           type: integer
 *                           description: Number of public files
 *                           example: 5
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       403:
 *         description: Forbidden - user account is inactive
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/stats/overview', 
  fileController.getFileStats
);

// Admin routes
/**
 * @swagger
 * /files/admin/all:
 *   get:
 *     summary: Get all files (Admin only)
 *     description: Get a paginated list of all files in the system (admin access required)
 *     tags: [Files, Admin]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number for pagination
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 10
 *         description: Number of files per page
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search term for filename or description
 *       - in: query
 *         name: type
 *         schema:
 *           type: string
 *           enum: [image, document, video, audio, other]
 *         description: Filter by file type
 *       - in: query
 *         name: userId
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Filter by user ID
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *           enum: [createdAt, updatedAt, filename, size]
 *           default: createdAt
 *         description: Sort field
 *       - in: query
 *         name: sortOrder
 *         schema:
 *           type: string
 *           enum: [asc, desc]
 *           default: desc
 *         description: Sort order
 *     responses:
 *       200:
 *         description: Files retrieved successfully
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
 *                         allOf:
 *                           - $ref: '#/components/schemas/File'
 *                           - type: object
 *                             properties:
 *                               user:
 *                                 type: object
 *                                 properties:
 *                                   id:
 *                                     type: string
 *                                     format: uuid
 *                                   email:
 *                                     type: string
 *                                   firstName:
 *                                     type: string
 *                                   lastName:
 *                                     type: string
 *                     pagination:
 *                       $ref: '#/components/schemas/ApiResponse/properties/pagination'
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       403:
 *         description: Forbidden - admin access required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/admin/all', 
  authMiddleware.authorize(UserRole.ADMIN),
  validateRequest({ query: fileSchemas.list }),
  fileController.getAllFiles
);

/**
 * @swagger
 * /files/admin/stats:
 *   get:
 *     summary: Get system file statistics (Admin only)
 *     description: Get comprehensive file statistics for the entire system (admin access required)
 *     tags: [Files, Admin]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: System file statistics retrieved successfully
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
 *                         totalFiles:
 *                           type: integer
 *                           description: Total number of files in system
 *                           example: 1250
 *                         totalSize:
 *                           type: integer
 *                           description: Total size in bytes
 *                           example: 5242880000
 *                         totalUsers:
 *                           type: integer
 *                           description: Number of users with files
 *                           example: 45
 *                         filesByType:
 *                           type: object
 *                           properties:
 *                             image:
 *                               type: integer
 *                               example: 500
 *                             document:
 *                               type: integer
 *                               example: 400
 *                             video:
 *                               type: integer
 *                               example: 200
 *                             audio:
 *                               type: integer
 *                               example: 100
 *                             other:
 *                               type: integer
 *                               example: 50
 *                         publicFiles:
 *                           type: integer
 *                           description: Number of public files
 *                           example: 200
 *                         averageFilesPerUser:
 *                           type: number
 *                           format: float
 *                           description: Average files per user
 *                           example: 27.78
 *       401:
 *         description: Unauthorized - invalid or missing token
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       403:
 *         description: Forbidden - admin access required
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/admin/stats', 
  authMiddleware.authorize(UserRole.ADMIN),
  fileController.getAdminFileStats
);

export default router;
