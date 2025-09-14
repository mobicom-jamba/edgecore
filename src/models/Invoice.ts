import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { IsNotEmpty, IsNumber, IsEnum, IsDateString, Min } from 'class-validator';
import { User } from './User';
import { Subscription } from './Subscription';
import { InvoiceStatus, PaymentMethod } from '../types';

@Entity('invoices')
export class Invoice {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ unique: true })
  @IsNotEmpty()
  invoiceNumber!: string;

  @Column()
  @IsNotEmpty()
  userId!: string;

  @Column({ nullable: true })
  subscriptionId!: string | null;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  @IsNumber()
  @Min(0)
  subtotal!: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  @IsNumber()
  @Min(0)
  tax!: number;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0 })
  @IsNumber()
  @Min(0)
  discount!: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  @IsNumber()
  @Min(0)
  total!: number;

  @Column({
    type: 'enum',
    enum: InvoiceStatus,
    default: InvoiceStatus.DRAFT,
  })
  @IsEnum(InvoiceStatus)
  status!: InvoiceStatus;

  @Column({ type: 'timestamp', nullable: true })
  @IsDateString()
  dueDate!: Date | null;

  @Column({ type: 'timestamp', nullable: true })
  @IsDateString()
  paidAt!: Date | null;

  @Column({
    type: 'enum',
    enum: PaymentMethod,
    nullable: true,
  })
  @IsEnum(PaymentMethod)
  paymentMethod!: PaymentMethod | null;

  @Column({ type: 'varchar', nullable: true })
  stripeInvoiceId!: string | null;

  @Column({ type: 'varchar', nullable: true })
  stripePaymentIntentId!: string | null;

  @Column({ type: 'varchar', nullable: true })
  paddleTransactionId!: string | null;

  @Column({ type: 'varchar', nullable: true })
  paddleInvoiceId!: string | null;

  @Column({ type: 'json', nullable: true })
  lineItems!: Array<{
    description: string;
    quantity: number;
    unitPrice: number;
    total: number;
  }> | null;

  @Column({ type: 'json', nullable: true })
  metadata!: Record<string, any> | null;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'userId' })
  user!: User;

  @ManyToOne(() => Subscription, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'subscriptionId' })
  subscription!: Subscription | null;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  get isPaid(): boolean {
    return this.status === InvoiceStatus.PAID;
  }

  get isOverdue(): boolean {
    return !!(this.dueDate && this.dueDate < new Date() && !this.isPaid);
  }

  get daysUntilDue(): number | null {
    if (!this.dueDate || this.isPaid) return null;
    const now = new Date();
    const diffTime = this.dueDate.getTime() - now.getTime();
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  }

  toJSON(): Partial<Invoice> {
    return {
      id: this.id,
      invoiceNumber: this.invoiceNumber,
      userId: this.userId,
      subscriptionId: this.subscriptionId,
      subtotal: this.subtotal,
      tax: this.tax,
      discount: this.discount,
      total: this.total,
      status: this.status,
      dueDate: this.dueDate,
      paidAt: this.paidAt,
      paymentMethod: this.paymentMethod,
      isPaid: this.isPaid,
      isOverdue: this.isOverdue,
      daysUntilDue: this.daysUntilDue,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}
