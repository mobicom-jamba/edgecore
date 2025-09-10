import { Router } from 'express';
import authRoutes from './auth';
import fileRoutes from './files';
import adminRoutes from './admin';
import billingRoutes from './billing';
import { ApiResponse } from '../types';

const router = Router();

/**
 * @swagger
 * /health:
 *   get:
 *     summary: Health check
 *     description: Check if the server is running and healthy
 *     tags: [System]
 *     security: []
 *     responses:
 *       200:
 *         description: Server is healthy
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
 *                         timestamp:
 *                           type: string
 *                           format: date-time
 *                           description: Current server timestamp
 *                           example: "2023-12-01T10:30:00.000Z"
 *                         uptime:
 *                           type: number
 *                           format: float
 *                           description: Server uptime in seconds
 *                           example: 3600.5
 *                         environment:
 *                           type: string
 *                           description: Current environment
 *                           example: "development"
 *                         version:
 *                           type: string
 *                           description: Application version
 *                           example: "1.0.0"
 *       500:
 *         description: Server is unhealthy
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get('/health', (req, res) => {
  const response: ApiResponse = {
    success: true,
    message: 'Server is healthy',
    data: {
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'development',
      version: process.env.npm_package_version || '1.0.0',
    },
  };
  res.json(response);
});

// API routes
router.use('/auth', authRoutes);
router.use('/files', fileRoutes);
router.use('/admin', adminRoutes);
router.use('/billing', billingRoutes);

// 404 handler for API routes
router.use('*', (req, res) => {
  const response: ApiResponse = {
    success: false,
    message: 'API endpoint not found',
  };
  res.status(404).json(response);
});

export default router;
