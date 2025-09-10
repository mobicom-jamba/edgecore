import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from "typeorm";
import { IsNotEmpty, IsNumber, IsBoolean, IsEnum, Min } from "class-validator";
import { Subscription } from "./Subscription";
import { PlanType, BillingCycle } from "../types";

@Entity("subscription_plans")
export class SubscriptionPlan {
  @PrimaryGeneratedColumn("uuid")
  id!: string;

  @Column({ unique: true })
  @IsNotEmpty()
  name!: string;

  @Column({ unique: true })
  @IsNotEmpty()
  slug!: string;

  @Column({ type: "text", nullable: true })
  description!: string;

  @Column({
    type: "enum",
    enum: PlanType,
  })
  @IsEnum(PlanType)
  type!: PlanType;

  @Column({ type: "decimal", precision: 10, scale: 2 })
  @IsNumber()
  @Min(0)
  price!: number;

  @Column({
    type: "enum",
    enum: BillingCycle,
    default: BillingCycle.MONTHLY,
  })
  @IsEnum(BillingCycle)
  billingCycle!: BillingCycle;

  @Column({ type: "json" })
  features!: Record<string, any>;

  @Column({ type: "json", nullable: true })
  limits!: Record<string, any>;

  @Column({ default: true })
  @IsBoolean()
  isActive!: boolean;

  @Column({ default: false })
  @IsBoolean()
  isPopular!: boolean;

  @Column({ type: "int", default: 0 })
  @IsNumber()
  @Min(0)
  sortOrder!: number;

  @OneToMany(() => Subscription, (subscription) => subscription.plan)
  subscriptions!: Subscription[];

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;

  toJSON(): Partial<SubscriptionPlan> {
    return {
      id: this.id,
      name: this.name,
      slug: this.slug,
      description: this.description,
      type: this.type,
      price: this.price,
      billingCycle: this.billingCycle,
      features: this.features,
      limits: this.limits,
      isActive: this.isActive,
      isPopular: this.isPopular,
      sortOrder: this.sortOrder,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}
