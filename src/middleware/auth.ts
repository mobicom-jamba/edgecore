import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { config } from '../config';
import { AuthenticatedRequest, JWTPayload, UserRole } from '../types';
import { AuthService } from '../services/AuthService';

export class AuthMiddleware {
  private authService: AuthService;

  constructor() {
    this.authService = new AuthService();
  }

  authenticate = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const authHeader = req.headers.authorization;
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        res.status(401).json({
          success: false,
          message: 'Access token required',
        });
        return;
      }

      const token = authHeader.substring(7);
      
      try {
        const decoded = jwt.verify(token, config.jwt.secret) as JWTPayload;
        const user = await this.authService.getUserById(decoded.userId);
        
        if (!user) {
          res.status(401).json({
            success: false,
            message: 'Invalid token - user not found',
          });
          return;
        }

        req.user = user;
        next();
      } catch (jwtError) {
        res.status(401).json({
          success: false,
          message: 'Invalid or expired token',
        });
        return;
      }
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Authentication error',
        error: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  };

  authorize = (...roles: UserRole[]) => {
    return (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
      if (!req.user) {
        res.status(401).json({
          success: false,
          message: 'Authentication required',
        });
        return;
      }

      if (!roles.includes(req.user.role)) {
        res.status(403).json({
          success: false,
          message: 'Insufficient permissions',
        });
        return;
      }

      next();
    };
  };

  optionalAuth = async (req: AuthenticatedRequest, res: Response, next: NextFunction): Promise<void> => {
    try {
      const authHeader = req.headers.authorization;
      
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        next();
        return;
      }

      const token = authHeader.substring(7);
      
      try {
        const decoded = jwt.verify(token, config.jwt.secret) as JWTPayload;
        const user = await this.authService.getUserById(decoded.userId);
        
        if (user) {
          req.user = user;
        }
      } catch (jwtError) {
        // Ignore JWT errors for optional auth
      }

      next();
    } catch (error) {
      next();
    }
  };

  requireEmailVerification = (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({
        success: false,
        message: 'Authentication required',
      });
      return;
    }

    if (!req.user.isEmailVerified) {
      res.status(403).json({
        success: false,
        message: 'Email verification required',
      });
      return;
    }

    next();
  };

  requireActiveUser = (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({
        success: false,
        message: 'Authentication required',
      });
      return;
    }

    if (!req.user.isActive) {
      res.status(403).json({
        success: false,
        message: 'Account is deactivated',
      });
      return;
    }

    next();
  };
}

export const authMiddleware = new AuthMiddleware();
