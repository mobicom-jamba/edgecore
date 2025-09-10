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
import { IsNotEmpty, IsEnum, IsDateString } from 'class-validator';
import { User } from './User';
import { SubscriptionPlan } from './SubscriptionPlan';
import { Invoice } from './Invoice';
import { SubscriptionStatus } from '../types';

@Entity('subscriptions')
export class Subscription {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column()
  @IsNotEmpty()
  userId!: string;

  @Column()
  @IsNotEmpty()
  planId!: string;

  @Column({
    type: 'enum',
    enum: SubscriptionStatus,
    default: SubscriptionStatus.ACTIVE,
  })
  @IsEnum(SubscriptionStatus)
  status!: SubscriptionStatus;

  @Column({ type: 'timestamp' })
  @IsDateString()
  currentPeriodStart!: Date;

  @Column({ type: 'timestamp' })
  @IsDateString()
  currentPeriodEnd!: Date;

  @Column({ type: 'timestamp', nullable: true })
  trialStart!: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  trialEnd!: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  cancelledAt!: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  endedAt!: Date | null;

  @Column({ type: 'varchar', nullable: true })
  stripeSubscriptionId!: string | null;

  @Column({ type: 'varchar', nullable: true })
  stripeCustomerId!: string | null;

  @Column({ type: 'json', nullable: true })
  metadata!: Record<string, any> | null;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user!: User;

  @ManyToOne(() => SubscriptionPlan, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'planId' })
  plan!: SubscriptionPlan;

  @OneToMany(() => Invoice, (invoice) => invoice.subscription)
  invoices!: Invoice[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  get isActive(): boolean {
    return this.status === SubscriptionStatus.ACTIVE || this.status === SubscriptionStatus.TRIALING;
  }

  get isTrial(): boolean {
    return !!(this.status === SubscriptionStatus.TRIALING && this.trialEnd && this.trialEnd > new Date());
  }

  get daysUntilRenewal(): number {
    const now = new Date();
    const diffTime = this.currentPeriodEnd.getTime() - now.getTime();
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  }

  toJSON(): Partial<Subscription> {
    return {
      id: this.id,
      userId: this.userId,
      planId: this.planId,
      status: this.status,
      currentPeriodStart: this.currentPeriodStart,
      currentPeriodEnd: this.currentPeriodEnd,
      trialStart: this.trialStart,
      trialEnd: this.trialEnd,
      cancelledAt: this.cancelledAt,
      endedAt: this.endedAt,
      isActive: this.isActive,
      isTrial: this.isTrial,
      daysUntilRenewal: this.daysUntilRenewal,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}
