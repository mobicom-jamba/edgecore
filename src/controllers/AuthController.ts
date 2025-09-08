import { Request, Response } from 'express';
import { AuthService } from '../services/AuthService';
import { AuthenticatedRequest, ApiResponse } from '../types';
import { logError, logInfo, businessLogger } from '../utils/logger';

export class AuthController {
  private authService: AuthService;

  constructor() {
    this.authService = new AuthService();
  }

  register = async (req: Request, res: Response): Promise<void> => {
    try {
      const { email, firstName, lastName, password } = req.body;

      const result = await this.authService.register({
        email,
        firstName,
        lastName,
        password,
      });

      businessLogger('user_registration', undefined, { email, firstName, lastName });

      const response: ApiResponse = {
        success: true,
        message: 'User registered successfully',
        data: {
          user: result.user.toJSON(),
          tokens: result.tokens,
        },
      };

      res.status(201).json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.register');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Registration failed',
      };

      res.status(400).json(response);
    }
  };

  login = async (req: Request, res: Response): Promise<void> => {
    try {
      const { email, password } = req.body;

      const result = await this.authService.login(email, password);

      businessLogger('user_login', result.user.id, { email });

      const response: ApiResponse = {
        success: true,
        message: 'Login successful',
        data: {
          user: result.user.toJSON(),
          tokens: result.tokens,
        },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.login');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Login failed',
      };

      res.status(401).json(response);
    }
  };

  refreshToken = async (req: Request, res: Response): Promise<void> => {
    try {
      const { refreshToken } = req.body;

      const tokens = await this.authService.refreshToken(refreshToken);

      const response: ApiResponse = {
        success: true,
        message: 'Token refreshed successfully',
        data: { tokens },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.refreshToken');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Token refresh failed',
      };

      res.status(401).json(response);
    }
  };

  forgotPassword = async (req: Request, res: Response): Promise<void> => {
    try {
      const { email } = req.body;

      await this.authService.forgotPassword(email);

      businessLogger('password_reset_requested', undefined, { email });

      const response: ApiResponse = {
        success: true,
        message: 'Password reset email sent if account exists',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.forgotPassword');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to process password reset request',
      };

      res.status(500).json(response);
    }
  };

  resetPassword = async (req: Request, res: Response): Promise<void> => {
    try {
      const { token, password } = req.body;

      await this.authService.resetPassword(token, password);

      businessLogger('password_reset_completed', undefined, { token: token.substring(0, 8) + '...' });

      const response: ApiResponse = {
        success: true,
        message: 'Password reset successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.resetPassword');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Password reset failed',
      };

      res.status(400).json(response);
    }
  };

  verifyEmail = async (req: Request, res: Response): Promise<void> => {
    try {
      const { token } = req.body;

      await this.authService.verifyEmail(token);

      businessLogger('email_verified', undefined, { token: token.substring(0, 8) + '...' });

      const response: ApiResponse = {
        success: true,
        message: 'Email verified successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.verifyEmail');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Email verification failed',
      };

      res.status(400).json(response);
    }
  };

  resendVerification = async (req: Request, res: Response): Promise<void> => {
    try {
      const { email } = req.body;

      await this.authService.resendVerificationEmail(email);

      businessLogger('verification_email_resent', undefined, { email });

      const response: ApiResponse = {
        success: true,
        message: 'Verification email sent if account exists and is unverified',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.resendVerification');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to resend verification email',
      };

      res.status(500).json(response);
    }
  };

  getProfile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;

      const response: ApiResponse = {
        success: true,
        message: 'Profile retrieved successfully',
        data: { user: user.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.getProfile');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to retrieve profile',
      };

      res.status(500).json(response);
    }
  };

  changePassword = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const { currentPassword, newPassword } = req.body;
      const user = req.user!;

      // Verify current password
      const isCurrentPasswordValid = await user.validatePassword(currentPassword);
      if (!isCurrentPasswordValid) {
        const response: ApiResponse = {
          success: false,
          message: 'Current password is incorrect',
        };
        res.status(400).json(response);
        return;
      }

      // Update password
      user.password = newPassword;
      await this.authService['userRepository'].save(user);

      businessLogger('password_changed', user.id);

      const response: ApiResponse = {
        success: true,
        message: 'Password changed successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.changePassword');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to change password',
      };

      res.status(500).json(response);
    }
  };

  logout = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;

      businessLogger('user_logout', user.id);

      const response: ApiResponse = {
        success: true,
        message: 'Logged out successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'AuthController.logout');
      
      const response: ApiResponse = {
        success: false,
        message: 'Logout failed',
      };

      res.status(500).json(response);
    }
  };
}
