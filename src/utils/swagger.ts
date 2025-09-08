// @ts-ignore - swagger-jsdoc types not available
import swaggerJsdoc from 'swagger-jsdoc';
import { config } from '../config';

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'EdgeCore API',
      version: '1.0.0',
      description: 'A professional, reusable backend framework with clean architecture',
      contact: {
        name: 'EdgeCore Team',
        email: 'support@edgecore.com',
      },
      license: {
        name: 'MIT',
        url: 'https://opensource.org/licenses/MIT',
      },
    },
    servers: [
      {
        url: `http://localhost:${config.port}/api/${config.apiVersion}`,
        description: 'Development server',
      },
      {
        url: `https://api.edgecore.com/api/${config.apiVersion}`,
        description: 'Production server',
      },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
          description: 'JWT token obtained from login endpoint',
        },
      },
      schemas: {
        User: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              format: 'uuid',
              description: 'User unique identifier',
            },
            email: {
              type: 'string',
              format: 'email',
              description: 'User email address',
            },
            firstName: {
              type: 'string',
              description: 'User first name',
            },
            lastName: {
              type: 'string',
              description: 'User last name',
            },
            role: {
              type: 'string',
              enum: ['admin', 'user', 'moderator'],
              description: 'User role',
            },
            isEmailVerified: {
              type: 'boolean',
              description: 'Email verification status',
            },
            isActive: {
              type: 'boolean',
              description: 'Account active status',
            },
            avatar: {
              type: 'string',
              format: 'uri',
              description: 'User avatar URL',
            },
            createdAt: {
              type: 'string',
              format: 'date-time',
              description: 'Account creation timestamp',
            },
            updatedAt: {
              type: 'string',
              format: 'date-time',
              description: 'Last update timestamp',
            },
          },
        },
        File: {
          type: 'object',
          properties: {
            id: {
              type: 'string',
              format: 'uuid',
              description: 'File unique identifier',
            },
            filename: {
              type: 'string',
              description: 'Generated filename',
            },
            originalName: {
              type: 'string',
              description: 'Original filename',
            },
            mimetype: {
              type: 'string',
              description: 'File MIME type',
            },
            size: {
              type: 'integer',
              description: 'File size in bytes',
            },
            url: {
              type: 'string',
              format: 'uri',
              description: 'File URL',
            },
            type: {
              type: 'string',
              enum: ['image', 'document', 'video', 'audio', 'other'],
              description: 'File type category',
            },
            description: {
              type: 'string',
              description: 'File description',
            },
            isPublic: {
              type: 'boolean',
              description: 'Public visibility status',
            },
            metadata: {
              type: 'object',
              description: 'Additional file metadata',
            },
            createdAt: {
              type: 'string',
              format: 'date-time',
              description: 'Upload timestamp',
            },
            updatedAt: {
              type: 'string',
              format: 'date-time',
              description: 'Last update timestamp',
            },
          },
        },
        ApiResponse: {
          type: 'object',
          properties: {
            success: {
              type: 'boolean',
              description: 'Request success status',
            },
            message: {
              type: 'string',
              description: 'Response message',
            },
            data: {
              type: 'object',
              description: 'Response data',
            },
            error: {
              type: 'string',
              description: 'Error message (if any)',
            },
            pagination: {
              type: 'object',
              properties: {
                page: {
                  type: 'integer',
                  description: 'Current page number',
                },
                limit: {
                  type: 'integer',
                  description: 'Items per page',
                },
                total: {
                  type: 'integer',
                  description: 'Total number of items',
                },
                totalPages: {
                  type: 'integer',
                  description: 'Total number of pages',
                },
              },
            },
          },
        },
        Error: {
          type: 'object',
          properties: {
            success: {
              type: 'boolean',
              example: false,
            },
            message: {
              type: 'string',
              description: 'Error message',
            },
            error: {
              type: 'string',
              description: 'Detailed error information',
            },
          },
        },
        LoginRequest: {
          type: 'object',
          required: ['email', 'password'],
          properties: {
            email: {
              type: 'string',
              format: 'email',
              example: 'user@example.com',
            },
            password: {
              type: 'string',
              example: 'password123',
            },
          },
        },
        RegisterRequest: {
          type: 'object',
          required: ['email', 'password', 'firstName', 'lastName'],
          properties: {
            email: {
              type: 'string',
              format: 'email',
              example: 'user@example.com',
            },
            password: {
              type: 'string',
              minLength: 6,
              example: 'password123',
            },
            firstName: {
              type: 'string',
              minLength: 2,
              example: 'John',
            },
            lastName: {
              type: 'string',
              minLength: 2,
              example: 'Doe',
            },
          },
        },
        TokenResponse: {
          type: 'object',
          properties: {
            accessToken: {
              type: 'string',
              description: 'JWT access token',
              example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
            },
            refreshToken: {
              type: 'string',
              description: 'JWT refresh token',
              example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
            },
          },
        },
        FileUploadRequest: {
          type: 'object',
          required: ['file'],
          properties: {
            file: {
              type: 'string',
              format: 'binary',
              description: 'File to upload (max 10MB)',
            },
            description: {
              type: 'string',
              description: 'Optional file description',
              example: 'My important document',
            },
            isPublic: {
              type: 'boolean',
              description: 'Whether the file should be publicly accessible',
              default: false,
            },
          },
        },
        FileUpdateRequest: {
          type: 'object',
          properties: {
            description: {
              type: 'string',
              description: 'File description',
              example: 'Updated file description',
            },
            isPublic: {
              type: 'boolean',
              description: 'Whether the file should be publicly accessible',
              example: true,
            },
          },
        },
        PaginationQuery: {
          type: 'object',
          properties: {
            page: {
              type: 'integer',
              minimum: 1,
              default: 1,
              description: 'Page number for pagination',
            },
            limit: {
              type: 'integer',
              minimum: 1,
              maximum: 100,
              default: 10,
              description: 'Number of items per page',
            },
            search: {
              type: 'string',
              description: 'Search term',
            },
            sortBy: {
              type: 'string',
              enum: ['createdAt', 'updatedAt', 'filename', 'size'],
              default: 'createdAt',
              description: 'Sort field',
            },
            sortOrder: {
              type: 'string',
              enum: ['asc', 'desc'],
              default: 'desc',
              description: 'Sort order',
            },
          },
        },
      },
    },
    tags: [
      {
        name: 'Authentication',
        description: 'User authentication and authorization endpoints',
      },
      {
        name: 'Files',
        description: 'File management endpoints',
      },
      {
        name: 'Admin',
        description: 'Administrative endpoints (admin access required)',
      },
      {
        name: 'System',
        description: 'System health and monitoring endpoints',
      },
    ],
    security: [
      {
        bearerAuth: [],
      },
    ],
  },
  apis: ['./src/routes/*.ts', './src/controllers/*.ts'], // Path to the API files
};

export const swaggerSpec = swaggerJsdoc(options);
