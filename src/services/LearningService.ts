import { Repository, Between, In } from 'typeorm';
import { AppDataSource } from '../config/database';
import { User } from '../models/User';
import { Video } from '../models/Video';
import { KnowledgeExtract } from '../models/KnowledgeExtract';
import { LearningCard } from '../models/LearningCard';
import { LearningSession } from '../models/LearningSession';
import { ExtractStatus, CardType, CardDifficulty, SessionType, SessionStatus, ReviewQuality } from '../types';
import { logError, logInfo, businessLogger } from '../utils/logger';

export interface LearningStats {
  totalVideos: number;
  totalExtracts: number;
  totalCards: number;
  cardsReviewed: number;
  cardsMastered: number;
  averageAccuracy: number;
  studyStreak: number;
  timeSpent: number;
  progressBySubject: Record<string, number>;
}

export interface ReviewSession {
  cards: Array<{
    id: string;
    question: string;
    answer: string;
    type: CardType;
    difficulty: CardDifficulty;
    hints?: string[];
    explanation?: string;
    lastReviewed?: Date;
    reviewCount: number;
    successRate: number;
  }>;
  sessionId: string;
  totalCards: number;
}

export interface SpacedRepetitionAlgorithm {
  calculateNextReview(
    currentInterval: number,
    easeFactor: number,
    quality: ReviewQuality
  ): { interval: number; easeFactor: number };
}

export class LearningService implements SpacedRepetitionAlgorithm {
  private userRepository: Repository<User>;
  private videoRepository: Repository<Video>;
  private knowledgeExtractRepository: Repository<KnowledgeExtract>;
  private learningCardRepository: Repository<LearningCard>;
  private learningSessionRepository: Repository<LearningSession>;

  constructor() {
    this.userRepository = AppDataSource.getRepository(User);
    this.videoRepository = AppDataSource.getRepository(Video);
    this.knowledgeExtractRepository = AppDataSource.getRepository(KnowledgeExtract);
    this.learningCardRepository = AppDataSource.getRepository(LearningCard);
    this.learningSessionRepository = AppDataSource.getRepository(LearningSession);
  }

  async getLearningStats(userId: string): Promise<LearningStats> {
    const [
      totalVideos,
      totalExtracts,
      totalCards,
      cardsReviewed,
      cardsMastered,
      sessions
    ] = await Promise.all([
      this.videoRepository.count({ where: { userId } }),
      this.knowledgeExtractRepository.count({ where: { userId } }),
      this.learningCardRepository.count({ where: { userId, isActive: true } }),
      this.learningCardRepository.count({ where: { userId, reviewCount: 1 } }),
      this.learningCardRepository.count({ where: { userId, successRate: 90 } }),
      this.learningSessionRepository.find({
        where: { userId, status: SessionStatus.COMPLETED },
        select: ['duration', 'accuracy'],
      }),
    ]);

    const averageAccuracy = sessions.length > 0 
      ? sessions.reduce((sum, session) => sum + session.accuracy, 0) / sessions.length 
      : 0;

    const timeSpent = sessions.reduce((sum, session) => sum + session.duration, 0);

    // Calculate study streak (consecutive days with learning sessions)
    const studyStreak = await this.calculateStudyStreak(userId);

    // Get progress by subject (based on tags)
    const progressBySubject = await this.getProgressBySubject(userId);

    return {
      totalVideos,
      totalExtracts,
      totalCards,
      cardsReviewed,
      cardsMastered,
      averageAccuracy: Math.round(averageAccuracy),
      studyStreak,
      timeSpent,
      progressBySubject,
    };
  }

  async getCardsForReview(userId: string, limit: number = 20): Promise<ReviewSession> {
    // Get cards that are due for review
    const dueCards = await this.learningCardRepository
      .createQueryBuilder('card')
      .leftJoinAndSelect('card.knowledgeExtract', 'extract')
      .where('card.userId = :userId', { userId })
      .andWhere('card.isActive = true')
      .andWhere('(card.nextReviewAt IS NULL OR card.nextReviewAt <= :now)', { now: new Date() })
      .orderBy('card.nextReviewAt', 'ASC')
      .addOrderBy('card.reviewCount', 'ASC')
      .limit(limit)
      .getMany();

    // If no cards are due, get new cards
    if (dueCards.length === 0) {
      const newCards = await this.learningCardRepository
        .createQueryBuilder('card')
        .leftJoinAndSelect('card.knowledgeExtract', 'extract')
        .where('card.userId = :userId', { userId })
        .andWhere('card.isActive = true')
        .andWhere('card.reviewCount = 0')
        .orderBy('card.createdAt', 'ASC')
        .limit(limit)
        .getMany();

      dueCards.push(...newCards);
    }

    // Create a new learning session
    const session = this.learningSessionRepository.create({
      userId,
      type: SessionType.CARD_REVIEW,
      status: SessionStatus.ACTIVE,
      startedAt: new Date(),
    });

    const savedSession = await this.learningSessionRepository.save(session);

    const cards = dueCards.map(card => ({
      id: card.id,
      question: card.question,
      answer: card.answer,
      type: card.type,
      difficulty: card.difficulty,
      hints: card.hints || undefined,
      explanation: card.explanation || undefined,
      lastReviewed: card.lastReviewedAt || undefined,
      reviewCount: card.reviewCount,
      successRate: card.successRate,
    }));

    return {
      cards,
      sessionId: savedSession.id,
      totalCards: cards.length,
    };
  }

  async submitCardReview(
    sessionId: string,
    cardId: string,
    quality: ReviewQuality,
    responseTime: number
  ): Promise<void> {
    const session = await this.learningSessionRepository.findOne({
      where: { id: sessionId },
    });

    const card = await this.learningCardRepository.findOne({
      where: { id: cardId },
    });

    if (!session || !card) {
      throw new Error('Session or card not found');
    }

    // Update card statistics
    card.reviewCount += 1;
    card.lastReviewedAt = new Date();

    const isCorrect = quality === ReviewQuality.GOOD || quality === ReviewQuality.EASY;
    if (isCorrect) {
      card.correctCount += 1;
    } else {
      card.incorrectCount += 1;
    }

    card.successRate = (card.correctCount / card.reviewCount) * 100;

    // Calculate next review using spaced repetition
    const { interval, easeFactor } = this.calculateNextReview(
      card.currentInterval,
      card.easeFactor,
      quality
    );

    card.currentInterval = interval;
    card.easeFactor = easeFactor;
    card.nextReviewAt = new Date(Date.now() + interval * 24 * 60 * 60 * 1000);

    await this.learningCardRepository.save(card);

    // Update session
    if (!session.reviewResults) {
      session.reviewResults = [];
    }

    session.reviewResults.push({
      cardId,
      quality,
      responseTime,
      timestamp: new Date(),
    });

    session.cardsReviewed += 1;
    if (isCorrect) {
      session.correctAnswers += 1;
    } else {
      session.incorrectAnswers += 1;
    }

    session.accuracy = (session.correctAnswers / session.cardsReviewed) * 100;

    await this.learningSessionRepository.save(session);

    businessLogger('card_reviewed', session.userId, {
      sessionId,
      cardId,
      quality,
      responseTime,
      isCorrect,
    });
  }

  async completeReviewSession(sessionId: string): Promise<void> {
    const session = await this.learningSessionRepository.findOne({
      where: { id: sessionId },
    });

    if (!session) {
      throw new Error('Session not found');
    }

    session.status = SessionStatus.COMPLETED;
    session.completedAt = new Date();
    session.duration = Math.floor(
      (session.completedAt.getTime() - session.startedAt!.getTime()) / 1000
    );

    // Calculate analytics
    if (session.reviewResults && session.reviewResults.length > 0) {
      const averageResponseTime = session.reviewResults.reduce(
        (sum, result) => sum + result.responseTime,
        0
      ) / session.reviewResults.length;

      session.analytics = {
        averageResponseTime: Math.round(averageResponseTime),
        difficultyDistribution: {},
        conceptMastery: {},
        learningVelocity: session.cardsReviewed / (session.duration / 60), // cards per minute
      };
    }

    await this.learningSessionRepository.save(session);

    businessLogger('review_session_completed', session.userId, {
      sessionId,
      cardsReviewed: session.cardsReviewed,
      accuracy: session.accuracy,
      duration: session.duration,
    });
  }

  calculateNextReview(
    currentInterval: number,
    easeFactor: number,
    quality: ReviewQuality
  ): { interval: number; easeFactor: number } {
    // SM-2 Algorithm implementation
    let newInterval: number;
    let newEaseFactor = easeFactor;

    // Convert quality to numeric value for calculations
    const qualityValue = this.getQualityValue(quality);

    if (qualityValue < 2) {
      // Again or Hard - reset interval
      newInterval = 1;
    } else {
      if (currentInterval === 0) {
        newInterval = 1;
      } else if (currentInterval === 1) {
        newInterval = 6;
      } else {
        newInterval = Math.round(currentInterval * newEaseFactor);
      }
    }

    // Update ease factor
    newEaseFactor = newEaseFactor + (0.1 - (5 - qualityValue) * (0.08 + (5 - qualityValue) * 0.02));
    
    // Ensure ease factor doesn't go below 1.3
    if (newEaseFactor < 1.3) {
      newEaseFactor = 1.3;
    }

    return {
      interval: newInterval,
      easeFactor: Math.round(newEaseFactor * 100) / 100,
    };
  }

  private getQualityValue(quality: ReviewQuality): number {
    switch (quality) {
      case ReviewQuality.AGAIN: return 0;
      case ReviewQuality.HARD: return 1;
      case ReviewQuality.GOOD: return 2;
      case ReviewQuality.EASY: return 3;
      default: return 2;
    }
  }

  async getLearningPath(userId: string, subject?: string): Promise<{
    videos: Array<{
      id: string;
      title: string;
      thumbnailUrl: string;
      duration: number;
      progress: number;
      conceptsLearned: number;
      totalConcepts: number;
    }>;
    recommendations: Array<{
      id: string;
      title: string;
      reason: string;
      difficulty: string;
    }>;
  }> {
    // Get user's videos with progress
    const videos = await this.videoRepository.find({
      where: { userId },
      relations: ['knowledgeExtracts'],
      order: { createdAt: 'DESC' },
    });

    const videoProgress = videos.map(video => {
      const totalConcepts = video.knowledgeExtracts?.length || 0;
      const learnedConcepts = video.knowledgeExtracts?.filter(
        extract => extract.status === ExtractStatus.REVIEWED
      ).length || 0;

      return {
        id: video.id,
        title: video.title,
        thumbnailUrl: video.thumbnailUrl || '',
        duration: video.duration || 0,
        progress: totalConcepts > 0 ? (learnedConcepts / totalConcepts) * 100 : 0,
        conceptsLearned: learnedConcepts,
        totalConcepts,
      };
    });

    // Get recommendations based on learning patterns
    const recommendations = await this.getRecommendations(userId, subject);

    return {
      videos: videoProgress,
      recommendations,
    };
  }

  private async calculateStudyStreak(userId: string): Promise<number> {
    // Get all completed sessions in the last 30 days
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    
    const sessions = await this.learningSessionRepository
      .createQueryBuilder('session')
      .where('session.userId = :userId', { userId })
      .andWhere('session.status = :status', { status: SessionStatus.COMPLETED })
      .andWhere('session.completedAt >= :date', { date: thirtyDaysAgo })
      .orderBy('session.completedAt', 'DESC')
      .getMany();

    if (sessions.length === 0) return 0;

    // Calculate consecutive days
    let streak = 0;
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    for (let i = 0; i < 30; i++) {
      const checkDate = new Date(today);
      checkDate.setDate(today.getDate() - i);
      checkDate.setHours(23, 59, 59, 999);

      const hasSessionOnDate = sessions.some(session => {
        const sessionDate = new Date(session.completedAt!);
        sessionDate.setHours(0, 0, 0, 0);
        return sessionDate.getTime() === checkDate.getTime();
      });

      if (hasSessionOnDate) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  private async getProgressBySubject(userId: string): Promise<Record<string, number>> {
    const extracts = await this.knowledgeExtractRepository
      .createQueryBuilder('extract')
      .where('extract.userId = :userId', { userId })
      .getMany();

    const subjectProgress: Record<string, { total: number; reviewed: number }> = {};

    extracts.forEach(extract => {
      const subjects = extract.tags || ['General'];
      subjects.forEach(subject => {
        if (!subjectProgress[subject]) {
          subjectProgress[subject] = { total: 0, reviewed: 0 };
        }
        subjectProgress[subject].total++;
        if (extract.status === ExtractStatus.REVIEWED) {
          subjectProgress[subject].reviewed++;
        }
      });
    });

    const progress: Record<string, number> = {};
    Object.keys(subjectProgress).forEach(subject => {
      const { total, reviewed } = subjectProgress[subject];
      progress[subject] = total > 0 ? Math.round((reviewed / total) * 100) : 0;
    });

    return progress;
  }

  private async getRecommendations(userId: string, subject?: string): Promise<Array<{
    id: string;
    title: string;
    reason: string;
    difficulty: string;
  }>> {
    // In a real implementation, this would use ML algorithms to recommend content
    // For now, return mock recommendations
    return [
      {
        id: 'rec-1',
        title: 'Advanced Machine Learning Concepts',
        reason: 'Based on your progress in machine learning fundamentals',
        difficulty: 'Intermediate',
      },
      {
        id: 'rec-2',
        title: 'Deep Learning Basics',
        reason: 'Recommended after completing supervised learning',
        difficulty: 'Advanced',
      },
    ];
  }
}
