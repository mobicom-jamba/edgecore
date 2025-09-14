import { Request, Response } from 'express';
import { BillingService } from '../services/BillingService';
import { AuthenticatedRequest, ApiResponse } from '../types';
import { logError, logInfo, businessLogger } from '../utils/logger';

export class BillingController {
  private billingService: BillingService;

  constructor() {
    this.billingService = new BillingService();
  }

  // Get available subscription plans
  getPlans = async (req: Request, res: Response): Promise<void> => {
    try {
      const plans = await this.billingService.getPlans();

      const response: ApiResponse = {
        success: true,
        message: 'Subscription plans retrieved successfully',
        data: { plans },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.getPlans');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve plans',
      };

      res.status(500).json(response);
    }
  };

  // Subscribe to a plan
  subscribe = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { planId, paymentMethodId, trialDays } = req.body;

      const subscription = await this.billingService.subscribe(user.id, planId, paymentMethodId, trialDays);

      businessLogger('subscription_created', user.id, { planId, subscriptionId: subscription.id });

      const response: ApiResponse = {
        success: true,
        message: 'Subscription created successfully',
        data: { subscription: subscription.toJSON() },
      };

      res.status(201).json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.subscribe');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to create subscription',
      };

      res.status(400).json(response);
    }
  };

  // Update subscription
  updateSubscription = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { planId, prorate = true } = req.body;

      const subscription = await this.billingService.updateSubscription(user.id, planId, prorate);

      businessLogger('subscription_updated', user.id, { planId, subscriptionId: subscription.id });

      const response: ApiResponse = {
        success: true,
        message: 'Subscription updated successfully',
        data: { subscription: subscription.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.updateSubscription');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to update subscription',
      };

      res.status(400).json(response);
    }
  };

  // Cancel subscription
  cancelSubscription = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { immediately = false } = req.body;

      await this.billingService.cancelSubscription(user.id, immediately);

      businessLogger('subscription_cancelled', user.id, { immediately });

      const response: ApiResponse = {
        success: true,
        message: immediately ? 'Subscription cancelled immediately' : 'Subscription will be cancelled at the end of the billing period',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.cancelSubscription');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to cancel subscription',
      };

      res.status(400).json(response);
    }
  };

  // Get user's subscription
  getSubscription = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const subscription = await this.billingService.getUserSubscription(user.id);

      if (!subscription) {
        const response: ApiResponse = {
          success: false,
          message: 'No active subscription found',
        };
        res.status(404).json(response);
        return;
      }

      const response: ApiResponse = {
        success: true,
        message: 'Subscription retrieved successfully',
        data: { subscription: subscription.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.getSubscription');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve subscription',
      };

      res.status(500).json(response);
    }
  };

  // Get billing history
  getInvoices = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const page = parseInt(req.query.page as string) || 1;
      const limit = parseInt(req.query.limit as string) || 10;

      const result = await this.billingService.getUserInvoices(user.id, page, limit);

      const response: ApiResponse = {
        success: true,
        message: 'Billing history retrieved successfully',
        data: result.invoices,
        pagination: result.pagination,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.getInvoices');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve billing history',
      };

      res.status(500).json(response);
    }
  };

  // Get specific invoice
  getInvoice = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { invoiceId } = req.params;

      const invoice = await this.billingService.getInvoice(user.id, invoiceId);

      if (!invoice) {
        const response: ApiResponse = {
          success: false,
          message: 'Invoice not found',
        };
        res.status(404).json(response);
        return;
      }

      const response: ApiResponse = {
        success: true,
        message: 'Invoice retrieved successfully',
        data: { invoice: invoice.toJSON() },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.getInvoice');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve invoice',
      };

      res.status(500).json(response);
    }
  };

  // Get usage statistics
  getUsage = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const period = req.query.period as string || 'current';

      const usage = await this.billingService.getUsage(user.id, period);

      const response: ApiResponse = {
        success: true,
        message: 'Usage statistics retrieved successfully',
        data: usage,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.getUsage');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve usage statistics',
      };

      res.status(500).json(response);
    }
  };

  // Get usage limits
  getLimits = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const limits = await this.billingService.getLimits(user.id);

      const response: ApiResponse = {
        success: true,
        message: 'Usage limits retrieved successfully',
        data: limits,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.getLimits');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve usage limits',
      };

      res.status(500).json(response);
    }
  };

  // Create payment method
  createPaymentMethod = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { paymentMethodId } = req.body;

      const paymentMethod = await this.billingService.createPaymentMethod(user.id, paymentMethodId);

      businessLogger('payment_method_created', user.id, { paymentMethodId });

      const response: ApiResponse = {
        success: true,
        message: 'Payment method created successfully',
        data: { paymentMethod },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.createPaymentMethod');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to create payment method',
      };

      res.status(400).json(response);
    }
  };

  // Get payment methods
  getPaymentMethods = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const paymentMethods = await this.billingService.getPaymentMethods(user.id);

      const response: ApiResponse = {
        success: true,
        message: 'Payment methods retrieved successfully',
        data: { paymentMethods },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.getPaymentMethods');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to retrieve payment methods',
      };

      res.status(500).json(response);
    }
  };

  // Delete payment method
  deletePaymentMethod = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { paymentMethodId } = req.params;

      await this.billingService.deletePaymentMethod(user.id, paymentMethodId);

      businessLogger('payment_method_deleted', user.id, { paymentMethodId });

      const response: ApiResponse = {
        success: true,
        message: 'Payment method deleted successfully',
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.deletePaymentMethod');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to delete payment method',
      };

      res.status(400).json(response);
    }
  };

  // Webhook handler for Paddle events
  handleWebhook = async (req: Request, res: Response): Promise<void> => {
    try {
      const signature = req.headers['paddle-signature'] as string;
      const payload = req.body;

      await this.billingService.handleWebhook(payload, signature);

      res.status(200).json({ received: true });
    } catch (error) {
      logError(error as Error, 'BillingController.handleWebhook');
      res.status(400).json({ error: 'Webhook handling failed' });
    }
  };

  // Create Paddle checkout
  createCheckout = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
    try {
      const user = req.user!;
      const { items, customData, returnUrl } = req.body;

      const checkoutData = {
        items,
        customerId: user.paddleCustomerId,
        customData: {
          userId: user.id,
          ...customData,
        },
        returnUrl,
        allowDiscountCodes: true,
        allowPromotionCodes: true,
        allowCoupons: true,
      };

      const checkout = await this.billingService.createCheckout(checkoutData);

      const response: ApiResponse = {
        success: true,
        message: 'Checkout created successfully',
        data: { checkoutUrl: checkout.url },
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.createCheckout');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to create checkout',
      };

      res.status(400).json(response);
    }
  };

  // Get price preview
  getPricePreview = async (req: Request, res: Response): Promise<void> => {
    try {
      const { items, customerIpAddress } = req.body;

      const preview = await this.billingService.getPricePreview(items, customerIpAddress);

      const response: ApiResponse = {
        success: true,
        message: 'Price preview retrieved successfully',
        data: preview,
      };

      res.json(response);
    } catch (error) {
      logError(error as Error, 'BillingController.getPricePreview');
      
      const response: ApiResponse = {
        success: false,
        message: error instanceof Error ? error.message : 'Failed to get price preview',
      };

      res.status(400).json(response);
    }
  };
}
