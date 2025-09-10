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
import { IsNotEmpty, IsEnum } from "class-validator";
import { User } from "./User";
import { KnowledgeExtract } from "./KnowledgeExtract";
import { LearningSession } from "./LearningSession";
import { CardType, CardDifficulty } from "../types";

@Entity("learning_cards")
export class LearningCard {
  @PrimaryGeneratedColumn("uuid")
  id!: string;

  @Column()
  @IsNotEmpty()
  userId!: string;

  @Column()
  @IsNotEmpty()
  knowledgeExtractId!: string;

  @Column()
  @IsNotEmpty()
  question!: string;

  @Column({ type: "text" })
  @IsNotEmpty()
  answer!: string;

  @Column({
    type: "enum",
    enum: CardType,
    default: CardType.FLASHCARD,
  })
  @IsEnum(CardType)
  type!: CardType;

  @Column({
    type: "enum",
    enum: CardDifficulty,
    default: CardDifficulty.MEDIUM,
  })
  @IsEnum(CardDifficulty)
  difficulty!: CardDifficulty;

  @Column({ type: "json", nullable: true })
  options!: string[] | null;

  @Column({ type: "json", nullable: true })
  hints!: string[] | null;

  @Column({ type: "text", nullable: true })
  explanation!: string | null;

  @Column({ type: "json", nullable: true })
  tags!: string[] | null;

  @Column({ type: "int", default: 0 })
  reviewCount!: number;

  @Column({ type: "int", default: 0 })
  correctCount!: number;

  @Column({ type: "int", default: 0 })
  incorrectCount!: number;

  @Column({ type: "decimal", precision: 5, scale: 2, default: 0 })
  successRate!: number;

  @Column({ type: "int", default: 0 })
  currentInterval!: number;

  @Column({ type: "int", default: 0 })
  easeFactor!: number;

  @Column({ type: "timestamp", nullable: true })
  lastReviewedAt!: Date | null;

  @Column({ type: "timestamp", nullable: true })
  nextReviewAt!: Date | null;

  @Column({ type: "boolean", default: true })
  isActive!: boolean;

  @ManyToOne(() => User, { onDelete: "CASCADE" })
  @JoinColumn({ name: "userId" })
  user!: User;

  @ManyToOne(() => KnowledgeExtract, { onDelete: "CASCADE" })
  @JoinColumn({ name: "knowledgeExtractId" })
  knowledgeExtract!: KnowledgeExtract;

  @OneToMany(() => LearningSession, (session) => session.learningCard)
  learningSessions!: LearningSession[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  get isDueForReview(): boolean {
    if (!this.nextReviewAt || !this.isActive) return false;
    return new Date() >= this.nextReviewAt;
  }

  get accuracy(): number {
    if (this.reviewCount === 0) return 0;
    return Math.round((this.correctCount / this.reviewCount) * 100);
  }

  get masteryLevel(): string {
    if (this.successRate >= 90) return "Mastered";
    if (this.successRate >= 75) return "Proficient";
    if (this.successRate >= 50) return "Learning";
    return "Needs Practice";
  }
}
