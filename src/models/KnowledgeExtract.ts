import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import { IsNotEmpty, IsEnum } from 'class-validator';
import { User } from './User';
import { Video } from './Video';
import { LearningCard } from './LearningCard';
import { ExtractType, DifficultyLevel, ExtractStatus } from '../types';

@Entity('knowledge_extracts')
export class KnowledgeExtract {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  @IsNotEmpty()
  userId!: string;

  @Column()
  @IsNotEmpty()
  videoId!: string;

  @Column()
  @IsNotEmpty()
  title!: string;

  @Column({ type: 'text' })
  @IsNotEmpty()
  content!: string;

  @Column({
    type: 'enum',
    enum: ExtractType,
  })
  @IsEnum(ExtractType)
  type!: ExtractType;

  @Column({
    type: 'enum',
    enum: DifficultyLevel,
    default: DifficultyLevel.INTERMEDIATE,
  })
  @IsEnum(DifficultyLevel)
  difficultyLevel!: DifficultyLevel;

  @Column({
    type: 'enum',
    enum: ExtractStatus,
    default: ExtractStatus.ACTIVE,
  })
  @IsEnum(ExtractStatus)
  status!: ExtractStatus;

  @Column({ type: 'json', nullable: true })
  tags!: string[] | null;

  @Column({ type: 'json', nullable: true })
  relatedConcepts!: string[] | null;

  @Column({ type: 'int', default: 0 })
  startTime!: number;

  @Column({ type: 'int', default: 0 })
  endTime!: number;

  @Column({ type: 'decimal', precision: 3, scale: 2, default: 0 })
  confidenceScore!: number;

  @Column({ type: 'json', nullable: true })
  sourceContext!: {
    segmentText?: string;
    surroundingContext?: string;
    speaker?: string;
  } | null;

  @Column({ type: 'json', nullable: true })
  metadata!: {
    importance?: number;
    complexity?: number;
    prerequisites?: string[];
    applications?: string[];
  } | null;

  @Column({ type: 'int', default: 0 })
  reviewCount!: number;

  @Column({ type: 'timestamp', nullable: true })
  lastReviewedAt!: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  nextReviewAt!: Date | null;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user!: User;

  @ManyToOne(() => Video, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'videoId' })
  video!: Video;

  @OneToMany(() => LearningCard, (card) => card.knowledgeExtract)
  learningCards!: LearningCard[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  get isDueForReview(): boolean {
    if (!this.nextReviewAt) return false;
    return new Date() >= this.nextReviewAt;
  }

  get timeRange(): string {
    const startMin = Math.floor(this.startTime / 60);
    const startSec = this.startTime % 60;
    const endMin = Math.floor(this.endTime / 60);
    const endSec = this.endTime % 60;
    
    return `${startMin}:${startSec.toString().padStart(2, '0')} - ${endMin}:${endSec.toString().padStart(2, '0')}`;
  }

  get confidencePercentage(): number {
    return Math.round(this.confidenceScore * 100);
  }
}