import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { IsNotEmpty, IsEnum } from 'class-validator';
import { User } from './User';
import { Video } from './Video';
import { KnowledgeExtract } from './KnowledgeExtract';
// import { LearningCard } from './LearningCard'; // Removed to avoid circular dependency
import { SessionType, SessionStatus, ReviewQuality } from '../types';

@Entity('learning_sessions')
export class LearningSession {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  @IsNotEmpty()
  userId!: string;

  @Column({ nullable: true })
  videoId!: string | null;

  @Column({ nullable: true })
  knowledgeExtractId!: string | null;

  @Column({ nullable: true })
  learningCardId!: string | null;

  @Column({
    type: 'enum',
    enum: SessionType,
  })
  @IsEnum(SessionType)
  type!: SessionType;

  @Column({
    type: 'enum',
    enum: SessionStatus,
    default: SessionStatus.ACTIVE,
  })
  @IsEnum(SessionStatus)
  status!: SessionStatus;

  @Column({ type: 'timestamp', nullable: true })
  startedAt!: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  completedAt!: Date | null;

  @Column({ type: 'int', default: 0 })
  duration!: number;

  @Column({ type: 'int', default: 0 })
  cardsReviewed!: number;

  @Column({ type: 'int', default: 0 })
  correctAnswers!: number;

  @Column({ type: 'int', default: 0 })
  incorrectAnswers!: number;

  @Column({ type: 'decimal', precision: 5, scale: 2, default: 0 })
  accuracy!: number;

  @Column({ type: 'json', nullable: true })
  reviewResults!: Array<{
    cardId: string;
    quality: ReviewQuality;
    responseTime: number;
    timestamp: Date;
  }> | null;

  @Column({ type: 'json', nullable: true })
  sessionData!: {
    videoProgress?: number;
    notes?: string;
    bookmarks?: Array<{
      timestamp: number;
      note: string;
    }>;
    focusAreas?: string[];
  } | null;

  @Column({ type: 'json', nullable: true })
  analytics!: {
    averageResponseTime?: number;
    difficultyDistribution?: Record<string, number>;
    conceptMastery?: Record<string, number>;
    learningVelocity?: number;
  } | null;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user!: User;

  @ManyToOne(() => Video, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'videoId' })
  video!: Video | null;

  @ManyToOne(() => KnowledgeExtract, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'knowledgeExtractId' })
  knowledgeExtract!: KnowledgeExtract | null;

  @ManyToOne('LearningCard', { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'learningCardId' })
  learningCard!: any;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  get isActive(): boolean {
    return this.status === SessionStatus.ACTIVE;
  }

  get isCompleted(): boolean {
    return this.status === SessionStatus.COMPLETED;
  }

  get durationFormatted(): string {
    const hours = Math.floor(this.duration / 3600);
    const minutes = Math.floor((this.duration % 3600) / 60);
    const seconds = this.duration % 60;
    
    if (hours > 0) {
      return `${hours}h ${minutes}m ${seconds}s`;
    } else if (minutes > 0) {
      return `${minutes}m ${seconds}s`;
    }
    return `${seconds}s`;
  }

  get successRate(): number {
    if (this.cardsReviewed === 0) return 0;
    return Math.round((this.correctAnswers / this.cardsReviewed) * 100);
  }
}