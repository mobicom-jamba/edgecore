// Billing and Subscription Types
export interface SubscriptionPlan {
  id: string;
  name: string;
  slug: string;
  description: string;
  type: 'free' | 'basic' | 'pro' | 'enterprise';
  price: number;
  billingCycle: 'monthly' | 'yearly';
  features: Record<string, any>;
  limits: {
    maxFiles: number;
    maxStorage: number; // in bytes
    maxApiRequests: number;
    maxTeamMembers: number;
  };
  isActive: boolean;
  isPopular: boolean;
  sortOrder: number;
  createdAt: string;
  updatedAt: string;
}

export interface Subscription {
  id: string;
  userId: string;
  planId: string;
  status: 'active' | 'canceled' | 'past_due' | 'paused' | 'trialing';
  paddleSubscriptionId?: string;
  paddleCustomerId?: string;
  currentPeriodStart: string;
  currentPeriodEnd: string;
  cancelAtPeriodEnd: boolean;
  canceledAt?: string;
  trialStart?: string;
  trialEnd?: string;
  createdAt: string;
  updatedAt: string;
  plan: SubscriptionPlan;
}

export interface Invoice {
  id: string;
  userId: string;
  subscriptionId: string;
  amount: number;
  currency: string;
  status: 'draft' | 'open' | 'paid' | 'void' | 'uncollectible';
  paddleTransactionId?: string;
  paddleInvoiceId?: string;
  invoiceUrl?: string;
  hostedInvoiceUrl?: string;
  paidAt?: string;
  dueDate: string;
  createdAt: string;
  updatedAt: string;
  subscription: Subscription;
}

export interface UsageStats {
  filesUploaded: number;
  storageUsed: number; // in bytes
  apiRequests: number;
  teamMembers: number;
  limits: {
    maxFiles: number;
    maxStorage: number;
    maxApiRequests: number;
    maxTeamMembers: number;
  };
  usagePercentages: {
    files: number;
    storage: number;
    apiRequests: number;
    teamMembers: number;
  };
}

export interface PaddleCheckoutData {
  checkoutId: string;
  url: string;
  expiresAt: string;
  customerId?: string;
  customData?: Record<string, any>;
}

export interface PaddleSubscriptionData {
  id: string;
  status: 'active' | 'canceled' | 'past_due' | 'paused' | 'trialing';
  customerId: string;
  currencyCode: string;
  createdAt: string;
  updatedAt: string;
  currentBillingPeriod?: {
    startsAt: string;
    endsAt: string;
  };
  items: Array<{
    priceId: string;
    quantity: number;
  }>;
}

export interface PaddleTransactionData {
  id: string;
  status: 'billed' | 'completed' | 'created' | 'paid' | 'past_due' | 'payment_failed';
  customerId: string;
  subscriptionId?: string;
  invoiceId?: string;
  currencyCode: string;
  totals: {
    subtotal: string;
    discount: string;
    tax: string;
    total: string;
    currencyCode: string;
  };
  createdAt: string;
  updatedAt: string;
}

// API Response Types
export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
  error?: string;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// Form Types
export interface SubscribeFormData {
  planId: string;
  billingCycle: 'monthly' | 'yearly';
  paymentMethodId?: string;
}

export interface UpdateSubscriptionFormData {
  planId?: string;
  billingCycle?: 'monthly' | 'yearly';
  cancelAtPeriodEnd?: boolean;
}

// Component Props Types
export interface BillingCardProps {
  plan: SubscriptionPlan;
  currentPlan?: Subscription;
  onSelect: (plan: SubscriptionPlan) => void;
  isSelected?: boolean;
  isLoading?: boolean;
}

export interface UsageCardProps {
  title: string;
  current: number;
  limit: number;
  unit: string;
  percentage: number;
  color?: 'blue' | 'green' | 'yellow' | 'red';
}

export interface InvoiceTableProps {
  invoices: Invoice[];
  isLoading?: boolean;
  onViewInvoice: (invoice: Invoice) => void;
}

export interface SubscriptionStatusProps {
  subscription: Subscription;
  onManage: () => void;
  onCancel: () => void;
}

// Error Types
export interface BillingError {
  code: string;
  message: string;
  details?: Record<string, any>;
}

// Utility Types
export type BillingCycle = 'monthly' | 'yearly';
export type PlanType = 'free' | 'basic' | 'pro' | 'enterprise';
export type SubscriptionStatus = 'active' | 'canceled' | 'past_due' | 'paused' | 'trialing';
export type InvoiceStatus = 'draft' | 'open' | 'paid' | 'void' | 'uncollectible';
