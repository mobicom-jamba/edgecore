import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from "typeorm";
import { IsNotEmpty, IsUrl, IsEnum, IsOptional } from "class-validator";
import { User } from "./User";
import { KnowledgeExtract } from "./KnowledgeExtract";
import { LearningSession } from "./LearningSession";
import { VideoStatus, VideoProcessingStage } from "../types";

@Entity("videos")
export class Video {
  @PrimaryGeneratedColumn("uuid")
  id!: string;

  @Column()
  @IsNotEmpty()
  userId!: string;

  @Column({ unique: true })
  @IsUrl()
  youtubeUrl!: string;

  @Column()
  @IsNotEmpty()
  youtubeVideoId!: string;

  @Column()
  @IsNotEmpty()
  title!: string;

  @Column({ type: "text", nullable: true })
  description!: string | null;

  @Column({ type: "int", nullable: true })
  duration!: number | null; // in seconds

  @Column({ type: "varchar", nullable: true })
  thumbnailUrl!: string | null;

  @Column({ type: "varchar", nullable: true })
  channelName!: string | null;

  @Column({
    type: "enum",
    enum: VideoStatus,
    default: VideoStatus.PENDING,
  })
  @IsEnum(VideoStatus)
  status!: VideoStatus;

  @Column({
    type: "enum",
    enum: VideoProcessingStage,
    default: VideoProcessingStage.EXTRACTING_TRANSCRIPT,
  })
  @IsEnum(VideoProcessingStage)
  processingStage!: VideoProcessingStage;

  @Column({ type: "text", nullable: true })
  transcript!: string | null;

  @Column({ type: "json", nullable: true })
  transcriptSegments!: Array<{
    start: number;
    end: number;
    text: string;
  }> | null;

  @Column({ type: "text", nullable: true })
  summary!: string | null;

  @Column({ type: "json", nullable: true })
  keyTopics!: string[] | null;

  @Column({ type: "json", nullable: true })
  learningObjectives!: string[] | null;

  @Column({ type: "json", nullable: true })
  metadata!: {
    viewCount?: number;
    likeCount?: number;
    publishedAt?: string;
    category?: string;
    tags?: string[];
  } | null;

  @Column({ type: "json", nullable: true })
  processingLog!: Array<{
    stage: VideoProcessingStage;
    status: "started" | "completed" | "failed";
    message?: string;
    timestamp: Date;
  }> | null;

  @Column({ type: "varchar", nullable: true })
  errorMessage!: string | null;

  @ManyToOne(() => User, { onDelete: "CASCADE" })
  @JoinColumn({ name: "userId" })
  user!: User;

  @OneToMany(() => KnowledgeExtract, (extract) => extract.video)
  knowledgeExtracts!: KnowledgeExtract[];

  @OneToMany(() => LearningSession, (session) => session.video)
  learningSessions!: LearningSession[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  get isProcessed(): boolean {
    return this.status === VideoStatus.COMPLETED;
  }

  get isProcessing(): boolean {
    return this.status === VideoStatus.PROCESSING;
  }

  get hasTranscript(): boolean {
    return !!this.transcript && this.transcript.length > 0;
  }

  get durationFormatted(): string {
    if (!this.duration) return "Unknown";
    const hours = Math.floor(this.duration / 3600);
    const minutes = Math.floor((this.duration % 3600) / 60);
    const seconds = this.duration % 60;

    if (hours > 0) {
      return `${hours}:${minutes.toString().padStart(2, "0")}:${seconds
        .toString()
        .padStart(2, "0")}`;
    }
    return `${minutes}:${seconds.toString().padStart(2, "0")}`;
  }

  toJSON(): Partial<Video> {
    return {
      id: this.id,
      userId: this.userId,
      youtubeUrl: this.youtubeUrl,
      youtubeVideoId: this.youtubeVideoId,
      title: this.title,
      description: this.description,
      duration: this.duration,
      durationFormatted: this.durationFormatted,
      thumbnailUrl: this.thumbnailUrl,
      channelName: this.channelName,
      status: this.status,
      processingStage: this.processingStage,
      summary: this.summary,
      keyTopics: this.keyTopics,
      learningObjectives: this.learningObjectives,
      metadata: this.metadata,
      isProcessed: this.isProcessed,
      isProcessing: this.isProcessing,
      hasTranscript: this.hasTranscript,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}
