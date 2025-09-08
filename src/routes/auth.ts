import { Router } from 'express';
import Joi from 'joi';
import { AuthController } from '../controllers/AuthController';
import { authMiddleware } from '../middleware/auth';
import { validateRequest, authSchemas } from '../middleware/validation';
import { authRateLimit } from '../middleware/security';

const router = Router();
const authController = new AuthController();

// Public routes
router.post('/register', 
  authRateLimit,
  validateRequest({ body: authSchemas.register }),
  authController.register
);

router.post('/login', 
  authRateLimit,
  validateRequest({ body: authSchemas.login }),
  authController.login
);

router.post('/refresh-token', 
  validateRequest({ body: Joi.object({ refreshToken: Joi.string().required() }) }),
  authController.refreshToken
);

router.post('/forgot-password', 
  authRateLimit,
  validateRequest({ body: authSchemas.forgotPassword }),
  authController.forgotPassword
);

router.post('/reset-password', 
  authRateLimit,
  validateRequest({ body: authSchemas.resetPassword }),
  authController.resetPassword
);

router.post('/verify-email', 
  validateRequest({ body: authSchemas.verifyEmail }),
  authController.verifyEmail
);

router.post('/resend-verification', 
  authRateLimit,
  validateRequest({ body: authSchemas.forgotPassword }), // Same schema as forgot password
  authController.resendVerification
);

// Protected routes
router.get('/profile', 
  authMiddleware.authenticate,
  authMiddleware.requireActiveUser,
  authController.getProfile
);

router.post('/change-password', 
  authMiddleware.authenticate,
  authMiddleware.requireActiveUser,
  validateRequest({ body: authSchemas.changePassword }),
  authController.changePassword
);

router.post('/logout', 
  authMiddleware.authenticate,
  authController.logout
);

export default router;
