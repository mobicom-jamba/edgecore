import { Request, Response } from 'express';
import { FileService } from '../services/FileService';
import { AuthenticatedRequest, ApiResponse, SearchQuery } from '../types';
import { logError, logInfo, businessLogger } from '../utils/logger';

export class FileController {
  private fileService: FileService;

  constructor() {
    this.fileService = new FileService();
  }

  uploadFile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const file = req.file!;
      const { description, isPublic, metadata } = req.body;

      const uploadedFile = await this.fileService.uploadFile(file, user, {
        description,
        isPublic: isPublic === 'true',
        metadata: metadata ? JSON.parse(metadata) : undefined,
      });

      businessLogger('file_uploaded', user.id, {
        fileId: uploadedFile.id,
        filename: uploadedFile.originalName,
        size: uploadedFile.size,
        type: uploadedFile.type,
      });

      const response: ApiResponse = {
        success: true,
        message: 'File uploaded successfully',
        data: { file: uploadedFile.toJSON() },
      };

      res.status(201).json(response);
    } catch (error) {
      logError(error as Error, 'FileController.uploadFile');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'File upload failed',
      };

      res.status(400).json(response);
    }
  };

  getFile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const { fileId } = req.params;
      const user = req.user!;

      const file = await this.fileService.getFileById(fileId, user);

      if (!file) {
        const response: ApiResponse = {
          success: false,
          message: 'File not found or access denied',
        };
        res.status(404).json(response);
        return;
      }

      const response: ApiResponse = {
        success: true,
        message: 'File retrieved successfully',
        data: { file: file.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'FileController.getFile');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to retrieve file',
      };

      res.status(500).json(response);
    }
  };

  getUserFiles = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const query: SearchQuery = {
        page: parseInt(req.query.page as string) || 1,
        limit: parseInt(req.query.limit as string) || 10,
        search: req.query.search as string,
        filters: {
          type: req.query.type as string,
          mimetype: req.query.mimetype as string,
          isPublic: req.query.isPublic === 'true' ? true : req.query.isPublic === 'false' ? false : undefined,
        },
        sortBy: req.query.sortBy as string || 'createdAt',
        sortOrder: (req.query.sortOrder as 'ASC' | 'DESC') || 'DESC',
      };

      const result = await this.fileService.getUserFiles(user, query);

      const response: ApiResponse = {
        success: true,
        message: 'Files retrieved successfully',
        data: { files: result.files.map(file => file.toJSON()) },
        pagination: {
          page: query.page!,
          limit: query.limit!,
          total: result.total,
          totalPages: Math.ceil(result.total / query.limit!),
        },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'FileController.getUserFiles');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to retrieve files',
      };

      res.status(500).json(response);
    }
  };

  getAllFiles = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const query: SearchQuery = {
        page: parseInt(req.query.page as string) || 1,
        limit: parseInt(req.query.limit as string) || 10,
        search: req.query.search as string,
        filters: {
          type: req.query.type as string,
          mimetype: req.query.mimetype as string,
          isPublic: req.query.isPublic === 'true' ? true : req.query.isPublic === 'false' ? false : undefined,
          userId: req.query.userId as string,
        },
        sortBy: req.query.sortBy as string || 'createdAt',
        sortOrder: (req.query.sortOrder as 'ASC' | 'DESC') || 'DESC',
      };

      const result = await this.fileService.getAllFiles(query);

      const response: ApiResponse = {
        success: true,
        message: 'Files retrieved successfully',
        data: { files: result.files.map(file => file.toJSON()) },
        pagination: {
          page: query.page!,
          limit: query.limit!,
          total: result.total,
          totalPages: Math.ceil(result.total / query.limit!),
        },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'FileController.getAllFiles');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to retrieve files',
      };

      res.status(500).json(response);
    }
  };

  updateFile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const { fileId } = req.params;
      const user = req.user!;
      const { description, isPublic, metadata } = req.body;

      const updatedFile = await this.fileService.updateFile(fileId, user, {
        description,
        isPublic,
        metadata: metadata ? JSON.parse(metadata) : undefined,
      });

      if (!updatedFile) {
        const response: ApiResponse = {
          success: false,
          message: 'File not found or access denied',
        };
        res.status(404).json(response);
        return;
      }

      businessLogger('file_updated', user.id, {
        fileId: updatedFile.id,
        changes: { description, isPublic, metadata },
      });

      const response: ApiResponse = {
        success: true,
        message: 'File updated successfully',
        data: { file: updatedFile.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'FileController.updateFile');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to update file',
      };

      res.status(500).json(response);
    }
  };

  deleteFile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const { fileId } = req.params;
      const user = req.user!;

      const deleted = await this.fileService.deleteFile(fileId, user);

      if (!deleted) {
        const response: ApiResponse = {
          success: false,
          message: 'File not found or access denied',
        };
        res.status(404).json(response);
        return;
      }

      businessLogger('file_deleted', user.id, { fileId });

      const response: ApiResponse = {
        success: true,
        message: 'File deleted successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'FileController.deleteFile');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to delete file',
      };

      res.status(500).json(response);
    }
  };

  getDownloadUrl = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const { fileId } = req.params;
      const user = req.user!;

      const downloadUrl = await this.fileService.getFileDownloadUrl(fileId, user);

      if (!downloadUrl) {
        const response: ApiResponse = {
          success: false,
          message: 'File not found or access denied',
        };
        res.status(404).json(response);
        return;
      }

      businessLogger('file_download_requested', user.id, { fileId });

      const response: ApiResponse = {
        success: true,
        message: 'Download URL generated successfully',
        data: { downloadUrl },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'FileController.getDownloadUrl');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to generate download URL',
      };

      res.status(500).json(response);
    }
  };

  getFileStats = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const stats = await this.fileService.getFileStats(user);

      const response: ApiResponse = {
        success: true,
        message: 'File statistics retrieved successfully',
        data: { stats },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'FileController.getFileStats');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to retrieve file statistics',
      };

      res.status(500).json(response);
    }
  };

  getAdminFileStats = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const stats = await this.fileService.getFileStats();

      const response: ApiResponse = {
        success: true,
        message: 'Admin file statistics retrieved successfully',
        data: { stats },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'FileController.getAdminFileStats');
      
      const response: ApiResponse = {
        success: false,
        message: 'Failed to retrieve admin file statistics',
      };

      res.status(500).json(response);
    }
  };
}
