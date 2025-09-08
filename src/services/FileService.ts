import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { File } from '../models/File';
import { User } from '../models/User';
import { FileUploadResult, FileType, SearchQuery, PaginationQuery } from '../types';
import { config } from '../config';
import { S3Service } from './S3Service';
import { v4 as uuidv4 } from 'uuid';
import path from 'path';

export class FileService {
  private fileRepository: Repository<File>;
  private s3Service: S3Service;

  constructor() {
    this.fileRepository = AppDataSource.getRepository(File);
    this.s3Service = new S3Service();
  }

  async uploadFile(
    file: Express.Multer.File,
    user: User,
    options: {
      isPublic?: boolean;
      description?: string;
      metadata?: Record<string, any>;
    } = {}
  ): Promise<File> {
    // Validate file
    this.validateFile(file);

    // Generate unique filename
    const fileExtension = path.extname(file.originalname);
    const filename = `${uuidv4()}${fileExtension}`;
    const key = `uploads/${user.id}/${filename}`;

    // Upload to S3
    const uploadResult = await this.s3Service.uploadFile(file.buffer, key, file.mimetype);

    // Determine file type
    const fileType = this.determineFileType(file.mimetype);

    // Save file metadata to database
    const fileEntity = this.fileRepository.create({
      filename,
      originalName: file.originalname,
      mimetype: file.mimetype,
      size: file.size,
      url: uploadResult.url,
      key,
      type: fileType,
      description: options.description,
      isPublic: options.isPublic ?? false,
      metadata: options.metadata,
      userId: user.id,
    });

    return this.fileRepository.save(fileEntity);
  }

  async getFileById(fileId: string, user: User): Promise<File | null> {
    const file = await this.fileRepository.findOne({
      where: { id: fileId, isDeleted: false },
      relations: ['user'],
    });

    if (!file) {
      return null;
    }

    // Check if user has access to the file
    if (!file.isPublic && file.userId !== user.id && user.role !== 'admin') {
      return null;
    }

    return file;
  }

  async getUserFiles(user: User, query: SearchQuery): Promise<{ files: File[]; total: number }> {
    const {
      page = 1,
      limit = 10,
      search,
      filters = {},
      sortBy = 'createdAt',
      sortOrder = 'DESC',
    } = query;

    const queryBuilder = this.fileRepository
      .createQueryBuilder('file')
      .where('file.userId = :userId', { userId: user.id })
      .andWhere('file.isDeleted = :isDeleted', { isDeleted: false });

    // Apply search
    if (search) {
      queryBuilder.andWhere(
        '(file.originalName ILIKE :search OR file.description ILIKE :search)',
        { search: `%${search}%` }
      );
    }

    // Apply filters
    if (filters.type) {
      queryBuilder.andWhere('file.type = :type', { type: filters.type });
    }

    if (filters.mimetype) {
      queryBuilder.andWhere('file.mimetype = :mimetype', { mimetype: filters.mimetype });
    }

    if (filters.isPublic !== undefined) {
      queryBuilder.andWhere('file.isPublic = :isPublic', { isPublic: filters.isPublic });
    }

    // Apply sorting
    queryBuilder.orderBy(`file.${sortBy}`, sortOrder);

    // Apply pagination
    const offset = (page - 1) * limit;
    queryBuilder.skip(offset).take(limit);

    const [files, total] = await queryBuilder.getManyAndCount();

    return { files, total };
  }

  async getAllFiles(query: SearchQuery): Promise<{ files: File[]; total: number }> {
    const {
      page = 1,
      limit = 10,
      search,
      filters = {},
      sortBy = 'createdAt',
      sortOrder = 'DESC',
    } = query;

    const queryBuilder = this.fileRepository
      .createQueryBuilder('file')
      .leftJoinAndSelect('file.user', 'user')
      .where('file.isDeleted = :isDeleted', { isDeleted: false });

    // Apply search
    if (search) {
      queryBuilder.andWhere(
        '(file.originalName ILIKE :search OR file.description ILIKE :search OR user.firstName ILIKE :search OR user.lastName ILIKE :search)',
        { search: `%${search}%` }
      );
    }

    // Apply filters
    if (filters.type) {
      queryBuilder.andWhere('file.type = :type', { type: filters.type });
    }

    if (filters.mimetype) {
      queryBuilder.andWhere('file.mimetype = :mimetype', { mimetype: filters.mimetype });
    }

    if (filters.isPublic !== undefined) {
      queryBuilder.andWhere('file.isPublic = :isPublic', { isPublic: filters.isPublic });
    }

    if (filters.userId) {
      queryBuilder.andWhere('file.userId = :userId', { userId: filters.userId });
    }

    // Apply sorting
    queryBuilder.orderBy(`file.${sortBy}`, sortOrder);

    // Apply pagination
    const offset = (page - 1) * limit;
    queryBuilder.skip(offset).take(limit);

    const [files, total] = await queryBuilder.getManyAndCount();

    return { files, total };
  }

  async updateFile(
    fileId: string,
    user: User,
    updates: {
      description?: string;
      isPublic?: boolean;
      metadata?: Record<string, any>;
    }
  ): Promise<File | null> {
    const file = await this.getFileById(fileId, user);
    
    if (!file) {
      return null;
    }

    // Update file properties
    if (updates.description !== undefined) {
      file.description = updates.description;
    }
    
    if (updates.isPublic !== undefined) {
      file.isPublic = updates.isPublic;
    }
    
    if (updates.metadata !== undefined) {
      file.metadata = { ...file.metadata, ...updates.metadata };
    }

    return this.fileRepository.save(file);
  }

  async deleteFile(fileId: string, user: User): Promise<boolean> {
    const file = await this.getFileById(fileId, user);
    
    if (!file) {
      return false;
    }

    // Soft delete
    file.isDeleted = true;
    file.deletedAt = new Date();
    await this.fileRepository.save(file);

    // Optionally delete from S3 (uncomment if needed)
    // await this.s3Service.deleteFile(file.key);

    return true;
  }

  async getFileDownloadUrl(fileId: string, user: User): Promise<string | null> {
    const file = await this.getFileById(fileId, user);
    
    if (!file) {
      return null;
    }

    return this.s3Service.getSignedUrl(file.key);
  }

  private validateFile(file: Express.Multer.File): void {
    // Check file size
    if (file.size > config.fileUpload.maxFileSize) {
      throw new Error(`File size exceeds maximum allowed size of ${config.fileUpload.maxFileSize} bytes`);
    }

    // Check file type
    if (!config.fileUpload.allowedTypes.includes(file.mimetype)) {
      throw new Error(`File type ${file.mimetype} is not allowed`);
    }

    // Additional security checks
    if (file.originalname.includes('..') || file.originalname.includes('/')) {
      throw new Error('Invalid filename');
    }
  }

  private determineFileType(mimetype: string): FileType {
    if (mimetype.startsWith('image/')) {
      return FileType.IMAGE;
    } else if (mimetype.startsWith('video/')) {
      return FileType.VIDEO;
    } else if (mimetype.startsWith('audio/')) {
      return FileType.AUDIO;
    } else if (
      mimetype.includes('pdf') ||
      mimetype.includes('document') ||
      mimetype.includes('text') ||
      mimetype.includes('spreadsheet') ||
      mimetype.includes('presentation')
    ) {
      return FileType.DOCUMENT;
    } else {
      return FileType.OTHER;
    }
  }

  async getFileStats(user?: User): Promise<{
    totalFiles: number;
    totalSize: number;
    filesByType: Record<FileType, number>;
  }> {
    const queryBuilder = this.fileRepository
      .createQueryBuilder('file')
      .where('file.isDeleted = :isDeleted', { isDeleted: false });

    if (user) {
      queryBuilder.andWhere('file.userId = :userId', { userId: user.id });
    }

    const files = await queryBuilder.getMany();

    const stats = {
      totalFiles: files.length,
      totalSize: files.reduce((sum, file) => sum + file.size, 0),
      filesByType: {
        [FileType.IMAGE]: 0,
        [FileType.DOCUMENT]: 0,
        [FileType.VIDEO]: 0,
        [FileType.AUDIO]: 0,
        [FileType.OTHER]: 0,
      },
    };

    files.forEach(file => {
      if (file.type in stats.filesByType) {
        stats.filesByType[file.type as keyof typeof stats.filesByType]++;
      }
    });

    return stats;
  }
}
