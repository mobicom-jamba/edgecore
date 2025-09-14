import { Repository, Between } from "typeorm";
import { AppDataSource } from "../config/database";
import { SubscriptionPlan } from "../models/SubscriptionPlan";
import { Subscription } from "../models/Subscription";
import { Invoice } from "../models/Invoice";
import { User } from "../models/User";
import {
  PlanType,
  BillingCycle,
  SubscriptionStatus,
  InvoiceStatus,
} from "../types";
import { logError, logInfo, businessLogger } from "../utils/logger";
import { PaddleService } from "./PaddleService";

export interface UsageStats {
  filesUploaded: number;
  storageUsed: number;
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

export class BillingService {
  private planRepository: Repository<SubscriptionPlan>;
  private subscriptionRepository: Repository<Subscription>;
  private invoiceRepository: Repository<Invoice>;
  private userRepository: Repository<User>;
  private paddleService: PaddleService;

  constructor() {
    this.planRepository = AppDataSource.getRepository(SubscriptionPlan);
    this.subscriptionRepository = AppDataSource.getRepository(Subscription);
    this.invoiceRepository = AppDataSource.getRepository(Invoice);
    this.userRepository = AppDataSource.getRepository(User);
    this.paddleService = new PaddleService();
  }

  async getPlans(): Promise<SubscriptionPlan[]> {
    return this.planRepository.find({
      where: { isActive: true },
      order: { sortOrder: "ASC" },
    });
  }

  async subscribe(
    userId: string,
    planId: string,
    paymentMethodId?: string,
    trialDays?: number
  ): Promise<Subscription> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new Error("User not found");
    }

    const plan = await this.planRepository.findOne({
      where: { id: planId, isActive: true },
    });
    if (!plan) {
      throw new Error("Plan not found");
    }

    // Check if user already has an active subscription
    const existingSubscription = await this.subscriptionRepository.findOne({
      where: { userId, status: SubscriptionStatus.ACTIVE },
    });

    if (existingSubscription) {
      throw new Error("User already has an active subscription");
    }

    // Ensure plan is synced with Paddle
    if (!plan.paddleProductId || !plan.paddlePriceId) {
      await this.syncPlanWithPaddle(plan);
    }

    // Create or get Paddle customer
    let paddleCustomerId = user.paddleCustomerId;
    if (!paddleCustomerId) {
      const paddleCustomer = await this.paddleService.createCustomer(
        user.email,
        `${user.firstName} ${user.lastName}`,
        { userId: user.id }
      );
      paddleCustomerId = paddleCustomer.id;

      // Update user with Paddle customer ID
      user.paddleCustomerId = paddleCustomerId;
      await this.userRepository.save(user);
    }

    // Create Paddle subscription
    const paddleSubscription = await this.paddleService.createSubscription(
      paddleCustomerId,
      [{ priceId: plan.paddlePriceId!, quantity: 1 }]
    );

    const now = new Date();
    const periodEnd = new Date(now);

    // Calculate period end based on billing cycle
    if (plan.billingCycle === BillingCycle.MONTHLY) {
      periodEnd.setMonth(periodEnd.getMonth() + 1);
    } else {
      periodEnd.setFullYear(periodEnd.getFullYear() + 1);
    }

    const subscription = this.subscriptionRepository.create({
      userId,
      planId,
      status: trialDays
        ? SubscriptionStatus.TRIALING
        : SubscriptionStatus.ACTIVE,
      currentPeriodStart: now,
      currentPeriodEnd: periodEnd,
      trialStart: trialDays ? now : null,
      trialEnd: trialDays
        ? new Date(now.getTime() + trialDays * 24 * 60 * 60 * 1000)
        : null,
      paddleCustomerId,
      paddleSubscriptionId: paddleSubscription.id,
    });

    const savedSubscription = await this.subscriptionRepository.save(
      subscription
    );

    // Create initial invoice if not in trial
    if (!trialDays) {
      await this.createInvoice(userId, savedSubscription.id, plan);
    }

    return savedSubscription;
  }

  async updateSubscription(
    userId: string,
    newPlanId: string,
    prorate: boolean = true
  ): Promise<Subscription> {
    const subscription = await this.subscriptionRepository.findOne({
      where: { userId, status: SubscriptionStatus.ACTIVE },
      relations: ["plan"],
    });

    if (!subscription) {
      throw new Error("No active subscription found");
    }

    const newPlan = await this.planRepository.findOne({
      where: { id: newPlanId, isActive: true },
    });
    if (!newPlan) {
      throw new Error("Plan not found");
    }

    // Ensure new plan is synced with Paddle
    if (!newPlan.paddleProductId || !newPlan.paddlePriceId) {
      await this.syncPlanWithPaddle(newPlan);
    }

    // Update Paddle subscription
    if (subscription.paddleSubscriptionId) {
      await this.paddleService.updateSubscription(
        subscription.paddleSubscriptionId,
        {
          items: [{ priceId: newPlan.paddlePriceId!, quantity: 1 }],
        }
      );
    }

    // Update local subscription
    subscription.planId = newPlanId;

    if (prorate) {
      // Calculate prorated amount and create adjustment invoice
      // This is simplified - in real implementation, you'd calculate actual proration
      await this.createInvoice(userId, subscription.id, newPlan, true);
    }

    return this.subscriptionRepository.save(subscription);
  }

  async cancelSubscription(
    userId: string,
    immediately: boolean = false
  ): Promise<void> {
    const subscription = await this.subscriptionRepository.findOne({
      where: { userId, status: SubscriptionStatus.ACTIVE },
    });

    if (!subscription) {
      throw new Error("No active subscription found");
    }

    // Cancel Paddle subscription
    if (subscription.paddleSubscriptionId) {
      await this.paddleService.cancelSubscription(
        subscription.paddleSubscriptionId,
        immediately ? undefined : subscription.currentPeriodEnd.toISOString()
      );
    }

    if (immediately) {
      subscription.status = SubscriptionStatus.CANCELLED;
      subscription.endedAt = new Date();
    } else {
      subscription.status = SubscriptionStatus.CANCELLED;
      subscription.cancelledAt = new Date();
      // Subscription will end at the end of the current period
    }

    await this.subscriptionRepository.save(subscription);
  }

  async getUserSubscription(userId: string): Promise<Subscription | null> {
    return this.subscriptionRepository.findOne({
      where: { userId },
      relations: ["plan"],
      order: { createdAt: "DESC" },
    });
  }

  async getUserInvoices(
    userId: string,
    page: number = 1,
    limit: number = 10
  ): Promise<{
    invoices: Invoice[];
    pagination: {
      page: number;
      limit: number;
      total: number;
      totalPages: number;
    };
  }> {
    const [invoices, total] = await this.invoiceRepository.findAndCount({
      where: { userId },
      order: { createdAt: "DESC" },
      skip: (page - 1) * limit,
      take: limit,
    });

    return {
      invoices,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getInvoice(userId: string, invoiceId: string): Promise<Invoice | null> {
    return this.invoiceRepository.findOne({
      where: { id: invoiceId, userId },
    });
  }

  async getUsage(userId: string, period: string): Promise<UsageStats> {
    const subscription = await this.getUserSubscription(userId);
    if (!subscription) {
      throw new Error("No subscription found");
    }

    const plan = subscription.plan;
    const limits = plan.limits || {};

    // In a real implementation, these would be calculated from actual usage data
    const usage: UsageStats = {
      filesUploaded: 0, // Would query file count
      storageUsed: 0, // Would query total file sizes
      apiRequests: 0, // Would query API request logs
      teamMembers: 1, // Would query team members
      limits: {
        maxFiles: limits.maxFiles || 1000,
        maxStorage: limits.maxStorage || 10737418240, // 10GB in bytes
        maxApiRequests: limits.maxApiRequests || 10000,
        maxTeamMembers: limits.maxTeamMembers || 5,
      },
      usagePercentages: {
        files: 0,
        storage: 0,
        apiRequests: 0,
        teamMembers: 0,
      },
    };

    // Calculate usage percentages
    usage.usagePercentages.files =
      (usage.filesUploaded / usage.limits.maxFiles) * 100;
    usage.usagePercentages.storage =
      (usage.storageUsed / usage.limits.maxStorage) * 100;
    usage.usagePercentages.apiRequests =
      (usage.apiRequests / usage.limits.maxApiRequests) * 100;
    usage.usagePercentages.teamMembers =
      (usage.teamMembers / usage.limits.maxTeamMembers) * 100;

    return usage;
  }

  async getLimits(userId: string): Promise<any> {
    const subscription = await this.getUserSubscription(userId);
    if (!subscription) {
      // Return free plan limits
      return {
        maxFiles: 100,
        maxStorage: 1073741824, // 1GB
        maxApiRequests: 1000,
        maxTeamMembers: 1,
      };
    }

    return subscription.plan.limits || {};
  }

  async createPaymentMethod(
    userId: string,
    paymentMethodId: string
  ): Promise<any> {
    // In a real implementation, this would integrate with Stripe
    // For now, we'll just return a mock response
    return {
      id: paymentMethodId,
      type: "card",
      card: {
        brand: "visa",
        last4: "4242",
        expMonth: 12,
        expYear: 2025,
      },
    };
  }

  async getPaymentMethods(userId: string): Promise<any[]> {
    // In a real implementation, this would query Stripe
    return [];
  }

  async deletePaymentMethod(
    userId: string,
    paymentMethodId: string
  ): Promise<void> {
    // In a real implementation, this would delete from Paddle
    businessLogger("payment_method_deleted", userId, { paymentMethodId });
  }

  async createCheckout(checkoutData: any): Promise<{ url: string }> {
    return this.paddleService.createCheckout(checkoutData);
  }

  async getPricePreview(
    items: Array<{ priceId: string; quantity: number }>,
    customerIpAddress?: string
  ): Promise<any> {
    return this.paddleService.getPricePreview(items, customerIpAddress);
  }

  async handleWebhook(payload: any, signature: string): Promise<void> {
    // Verify Paddle webhook signature
    if (!this.paddleService.verifyWebhook(JSON.stringify(payload), signature)) {
      throw new Error("Invalid webhook signature");
    }

    const eventType = payload.eventType;
    const data = payload.data;

    logInfo("Paddle webhook received", { eventType, eventId: payload.eventId });

    switch (eventType) {
      case "subscription.created":
        await this.handleSubscriptionCreated(data);
        break;
      case "subscription.updated":
        await this.handleSubscriptionUpdated(data);
        break;
      case "subscription.canceled":
        await this.handleSubscriptionCanceled(data);
        break;
      case "transaction.created":
        await this.handleTransactionCreated(data);
        break;
      case "transaction.updated":
        await this.handleTransactionUpdated(data);
        break;
      case "transaction.paid":
        await this.handleTransactionPaid(data);
        break;
      default:
        logInfo("Unhandled webhook event", { eventType });
    }
  }

  private async createInvoice(
    userId: string,
    subscriptionId: string,
    plan: SubscriptionPlan,
    isProration: boolean = false
  ): Promise<Invoice> {
    const invoiceNumber = `INV-${Date.now()}-${Math.random()
      .toString(36)
      .substr(2, 9)}`;

    const subtotal = plan.price;
    const tax = subtotal * 0.1; // 10% tax - in real implementation, this would be calculated based on location
    const total = subtotal + tax;

    const invoice = this.invoiceRepository.create({
      invoiceNumber,
      userId,
      subscriptionId,
      subtotal,
      tax,
      total,
      status: InvoiceStatus.OPEN,
      dueDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
      lineItems: [
        {
          description: `${plan.name} subscription${
            isProration ? " (prorated)" : ""
          }`,
          quantity: 1,
          unitPrice: plan.price,
          total: plan.price,
        },
      ],
    });

    return this.invoiceRepository.save(invoice);
  }

  private async syncPlanWithPaddle(plan: SubscriptionPlan): Promise<void> {
    try {
      const { productId, priceId } =
        await this.paddleService.syncSubscriptionPlan({
          name: plan.name,
          description: plan.description,
          price: plan.price,
          billingCycle:
            plan.billingCycle === BillingCycle.MONTHLY ? "monthly" : "yearly",
          features: plan.features,
          limits: plan.limits,
        });

      plan.paddleProductId = productId;
      plan.paddlePriceId = priceId;
      await this.planRepository.save(plan);

      businessLogger("plan_synced_with_paddle", undefined, {
        planId: plan.id,
        productId,
        priceId,
      });
    } catch (error) {
      logError(error as Error, "BillingService.syncPlanWithPaddle");
      throw error;
    }
  }

  private async handleSubscriptionCreated(data: any): Promise<void> {
    // Handle subscription created webhook
    logInfo("Subscription created webhook", { subscriptionId: data.id });
  }

  private async handleSubscriptionUpdated(data: any): Promise<void> {
    // Handle subscription updated webhook
    logInfo("Subscription updated webhook", { subscriptionId: data.id });
  }

  private async handleSubscriptionCanceled(data: any): Promise<void> {
    // Handle subscription canceled webhook
    logInfo("Subscription canceled webhook", { subscriptionId: data.id });
  }

  private async handleTransactionCreated(data: any): Promise<void> {
    // Handle transaction created webhook
    logInfo("Transaction created webhook", { transactionId: data.id });
  }

  private async handleTransactionUpdated(data: any): Promise<void> {
    // Handle transaction updated webhook
    logInfo("Transaction updated webhook", { transactionId: data.id });
  }

  private async handleTransactionPaid(data: any): Promise<void> {
    // Handle transaction paid webhook
    logInfo("Transaction paid webhook", { transactionId: data.id });

    // Update invoice status if it exists
    if (data.subscriptionId) {
      const subscription = await this.subscriptionRepository.findOne({
        where: { paddleSubscriptionId: data.subscriptionId },
      });

      if (subscription) {
        const invoice = await this.invoiceRepository.findOne({
          where: {
            subscriptionId: subscription.id,
            status: InvoiceStatus.OPEN,
          },
        });

        if (invoice) {
          invoice.status = InvoiceStatus.PAID;
          invoice.paidAt = new Date();
          invoice.paddleTransactionId = data.id;
          await this.invoiceRepository.save(invoice);
        }
      }
    }
  }
}
