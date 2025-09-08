import { Router } from 'express';
import multer from 'multer';
import Joi from 'joi';
import { FileController } from '../controllers/FileController';
import { authMiddleware } from '../middleware/auth';
import { validateRequest, fileSchemas } from '../middleware/validation';
import { uploadRateLimit, fileUploadSecurity } from '../middleware/security';

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

// File upload
router.post('/upload', 
  uploadRateLimit,
  upload.single('file'),
  fileUploadSecurity,
  validateRequest({ body: fileSchemas.upload }),
  fileController.uploadFile
);

// Get single file
router.get('/:fileId', 
  validateRequest({ params: Joi.object({ fileId: Joi.string().uuid().required() }) }),
  fileController.getFile
);

// Get user's files
router.get('/', 
  validateRequest({ query: fileSchemas.list }),
  fileController.getUserFiles
);

// Update file
router.put('/:fileId', 
  validateRequest({ 
    params: Joi.object({ fileId: Joi.string().uuid().required() }),
    body: fileSchemas.update 
  }),
  fileController.updateFile
);

// Delete file
router.delete('/:fileId', 
  validateRequest({ params: Joi.object({ fileId: Joi.string().uuid().required() }) }),
  fileController.deleteFile
);

// Get download URL
router.get('/:fileId/download', 
  validateRequest({ params: Joi.object({ fileId: Joi.string().uuid().required() }) }),
  fileController.getDownloadUrl
);

// Get file statistics
router.get('/stats/overview', 
  fileController.getFileStats
);

// Admin routes
router.get('/admin/all', 
  authMiddleware.authorize('admin'),
  validateRequest({ query: fileSchemas.list }),
  fileController.getAllFiles
);

router.get('/admin/stats', 
  authMiddleware.authorize('admin'),
  fileController.getAdminFileStats
);

export default router;
