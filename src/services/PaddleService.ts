import { Paddle } from "@paddle/paddle-node-sdk";
import { config } from "../config";
import { logError, logInfo, businessLogger } from "../utils/logger";

// Type mappings for Paddle SDK compatibility
type PaddleEnvironment = "sandbox" | "production";
type PaddleTaxCategory =
  | "standard"
  | "digital-goods"
  | "saas"
  | "ebook"
  | "software";
type PaddleCurrencyCode =
  | "USD"
  | "EUR"
  | "GBP"
  | "CAD"
  | "AUD"
  | "JPY"
  | "CHF"
  | "NOK"
  | "DKK"
  | "SEK"
  | "PLN"
  | "CZK"
  | "HUF"
  | "BGN"
  | "RON"
  | "HRK"
  | "ISK"
  | "TRY"
  | "BRL"
  | "MXN"
  | "ARS"
  | "CLP"
  | "COP"
  | "PEN"
  | "UYU"
  | "VEF"
  | "ZAR"
  | "INR"
  | "CNY"
  | "HKD"
  | "SGD"
  | "KRW"
  | "TWD"
  | "THB"
  | "MYR"
  | "PHP"
  | "IDR"
  | "VND"
  | "RUB"
  | "UAH"
  | "KZT"
  | "AED"
  | "SAR"
  | "QAR"
  | "KWD"
  | "BHD"
  | "OMR"
  | "JOD"
  | "LBP"
  | "EGP"
  | "ILS"
  | "NZD";

export interface PaddleCustomer {
  id: string;
  email: string;
  name?: string;
  customData?: Record<string, any>;
}

export interface PaddleProduct {
  id: string;
  name: string;
  description?: string;
  type: "standard" | "custom";
  taxCategory: PaddleTaxCategory;
  imageUrl?: string;
  customData?: Record<string, any>;
}

export interface PaddlePrice {
  id: string;
  productId: string;
  description?: string;
  type: "standard" | "custom";
  billingCycle?: {
    interval: "day" | "week" | "month" | "year";
    frequency: number;
  };
  trialPeriod?: {
    interval: "day" | "week" | "month" | "year";
    frequency: number;
  };
  taxMode: "account_setting" | "external" | "internal";
  unitPrice: {
    amount: string;
    currencyCode: PaddleCurrencyCode;
  };
  unitPriceOverrides?: Array<{
    countryCodes: string[];
    unitPrice: {
      amount: string;
      currencyCode: PaddleCurrencyCode;
    };
  }>;
  quantity?: {
    minimum: number;
    maximum: number;
  };
  status: "active" | "archived";
  customData?: Record<string, any>;
}

export interface PaddleSubscription {
  id: string;
  status: "active" | "canceled" | "past_due" | "paused" | "trialing";
  customerId: string;
  addressId?: string;
  businessId?: string;
  currencyCode: string;
  createdAt: string;
  updatedAt: string;
  startedAt?: string;
  firstBilledAt?: string;
  nextBilledAt?: string;
  pausedAt?: string;
  canceledAt?: string;
  discount?: {
    id: string;
    startsAt: string;
    endsAt: string;
  };
  collectionMode: "automatic" | "manual";
  billingDetails?: {
    enableCheckout: boolean;
    purchaseOrderNumber?: string;
    additionalInformation?: string;
    paymentTerms?: string;
  };
  currentBillingPeriod?: {
    startsAt: string;
    endsAt: string;
  };
  billingCycle?: {
    interval: "day" | "week" | "month" | "year";
    frequency: number;
  };
  scheduledChange?: {
    action: "cancel" | "pause" | "resume";
    effectiveAt: string;
    resumeAt?: string;
  };
  items: Array<{
    priceId: string;
    price?: PaddlePrice;
    quantity: number;
    recentlyEnded?: boolean;
  }>;
  customData?: Record<string, any>;
}

export interface PaddleTransaction {
  id: string;
  status:
    | "billed"
    | "completed"
    | "created"
    | "paid"
    | "past_due"
    | "payment_failed"
    | "canceled";
  customerId: string;
  addressId?: string;
  businessId?: string;
  customData?: Record<string, any>;
  currencyCode: string;
  origin:
    | "api"
    | "subscription_charge"
    | "subscription_change"
    | "subscription_retry"
    | "subscription_update"
    | "web";
  subscriptionId?: string;
  invoiceId?: string;
  invoiceNumber?: string;
  collectionMode: "automatic" | "manual";
  billingDetails?: {
    enableCheckout: boolean;
    purchaseOrderNumber?: string;
    additionalInformation?: string;
    paymentTerms?: string;
  };
  billingPeriod?: {
    startsAt: string;
    endsAt: string;
  };
  items: Array<{
    priceId: string;
    price?: PaddlePrice;
    quantity: number;
    proration?: {
      rate: string;
      billingPeriod?: {
        startsAt: string;
        endsAt: string;
      };
    };
  }>;
  details: {
    totals: {
      subtotal: string;
      discount: string;
      tax: string;
      total: string;
      credit: string;
      balance: string;
      grandTotal: string;
      fee: string;
      earnings: string;
      currencyCode: string;
    };
    lineItems: Array<{
      id: string;
      priceId: string;
      quantity: number;
      proration?: {
        rate: string;
        billingPeriod?: {
          startsAt: string;
          endsAt: string;
        };
      };
      taxRate: string;
      unitTotals: {
        subtotal: string;
        discount: string;
        tax: string;
        total: string;
      };
      totals: {
        subtotal: string;
        discount: string;
        tax: string;
        total: string;
      };
      product?: PaddleProduct;
      price?: PaddlePrice;
    }>;
    payoutTotals?: {
      subtotal: string;
      discount: string;
      tax: string;
      total: string;
      credit: string;
      balance: string;
      grandTotal: string;
      fee: string;
      earnings: string;
      currencyCode: string;
    };
    adjustedTotals?: {
      subtotal: string;
      discount: string;
      tax: string;
      total: string;
      credit: string;
      balance: string;
      grandTotal: string;
      fee: string;
      earnings: string;
      currencyCode: string;
    };
    adjustedPayoutTotals?: {
      subtotal: string;
      discount: string;
      tax: string;
      total: string;
      credit: string;
      balance: string;
      grandTotal: string;
      fee: string;
      earnings: string;
      currencyCode: string;
    };
    taxRatesUsed: Array<{
      taxRate: string;
      totals: {
        subtotal: string;
        discount: string;
        tax: string;
        total: string;
      };
    }>;
  };
  checkout?: {
    url: string;
  };
  createdAt: string;
  updatedAt: string;
  billedAt?: string;
}

export interface PaddleCheckoutRequest {
  items: Array<{
    priceId: string;
    quantity: number;
  }>;
  customerId?: string;
  customData?: Record<string, any>;
  discountId?: string;
  currencyCode?: string;
  addressId?: string;
  businessId?: string;
  customFields?: Array<{
    key: string;
    value: string;
  }>;
  customerIpAddress?: string;
  locale?: string;
  allowDiscountCodes?: boolean;
  allowPromotionCodes?: boolean;
  allowCoupons?: boolean;
  allowTaxInclusivePricing?: boolean;
  previewMode?: boolean;
  checkoutUrl?: string;
  returnUrl?: string;
  billingDetails?: {
    enableCheckout: boolean;
    purchaseOrderNumber?: string;
    additionalInformation?: string;
    paymentTerms?: string;
  };
  billingAddress?: {
    countryCode: string;
    postalCode?: string;
    region?: string;
    city?: string;
    line1?: string;
    line2?: string;
  };
  shippingAddress?: {
    countryCode: string;
    postalCode?: string;
    region?: string;
    city?: string;
    line1?: string;
    line2?: string;
  };
}

export class PaddleService {
  private paddle: Paddle;

  constructor() {
    this.paddle = new Paddle(config.paddle.apiKey, {
      environment: config.paddle.environment as any,
    });
  }

  // Customer Management
  async createCustomer(
    email: string,
    name?: string,
    customData?: Record<string, any>
  ): Promise<PaddleCustomer> {
    try {
      const response = await this.paddle.customers.create({
        email,
        name,
        customData,
      });

      businessLogger("paddle_customer_created", undefined, {
        email,
        customerId: response.id,
      });

      return {
        id: response.id,
        email: response.email,
        name: response.name || undefined,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.createCustomer");
      throw error;
    }
  }

  async getCustomer(customerId: string): Promise<PaddleCustomer> {
    try {
      const response = await this.paddle.customers.get(customerId);
      return {
        id: response.id,
        email: response.email,
        name: response.name || undefined,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.getCustomer");
      throw error;
    }
  }

  async updateCustomer(
    customerId: string,
    data: Partial<PaddleCustomer>
  ): Promise<PaddleCustomer> {
    try {
      const response = await this.paddle.customers.update(customerId, data);
      businessLogger("paddle_customer_updated", undefined, { customerId });
      return {
        id: response.id,
        email: response.email,
        name: response.name || undefined,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.updateCustomer");
      throw error;
    }
  }

  // Product Management
  async createProduct(data: Omit<PaddleProduct, "id">): Promise<PaddleProduct> {
    try {
      const response = await this.paddle.products.create({
        name: data.name,
        description: data.description || "",
        type: data.type,
        taxCategory: data.taxCategory as any,
        imageUrl: data.imageUrl,
        customData: data.customData,
      });
      businessLogger("paddle_product_created", undefined, {
        productId: response.id,
        name: response.name,
      });
      return {
        id: response.id,
        name: response.name,
        description: response.description || undefined,
        type: response.type as "standard" | "custom",
        taxCategory: response.taxCategory as PaddleTaxCategory,
        imageUrl: response.imageUrl || undefined,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.createProduct");
      throw error;
    }
  }

  async getProduct(productId: string): Promise<PaddleProduct> {
    try {
      const response = await this.paddle.products.get(productId);
      return {
        id: response.id,
        name: response.name,
        description: response.description || undefined,
        type: response.type as "standard" | "custom",
        taxCategory: response.taxCategory as PaddleTaxCategory,
        imageUrl: response.imageUrl || undefined,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.getProduct");
      throw error;
    }
  }

  async updateProduct(
    productId: string,
    data: Partial<PaddleProduct>
  ): Promise<PaddleProduct> {
    try {
      const response = await this.paddle.products.update(
        productId,
        data as any
      );
      businessLogger("paddle_product_updated", undefined, { productId });
      return {
        id: response.id,
        name: response.name,
        description: response.description || undefined,
        type: response.type as "standard" | "custom",
        taxCategory: response.taxCategory as PaddleTaxCategory,
        imageUrl: response.imageUrl || undefined,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.updateProduct");
      throw error;
    }
  }

  // Price Management
  async createPrice(data: Omit<PaddlePrice, "id">): Promise<PaddlePrice> {
    try {
      const response = await this.paddle.prices.create({
        productId: data.productId,
        description: data.description || "",
        type: data.type,
        billingCycle: data.billingCycle,
        trialPeriod: data.trialPeriod,
        taxMode: data.taxMode,
        unitPrice: data.unitPrice as any,
        unitPriceOverrides: data.unitPriceOverrides as any,
        quantity: data.quantity,
        // status: data.status, // Remove status from create request
        customData: data.customData,
      });
      businessLogger("paddle_price_created", undefined, {
        priceId: response.id,
        productId: response.productId,
      });
      return {
        id: response.id,
        productId: response.productId,
        description: response.description || undefined,
        type: response.type as "standard" | "custom",
        billingCycle: response.billingCycle
          ? {
              interval: response.billingCycle.interval as any,
              frequency: response.billingCycle.frequency,
            }
          : undefined,
        trialPeriod: response.trialPeriod
          ? {
              interval: response.trialPeriod.interval as any,
              frequency: response.trialPeriod.frequency,
            }
          : undefined,
        taxMode: response.taxMode,
        unitPrice: {
          amount: response.unitPrice.amount,
          currencyCode: response.unitPrice.currencyCode as PaddleCurrencyCode,
        },
        unitPriceOverrides: response.unitPriceOverrides?.map((override) => ({
          countryCodes: override.countryCodes,
          unitPrice: {
            amount: override.unitPrice.amount,
            currencyCode: override.unitPrice.currencyCode as PaddleCurrencyCode,
          },
        })),
        quantity: response.quantity,
        status: response.status,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.createPrice");
      throw error;
    }
  }

  async getPrice(priceId: string): Promise<PaddlePrice> {
    try {
      const response = await this.paddle.prices.get(priceId);
      return {
        id: response.id,
        productId: response.productId,
        description: response.description || undefined,
        type: response.type as "standard" | "custom",
        billingCycle: response.billingCycle
          ? {
              interval: response.billingCycle.interval as any,
              frequency: response.billingCycle.frequency,
            }
          : undefined,
        trialPeriod: response.trialPeriod
          ? {
              interval: response.trialPeriod.interval as any,
              frequency: response.trialPeriod.frequency,
            }
          : undefined,
        taxMode: response.taxMode,
        unitPrice: {
          amount: response.unitPrice.amount,
          currencyCode: response.unitPrice.currencyCode as PaddleCurrencyCode,
        },
        unitPriceOverrides: response.unitPriceOverrides?.map((override) => ({
          countryCodes: override.countryCodes,
          unitPrice: {
            amount: override.unitPrice.amount,
            currencyCode: override.unitPrice.currencyCode as PaddleCurrencyCode,
          },
        })),
        quantity: response.quantity,
        status: response.status,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.getPrice");
      throw error;
    }
  }

  async updatePrice(
    priceId: string,
    data: Partial<PaddlePrice>
  ): Promise<PaddlePrice> {
    try {
      const response = await this.paddle.prices.update(priceId, data as any);
      businessLogger("paddle_price_updated", undefined, { priceId });
      return {
        id: response.id,
        productId: response.productId,
        description: response.description || undefined,
        type: response.type as "standard" | "custom",
        billingCycle: response.billingCycle
          ? {
              interval: response.billingCycle.interval as any,
              frequency: response.billingCycle.frequency,
            }
          : undefined,
        trialPeriod: response.trialPeriod
          ? {
              interval: response.trialPeriod.interval as any,
              frequency: response.trialPeriod.frequency,
            }
          : undefined,
        taxMode: response.taxMode,
        unitPrice: {
          amount: response.unitPrice.amount,
          currencyCode: response.unitPrice.currencyCode as PaddleCurrencyCode,
        },
        unitPriceOverrides: response.unitPriceOverrides?.map((override) => ({
          countryCodes: override.countryCodes,
          unitPrice: {
            amount: override.unitPrice.amount,
            currencyCode: override.unitPrice.currencyCode as PaddleCurrencyCode,
          },
        })),
        quantity: response.quantity,
        status: response.status,
        customData: response.customData || undefined,
      };
    } catch (error) {
      logError(error as Error, "PaddleService.updatePrice");
      throw error;
    }
  }

  // Subscription Management - Simplified for now
  async createSubscription(
    customerId: string,
    items: Array<{ priceId: string; quantity: number }>
  ): Promise<PaddleSubscription> {
    try {
      // For now, return a mock subscription until we can properly implement
      // the actual Paddle subscription creation
      const mockSubscription: PaddleSubscription = {
        id: `sub_${Date.now()}`,
        status: "active",
        customerId,
        currencyCode: "USD",
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        collectionMode: "automatic",
        items: items.map((item) => ({
          priceId: item.priceId,
          quantity: item.quantity,
        })),
      };

      businessLogger("paddle_subscription_created", undefined, {
        subscriptionId: mockSubscription.id,
        customerId,
        items: items.length,
      });
      return mockSubscription;
    } catch (error) {
      logError(error as Error, "PaddleService.createSubscription");
      throw error;
    }
  }

  async getSubscription(subscriptionId: string): Promise<PaddleSubscription> {
    try {
      // Mock implementation for now
      throw new Error("Not implemented yet");
    } catch (error) {
      logError(error as Error, "PaddleService.getSubscription");
      throw error;
    }
  }

  async updateSubscription(
    subscriptionId: string,
    data: Partial<PaddleSubscription>
  ): Promise<PaddleSubscription> {
    try {
      // Mock implementation for now
      throw new Error("Not implemented yet");
    } catch (error) {
      logError(error as Error, "PaddleService.updateSubscription");
      throw error;
    }
  }

  async cancelSubscription(
    subscriptionId: string,
    effectiveAt?: string
  ): Promise<PaddleSubscription> {
    try {
      // Mock implementation for now
      throw new Error("Not implemented yet");
    } catch (error) {
      logError(error as Error, "PaddleService.cancelSubscription");
      throw error;
    }
  }

  async pauseSubscription(
    subscriptionId: string,
    effectiveAt?: string,
    resumeAt?: string
  ): Promise<PaddleSubscription> {
    try {
      // Mock implementation for now
      throw new Error("Not implemented yet");
    } catch (error) {
      logError(error as Error, "PaddleService.pauseSubscription");
      throw error;
    }
  }

  async resumeSubscription(
    subscriptionId: string,
    effectiveAt?: string
  ): Promise<PaddleSubscription> {
    try {
      // Mock implementation for now
      throw new Error("Not implemented yet");
    } catch (error) {
      logError(error as Error, "PaddleService.resumeSubscription");
      throw error;
    }
  }

  // Transaction Management
  async getTransaction(transactionId: string): Promise<PaddleTransaction> {
    try {
      // Mock implementation for now
      throw new Error("Not implemented yet");
    } catch (error) {
      logError(error as Error, "PaddleService.getTransaction");
      throw error;
    }
  }

  async listTransactions(filters?: {
    customerId?: string;
    subscriptionId?: string;
    status?: string;
    createdAt?: string;
  }): Promise<PaddleTransaction[]> {
    try {
      // Mock implementation for now
      return [];
    } catch (error) {
      logError(error as Error, "PaddleService.listTransactions");
      throw error;
    }
  }

  // Checkout Management
  async createCheckout(
    checkoutData: PaddleCheckoutRequest
  ): Promise<{ url: string }> {
    try {
      // Mock implementation for now
      const mockUrl = `https://checkout.paddle.com/checkout/${Date.now()}`;
      businessLogger("paddle_checkout_created", undefined, {
        checkoutUrl: mockUrl,
        items: checkoutData.items.length,
      });
      return { url: mockUrl };
    } catch (error) {
      logError(error as Error, "PaddleService.createCheckout");
      throw error;
    }
  }

  // Price Preview
  async getPricePreview(
    items: Array<{ priceId: string; quantity: number }>,
    customerIpAddress?: string
  ): Promise<any> {
    try {
      // Mock implementation for now
      return {
        details: {
          totals: {
            subtotal: "100.00",
            discount: "0.00",
            tax: "10.00",
            total: "110.00",
            currencyCode: "USD",
          },
        },
      };
    } catch (error) {
      logError(error as Error, "PaddleService.getPricePreview");
      throw error;
    }
  }

  // Webhook Verification
  verifyWebhook(payload: string, signature: string): boolean {
    try {
      // Mock implementation for now - in production, use actual Paddle webhook verification
      return true;
    } catch (error) {
      logError(error as Error, "PaddleService.verifyWebhook");
      return false;
    }
  }

  // Helper method to sync subscription plan with Paddle
  async syncSubscriptionPlan(planData: {
    name: string;
    description?: string;
    price: number;
    billingCycle: "monthly" | "yearly";
    features: Record<string, any>;
    limits: Record<string, any>;
  }): Promise<{ productId: string; priceId: string }> {
    try {
      // Create product
      const product = await this.createProduct({
        name: planData.name,
        description: planData.description,
        type: "standard",
        taxCategory: "saas",
        customData: {
          features: planData.features,
          limits: planData.limits,
        },
      });

      // Create price
      const price = await this.createPrice({
        productId: product.id,
        description: planData.description,
        type: "standard",
        billingCycle: {
          interval: planData.billingCycle === "monthly" ? "month" : "year",
          frequency: 1,
        },
        taxMode: "account_setting",
        unitPrice: {
          amount: (planData.price * 100).toString(), // Convert to cents
          currencyCode: "USD",
        },
        status: "active",
        customData: {
          planType: planData.billingCycle,
        },
      });

      businessLogger("paddle_plan_synced", undefined, {
        productId: product.id,
        priceId: price.id,
        planName: planData.name,
      });

      return { productId: product.id, priceId: price.id };
    } catch (error) {
      logError(error as Error, "PaddleService.syncSubscriptionPlan");
      throw error;
    }
  }
}
