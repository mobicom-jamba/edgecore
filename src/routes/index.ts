import { Router } from 'express';
import authRoutes from './auth';
import fileRoutes from './files';
import { ApiResponse } from '../types';

const router = Router();

// Health check endpoint
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

// 404 handler for API routes
router.use('*', (req, res) => {
  const response: ApiResponse = {
    success: false,
    message: 'API endpoint not found',
  };
  res.status(404).json(response);
});

export default router;
