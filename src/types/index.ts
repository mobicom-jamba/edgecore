import { Request } from 'express';
import { User } from '../models/User';

export interface AuthenticatedRequest extends Request {
  user?: User;
}

export interface JWTPayload {
  userId: string;
  email: string;
  role: string;
  iat?: number;
  exp?: number;
}

export interface ApiResponse<T = any> {
  success: boolean;
  message: string;
  data?: T;
  error?: string;
  pagination?: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

export interface PaginationQuery {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: 'ASC' | 'DESC';
}

export interface SearchQuery extends PaginationQuery {
  search?: string;
  filters?: Record<string, any>;
}

export interface FileUploadResult {
  filename: string;
  originalName: string;
  mimetype: string;
  size: number;
  url: string;
  key: string;
}

export interface EmailTemplate {
  subject: string;
  html: string;
  text: string;
}

export interface QueueJob {
  id: string;
  type: string;
  data: any;
  priority?: number;
  delay?: number;
  attempts?: number;
}

export enum UserRole {
  ADMIN = 'admin',
  USER = 'user',
  MODERATOR = 'moderator',
}

export enum FileType {
  IMAGE = 'image',
  DOCUMENT = 'document',
  VIDEO = 'video',
  AUDIO = 'audio',
  OTHER = 'other',
}

export enum EmailType {
  WELCOME = 'welcome',
  PASSWORD_RESET = 'password_reset',
  EMAIL_VERIFICATION = 'email_verification',
  NOTIFICATION = 'notification',
}

export enum PlanType {
  FREE = 'free',
  BASIC = 'basic',
  PRO = 'pro',
  ENTERPRISE = 'enterprise',
}

export enum BillingCycle {
  MONTHLY = 'monthly',
  YEARLY = 'yearly',
}

export enum SubscriptionStatus {
  ACTIVE = 'active',
  CANCELLED = 'cancelled',
  PAST_DUE = 'past_due',
  UNPAID = 'unpaid',
  TRIALING = 'trialing',
  INCOMPLETE = 'incomplete',
}

export enum InvoiceStatus {
  DRAFT = 'draft',
  OPEN = 'open',
  PAID = 'paid',
  VOID = 'void',
  UNCOLLECTIBLE = 'uncollectible',
}

export enum PaymentMethod {
  CARD = 'card',
  BANK_TRANSFER = 'bank_transfer',
  PAYPAL = 'paypal',
  CRYPTO = 'crypto',
}
