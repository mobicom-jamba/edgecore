import { Request, Response } from 'express';
import { VideoProcessingService } from '../services/VideoProcessingService';
import { LearningService } from '../services/LearningService';
import { AuthenticatedRequest, ApiResponse, SearchQuery } from '../types';
import { logError, logInfo, businessLogger } from '../utils/logger';

export class VideoController {
  private videoProcessingService: VideoProcessingService;
  private learningService: LearningService;

  constructor() {
    this.videoProcessingService = new VideoProcessingService();
    this.learningService = new LearningService();
  }

  // Submit a YouTube video for processing
  submitVideo = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { youtubeUrl, learningObjectives } = req.body;

      // Extract YouTube video ID from URL
      const videoId = this.extractYouTubeVideoId(youtubeUrl);
      if (!videoId) {
        const response: ApiResponse = {
          success: false,
          message: 'Invalid YouTube URL',
        };
        res.status(400).json(response);
        return;
      }

      // Check if video already exists for this user
      const existingVideo = await this.videoProcessingService['videoRepository'].findOne({
        where: { userId: user.id, youtubeVideoId: videoId },
      });

      if (existingVideo) {
        const response: ApiResponse = {
          success: false,
          message: 'Video already exists in your library',
          data: { video: existingVideo.toJSON() },
        };
        res.status(409).json(response);
        return;
      }

      // Create new video record
      const video = this.videoProcessingService['videoRepository'].create({
        userId: user.id,
        youtubeUrl,
        youtubeVideoId: videoId,
        title: 'Processing...', // Will be updated during processing
        learningObjectives: learningObjectives || [],
      });

      const savedVideo = await this.videoProcessingService['videoRepository'].save(video);

      // Start processing in background
      this.videoProcessingService.processVideo(savedVideo.id).catch(error => {
        logError(error as Error, 'VideoController.submitVideo - Background processing');
      });

      businessLogger('video_submitted', user.id, { 
        videoId: savedVideo.id, 
        youtubeVideoId: videoId,
        youtubeUrl 
      });

      const response: ApiResponse = {
        success: true,
        message: 'Video submitted for processing',
        data: { video: savedVideo.toJSON() },
      };

      res.status(201).json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.submitVideo');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to submit video',
      };

      res.status(500).json(response);
    }
  };

  // Get user's videos
  getVideos = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const query: SearchQuery = {
        page: parseInt(req.query.page as string) || 1,
        limit: parseInt(req.query.limit as string) || 10,
        search: req.query.search as string,
        sortBy: req.query.sortBy as string || 'createdAt',
        sortOrder: (req.query.sortOrder as 'ASC' | 'DESC') || 'DESC',
        filters: {
          status: req.query.status as string,
        },
      };

      const result = await this.getUserVideos(user.id, query);

      const response: ApiResponse = {
        success: true,
        message: 'Videos retrieved successfully',
        data: result.videos,
        pagination: result.pagination,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.getVideos');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve videos',
      };

      res.status(500).json(response);
    }
  };

  // Get specific video details
  getVideo = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { id } = req.params;

      const video = await this.videoProcessingService['videoRepository'].findOne({
        where: { id, userId: user.id },
        relations: ['knowledgeExtracts', 'learningSessions'],
      });

      if (!video) {
        const response: ApiResponse = {
          success: false,
          message: 'Video not found',
        };
        res.status(404).json(response);
        return;
      }

      const response: ApiResponse = {
        success: true,
        message: 'Video retrieved successfully',
        data: { video: video.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.getVideo');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve video',
      };

      res.status(500).json(response);
    }
  };

  // Get video processing status
  getVideoStatus = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { id } = req.params;

      const video = await this.videoProcessingService['videoRepository'].findOne({
        where: { id, userId: user.id },
      });

      if (!video) {
        const response: ApiResponse = {
          success: false,
          message: 'Video not found',
        };
        res.status(404).json(response);
        return;
      }

      const status = await this.videoProcessingService.getVideoProcessingStatus(id);

      const response: ApiResponse = {
        success: true,
        message: 'Video status retrieved successfully',
        data: status,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.getVideoStatus');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve video status',
      };

      res.status(500).json(response);
    }
  };

  // Get learning dashboard data
  getLearningDashboard = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;

      const [stats, learningPath] = await Promise.all([
        this.learningService.getLearningStats(user.id),
        this.learningService.getLearningPath(user.id),
      ]);

      const response: ApiResponse = {
        success: true,
        message: 'Learning dashboard retrieved successfully',
        data: {
          stats,
          learningPath,
        },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.getLearningDashboard');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve learning dashboard',
      };

      res.status(500).json(response);
    }
  };

  // Get cards for review session
  getReviewSession = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const limit = parseInt(req.query.limit as string) || 20;

      const reviewSession = await this.learningService.getCardsForReview(user.id, limit);

      const response: ApiResponse = {
        success: true,
        message: 'Review session created successfully',
        data: reviewSession,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.getReviewSession');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to create review session',
      };

      res.status(500).json(response);
    }
  };

  // Submit card review
  submitCardReview = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { sessionId, cardId, quality, responseTime } = req.body;

      await this.learningService.submitCardReview(sessionId, cardId, quality, responseTime);

      const response: ApiResponse = {
        success: true,
        message: 'Card review submitted successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.submitCardReview');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to submit card review',
      };

      res.status(400).json(response);
    }
  };

  // Complete review session
  completeReviewSession = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { sessionId } = req.body;

      await this.learningService.completeReviewSession(sessionId);

      const response: ApiResponse = {
        success: true,
        message: 'Review session completed successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.completeReviewSession');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to complete review session',
      };

      res.status(400).json(response);
    }
  };

  // Delete video
  deleteVideo = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { id } = req.params;

      const video = await this.videoProcessingService['videoRepository'].findOne({
        where: { id, userId: user.id },
      });

      if (!video) {
        const response: ApiResponse = {
          success: false,
          message: 'Video not found',
        };
        res.status(404).json(response);
        return;
      }

      await this.videoProcessingService['videoRepository'].remove(video);

      businessLogger('video_deleted', user.id, { videoId: id });

      const response: ApiResponse = {
        success: true,
        message: 'Video deleted successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'VideoController.deleteVideo');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to delete video',
      };

      res.status(500).json(response);
    }
  };

  private extractYouTubeVideoId(url: string): string | null {
    const patterns = [
      /(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([^&\n?#]+)/,
      /youtube\.com\/v\/([^&\n?#]+)/,
    ];

    for (const pattern of patterns) {
      const match = url.match(pattern);
      if (match) {
        return match[1];
      }
    }

    return null;
  }

  private async getUserVideos(userId: string, query: SearchQuery): Promise<{
    videos: any[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  }> {
    const { page = 1, limit = 10, search, sortBy = 'createdAt', sortOrder = 'DESC', filters = {} } = query;
    
    const queryBuilder = this.videoProcessingService['videoRepository'].createQueryBuilder('video');

    queryBuilder.where('video.userId = :userId', { userId });

    // Apply search
    if (search) {
      queryBuilder.andWhere(
        '(video.title ILIKE :search OR video.description ILIKE :search OR video.channelName ILIKE :search)',
        { search: `%${search}%` }
      );
    }

    // Apply filters
    if (filters.status) {
      queryBuilder.andWhere('video.status = :status', { status: filters.status });
    }

    // Apply sorting
    queryBuilder.orderBy(`video.${sortBy}`, sortOrder);

    // Apply pagination
    const skip = (page - 1) * limit;
    queryBuilder.skip(skip).take(limit);

    const [videos, total] = await queryBuilder.getManyAndCount();

    return {
      videos: videos.map(video => video.toJSON()),
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}
