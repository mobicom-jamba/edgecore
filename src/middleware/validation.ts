import { Request, Response, NextFunction } from 'express';
import Joi from 'joi';
import { ApiResponse } from '../types';

export const validateRequest = (schema: {
  body?: Joi.ObjectSchema;
  query?: Joi.ObjectSchema;
  params?: Joi.ObjectSchema;
}) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const errors: string[] = [];

    // Validate request body
    if (schema.body) {
      const { error } = schema.body.validate(req.body);
      if (error) {
        errors.push(`Body: ${error.details.map(d => d.message).join(', ')}`);
      }
    }

    // Validate query parameters
    if (schema.query) {
      const { error } = schema.query.validate(req.query);
      if (error) {
        errors.push(`Query: ${error.details.map(d => d.message).join(', ')}`);
      }
    }

    // Validate route parameters
    if (schema.params) {
      const { error } = schema.params.validate(req.params);
      if (error) {
        errors.push(`Params: ${error.details.map(d => d.message).join(', ')}`);
      }
    }

    if (errors.length > 0) {
      const response: ApiResponse = {
        success: false,
        message: 'Validation failed',
        error: errors.join('; '),
      };
      res.status(400).json(response);
      return;
    }

    next();
  };
};

// Common validation schemas
export const commonSchemas = {
  id: Joi.string().uuid().required(),
  email: Joi.string().email().required(),
  password: Joi.string().min(6).max(128).required(),
  pagination: Joi.object({
    page: Joi.number().integer().min(1).default(1),
    limit: Joi.number().integer().min(1).max(100).default(10),
    sortBy: Joi.string().default('createdAt'),
    sortOrder: Joi.string().valid('ASC', 'DESC').default('DESC'),
  }),
  search: Joi.object({
    search: Joi.string().max(255).optional(),
    filters: Joi.object().optional(),
  }),
};

// Auth validation schemas
export const authSchemas = {
  register: Joi.object({
    email: commonSchemas.email,
    firstName: Joi.string().min(2).max(50).required(),
    lastName: Joi.string().min(2).max(50).required(),
    password: commonSchemas.password,
  }),
  login: Joi.object({
    email: commonSchemas.email,
    password: Joi.string().required(),
  }),
  forgotPassword: Joi.object({
    email: commonSchemas.email,
  }),
  resetPassword: Joi.object({
    token: Joi.string().required(),
    password: commonSchemas.password,
  }),
  changePassword: Joi.object({
    currentPassword: Joi.string().required(),
    newPassword: commonSchemas.password,
  }),
  verifyEmail: Joi.object({
    token: Joi.string().required(),
  }),
};

// File validation schemas
export const fileSchemas = {
  upload: Joi.object({
    description: Joi.string().max(500).optional(),
    isPublic: Joi.boolean().default(false),
    metadata: Joi.object().optional(),
  }),
  update: Joi.object({
    description: Joi.string().max(500).optional(),
    isPublic: Joi.boolean().optional(),
    metadata: Joi.object().optional(),
  }),
  list: Joi.object({
    ...commonSchemas.pagination.describe(),
    ...commonSchemas.search.describe(),
    type: Joi.string().valid('image', 'document', 'video', 'audio', 'other').optional(),
    mimetype: Joi.string().optional(),
    isPublic: Joi.boolean().optional(),
    userId: Joi.string().uuid().optional(),
  }),
};

// User validation schemas
export const userSchemas = {
  update: Joi.object({
    firstName: Joi.string().min(2).max(50).optional(),
    lastName: Joi.string().min(2).max(50).optional(),
    avatar: Joi.string().uri().optional(),
  }),
  updateRole: Joi.object({
    role: Joi.string().valid('admin', 'user', 'moderator').required(),
  }),
};

// Sanitization middleware
export const sanitizeInput = (req: Request, res: Response, next: NextFunction) => {
  // Remove potentially dangerous characters from string inputs
  const sanitizeString = (str: string): string => {
    return str
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '') // Remove script tags
      .replace(/javascript:/gi, '') // Remove javascript: protocol
      .replace(/on\w+\s*=/gi, '') // Remove event handlers
      .trim();
  };

  const sanitizeObject = (obj: any): any => {
    if (typeof obj === 'string') {
      return sanitizeString(obj);
    } else if (Array.isArray(obj)) {
      return obj.map(sanitizeObject);
    } else if (obj && typeof obj === 'object') {
      const sanitized: any = {};
      for (const key in obj) {
        sanitized[key] = sanitizeObject(obj[key]);
      }
      return sanitized;
    }
    return obj;
  };

  // Sanitize request body
  if (req.body) {
    req.body = sanitizeObject(req.body);
  }

  // Sanitize query parameters
  if (req.query) {
    req.query = sanitizeObject(req.query);
  }

  next();
};

// File validation middleware
export const validateFileUpload = (req: Request, res: Response, next: NextFunction) => {
  if (!req.file) {
    const response: ApiResponse = {
      success: false,
      message: 'No file uploaded',
    };
    res.status(400).json(response);
    return;
  }

  // Additional file validation can be added here
  next();
};
