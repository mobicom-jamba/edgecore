import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Video } from '../models/Video';
import { KnowledgeExtract } from '../models/KnowledgeExtract';
import { LearningCard } from '../models/LearningCard';
import { VideoStatus, VideoProcessingStage, ExtractType, DifficultyLevel, CardType, CardDifficulty } from '../types';
import { logError, logInfo, businessLogger } from '../utils/logger';

export interface YouTubeVideoData {
  id: string;
  title: string;
  description: string;
  duration: number;
  thumbnailUrl: string;
  channelName: string;
  viewCount: number;
  likeCount: number;
  publishedAt: string;
  category: string;
  tags: string[];
}

export interface TranscriptSegment {
  start: number;
  end: number;
  text: string;
}

export interface ProcessedContent {
  summary: string;
  keyTopics: string[];
  learningObjectives: string[];
  concepts: Array<{
    title: string;
    content: string;
    type: ExtractType;
    startTime: number;
    endTime: number;
    confidence: number;
    tags: string[];
  }>;
}

export class VideoProcessingService {
  private videoRepository: Repository<Video>;
  private knowledgeExtractRepository: Repository<KnowledgeExtract>;
  private learningCardRepository: Repository<LearningCard>;

  constructor() {
    this.videoRepository = AppDataSource.getRepository(Video);
    this.knowledgeExtractRepository = AppDataSource.getRepository(KnowledgeExtract);
    this.learningCardRepository = AppDataSource.getRepository(LearningCard);
  }

  async processVideo(videoId: string): Promise<void> {
    const video = await this.videoRepository.findOne({ where: { id: videoId } });
    if (!video) {
      throw new Error('Video not found');
    }

    try {
      // Update status to processing
      video.status = VideoStatus.PROCESSING;
      await this.videoRepository.save(video);

      // Step 1: Extract YouTube video metadata
      await this.updateProcessingStage(video, VideoProcessingStage.EXTRACTING_TRANSCRIPT, 'started');
      const videoData = await this.extractYouTubeMetadata(video.youtubeVideoId);
      
      // Update video with metadata
      video.title = videoData.title;
      video.description = videoData.description;
      video.duration = videoData.duration;
      video.thumbnailUrl = videoData.thumbnailUrl;
      video.channelName = videoData.channelName;
      video.metadata = {
        viewCount: videoData.viewCount,
        likeCount: videoData.likeCount,
        publishedAt: videoData.publishedAt,
        category: videoData.category,
        tags: videoData.tags,
      };
      await this.videoRepository.save(video);

      // Step 2: Extract transcript
      const transcript = await this.extractTranscript(video.youtubeVideoId);
      video.transcript = transcript.text;
      video.transcriptSegments = transcript.segments;
      await this.videoRepository.save(video);

      await this.updateProcessingStage(video, VideoProcessingStage.EXTRACTING_TRANSCRIPT, 'completed');

      // Step 3: Analyze content and extract knowledge
      await this.updateProcessingStage(video, VideoProcessingStage.ANALYZING_CONTENT, 'started');
      const processedContent = await this.analyzeContent(transcript.text, videoData);
      
      video.summary = processedContent.summary;
      video.keyTopics = processedContent.keyTopics;
      video.learningObjectives = processedContent.learningObjectives;
      await this.videoRepository.save(video);

      await this.updateProcessingStage(video, VideoProcessingStage.ANALYZING_CONTENT, 'completed');

      // Step 4: Create knowledge extracts
      await this.updateProcessingStage(video, VideoProcessingStage.EXTRACTING_KNOWLEDGE, 'started');
      await this.createKnowledgeExtracts(video, processedContent.concepts);
      await this.updateProcessingStage(video, VideoProcessingStage.EXTRACTING_KNOWLEDGE, 'completed');

      // Step 5: Generate learning cards
      await this.updateProcessingStage(video, VideoProcessingStage.STRUCTURING_CONTENT, 'started');
      await this.generateLearningCards(video);
      await this.updateProcessingStage(video, VideoProcessingStage.STRUCTURING_CONTENT, 'completed');

      // Mark as completed
      video.status = VideoStatus.COMPLETED;
      video.processingStage = VideoProcessingStage.COMPLETED;
      await this.videoRepository.save(video);

      businessLogger('video_processed', video.userId, { 
        videoId: video.id, 
        youtubeVideoId: video.youtubeVideoId,
        conceptsExtracted: processedContent.concepts.length 
      });

    } catch (error) {
      video.status = VideoStatus.FAILED;
      video.errorMessage = error instanceof Error ? error.message : 'Unknown error';
      await this.videoRepository.save(video);
      
      logError(error as Error, 'VideoProcessingService.processVideo');
      throw error;
    }
  }

  private async updateProcessingStage(video: Video, stage: VideoProcessingStage, status: 'started' | 'completed' | 'failed', message?: string): Promise<void> {
    if (!video.processingLog) {
      video.processingLog = [];
    }

    video.processingLog.push({
      stage,
      status,
      message,
      timestamp: new Date(),
    });

    video.processingStage = stage;
    await this.videoRepository.save(video);
  }

  private async extractYouTubeMetadata(videoId: string): Promise<YouTubeVideoData> {
    // In a real implementation, this would use the YouTube Data API
    // For now, we'll simulate the data extraction
    
    logInfo(`Extracting metadata for YouTube video: ${videoId}`);
    
    // Simulate API call delay
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    // Mock data - in real implementation, fetch from YouTube API
    return {
      id: videoId,
      title: `Sample Video Title for ${videoId}`,
      description: 'This is a sample video description that would be extracted from YouTube.',
      duration: 1800, // 30 minutes
      thumbnailUrl: `https://img.youtube.com/vi/${videoId}/maxresdefault.jpg`,
      channelName: 'Sample Channel',
      viewCount: 100000,
      likeCount: 5000,
      publishedAt: new Date().toISOString(),
      category: 'Education',
      tags: ['education', 'learning', 'tutorial'],
    };
  }

  private async extractTranscript(videoId: string): Promise<{ text: string; segments: TranscriptSegment[] }> {
    // In a real implementation, this would use YouTube's transcript API or speech-to-text
    logInfo(`Extracting transcript for YouTube video: ${videoId}`);
    
    // Simulate processing delay
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    // Mock transcript data
    const mockTranscript = `
      Welcome to this educational video. Today we'll be discussing important concepts in machine learning.
      
      First, let's understand what machine learning is. Machine learning is a subset of artificial intelligence that focuses on algorithms that can learn from data.
      
      There are three main types of machine learning: supervised learning, unsupervised learning, and reinforcement learning.
      
      Supervised learning uses labeled data to train models. Examples include classification and regression tasks.
      
      Unsupervised learning finds patterns in data without labels. Clustering and dimensionality reduction are common examples.
      
      Reinforcement learning involves training agents to make decisions through trial and error in an environment.
      
      Each type has its own applications and use cases. Understanding these fundamentals is crucial for anyone entering the field of AI.
    `;

    const segments: TranscriptSegment[] = [
      { start: 0, end: 5, text: 'Welcome to this educational video. Today we\'ll be discussing important concepts in machine learning.' },
      { start: 5, end: 15, text: 'First, let\'s understand what machine learning is. Machine learning is a subset of artificial intelligence that focuses on algorithms that can learn from data.' },
      { start: 15, end: 25, text: 'There are three main types of machine learning: supervised learning, unsupervised learning, and reinforcement learning.' },
      { start: 25, end: 35, text: 'Supervised learning uses labeled data to train models. Examples include classification and regression tasks.' },
      { start: 35, end: 45, text: 'Unsupervised learning finds patterns in data without labels. Clustering and dimensionality reduction are common examples.' },
      { start: 45, end: 55, text: 'Reinforcement learning involves training agents to make decisions through trial and error in an environment.' },
      { start: 55, end: 65, text: 'Each type has its own applications and use cases. Understanding these fundamentals is crucial for anyone entering the field of AI.' },
    ];

    return {
      text: mockTranscript.trim(),
      segments,
    };
  }

  private async analyzeContent(transcript: string, videoData: YouTubeVideoData): Promise<ProcessedContent> {
    // In a real implementation, this would use AI/NLP services like OpenAI, Claude, or local models
    logInfo('Analyzing content and extracting knowledge');
    
    // Simulate AI processing delay
    await new Promise(resolve => setTimeout(resolve, 3000));
    
    // Mock AI analysis results
    return {
      summary: 'This video provides a comprehensive introduction to machine learning, covering the three main types: supervised, unsupervised, and reinforcement learning. It explains key concepts and applications for each type, making it suitable for beginners in AI and machine learning.',
      keyTopics: [
        'Machine Learning Fundamentals',
        'Supervised Learning',
        'Unsupervised Learning',
        'Reinforcement Learning',
        'AI Applications',
        'Data Science'
      ],
      learningObjectives: [
        'Understand the definition of machine learning',
        'Identify the three main types of machine learning',
        'Explain the differences between supervised and unsupervised learning',
        'Describe reinforcement learning concepts',
        'Recognize real-world applications of each ML type'
      ],
      concepts: [
        {
          title: 'Machine Learning Definition',
          content: 'Machine learning is a subset of artificial intelligence that focuses on algorithms that can learn from data.',
          type: ExtractType.DEFINITION,
          startTime: 5,
          endTime: 15,
          confidence: 0.95,
          tags: ['definition', 'fundamentals', 'AI']
        },
        {
          title: 'Supervised Learning',
          content: 'Supervised learning uses labeled data to train models. Examples include classification and regression tasks.',
          type: ExtractType.CONCEPT,
          startTime: 25,
          endTime: 35,
          confidence: 0.90,
          tags: ['supervised', 'classification', 'regression']
        },
        {
          title: 'Unsupervised Learning',
          content: 'Unsupervised learning finds patterns in data without labels. Clustering and dimensionality reduction are common examples.',
          type: ExtractType.CONCEPT,
          startTime: 35,
          endTime: 45,
          confidence: 0.90,
          tags: ['unsupervised', 'clustering', 'patterns']
        },
        {
          title: 'Reinforcement Learning',
          content: 'Reinforcement learning involves training agents to make decisions through trial and error in an environment.',
          type: ExtractType.CONCEPT,
          startTime: 45,
          endTime: 55,
          confidence: 0.88,
          tags: ['reinforcement', 'agents', 'decision-making']
        }
      ]
    };
  }

  private async createKnowledgeExtracts(video: Video, concepts: ProcessedContent['concepts']): Promise<void> {
    logInfo(`Creating ${concepts.length} knowledge extracts for video ${video.id}`);
    
    for (const concept of concepts) {
      const extract = this.knowledgeExtractRepository.create({
        userId: video.userId,
        videoId: video.id,
        title: concept.title,
        content: concept.content,
        type: concept.type,
        difficultyLevel: DifficultyLevel.INTERMEDIATE,
        tags: concept.tags,
        startTime: concept.startTime,
        endTime: concept.endTime,
        confidenceScore: concept.confidence,
        sourceContext: {
          segmentText: concept.content,
          surroundingContext: `From video: ${video.title}`,
        },
        metadata: {
          importance: Math.round(concept.confidence * 10),
          complexity: 5,
          prerequisites: [],
          applications: [],
        },
      });

      await this.knowledgeExtractRepository.save(extract);
    }
  }

  private async generateLearningCards(video: Video): Promise<void> {
    const extracts = await this.knowledgeExtractRepository.find({
      where: { videoId: video.id },
    });

    logInfo(`Generating learning cards for ${extracts.length} knowledge extracts`);

    for (const extract of extracts) {
      // Generate different types of cards based on the extract type
      const cards = await this.createCardsForExtract(extract);
      
      for (const cardData of cards) {
        const card = this.learningCardRepository.create({
          userId: extract.userId,
          knowledgeExtractId: extract.id,
          question: cardData.question,
          answer: cardData.answer,
          type: cardData.type,
          difficulty: cardData.difficulty,
          options: cardData.options,
          hints: cardData.hints,
          explanation: cardData.explanation,
          tags: extract.tags,
        });

        await this.learningCardRepository.save(card);
      }
    }
  }

  private async createCardsForExtract(extract: KnowledgeExtract): Promise<Array<{
    question: string;
    answer: string;
    type: CardType;
    difficulty: CardDifficulty;
    options?: string[];
    hints?: string[];
    explanation?: string;
  }>> {
    const cards = [];

    // Create a basic flashcard
    cards.push({
      question: `What is ${extract.title}?`,
      answer: extract.content,
      type: CardType.FLASHCARD,
      difficulty: CardDifficulty.MEDIUM,
      hints: [`This concept is related to: ${extract.tags?.join(', ')}`],
      explanation: `This is a fundamental concept in the field. ${extract.content}`,
    });

    // Create a multiple choice question if it's a definition
    if (extract.type === ExtractType.DEFINITION) {
      cards.push({
        question: `Which of the following best describes ${extract.title}?`,
        answer: extract.content,
        type: CardType.MULTIPLE_CHOICE,
        difficulty: CardDifficulty.EASY,
        options: [
          extract.content,
          'A type of computer programming',
          'A database management system',
          'A web development framework',
        ],
        explanation: `The correct answer is the definition provided in the video.`,
      });
    }

    return cards;
  }

  async getVideoProcessingStatus(videoId: string): Promise<{
    status: VideoStatus;
    stage: VideoProcessingStage;
    progress: number;
    log: any[];
  }> {
    const video = await this.videoRepository.findOne({ where: { id: videoId } });
    if (!video) {
      throw new Error('Video not found');
    }

    const stages = Object.values(VideoProcessingStage);
    const currentStageIndex = stages.indexOf(video.processingStage);
    const progress = ((currentStageIndex + 1) / stages.length) * 100;

    return {
      status: video.status,
      stage: video.processingStage,
      progress: Math.round(progress),
      log: video.processingLog || [],
    };
  }
}
