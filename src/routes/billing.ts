import { Router } from 'express';
import { BillingController } from '../controllers/BillingController';
import { AuthMiddleware } from '../middleware/auth';
import { validateRequest } from '../middleware/validation';
import Joi from 'joi';

const router = Router();
const billingController = new BillingController();
const authMiddleware = new AuthMiddleware();

// Apply authentication to all routes
router.use(authMiddleware.authenticate);

/**
 * @swagger
 * components:
 *   schemas:
 *     SubscriptionPlan:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           format: uuid
 *         name:
 *           type: string
 *         slug:
 *           type: string
 *         description:
 *           type: string
 *         type:
 *           type: string
 *           enum: [free, basic, pro, enterprise]
 *         price:
 *           type: number
 *           format: decimal
 *         billingCycle:
 *           type: string
 *           enum: [monthly, yearly]
 *         features:
 *           type: object
 *         limits:
 *           type: object
 *         isActive:
 *           type: boolean
 *         isPopular:
 *           type: boolean
 *         sortOrder:
 *           type: integer
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 *     
 *     Subscription:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           format: uuid
 *         userId:
 *           type: string
 *           format: uuid
 *         planId:
 *           type: string
 *           format: uuid
 *         status:
 *           type: string
 *           enum: [active, cancelled, past_due, unpaid, trialing, incomplete]
 *         currentPeriodStart:
 *           type: string
 *           format: date-time
 *         currentPeriodEnd:
 *           type: string
 *           format: date-time
 *         trialStart:
 *           type: string
 *           format: date-time
 *           nullable: true
 *         trialEnd:
 *           type: string
 *           format: date-time
 *           nullable: true
 *         cancelledAt:
 *           type: string
 *           format: date-time
 *           nullable: true
 *         endedAt:
 *           type: string
 *           format: date-time
 *           nullable: true
 *         isActive:
 *           type: boolean
 *         isTrial:
 *           type: boolean
 *         daysUntilRenewal:
 *           type: integer
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 *     
 *     Invoice:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           format: uuid
 *         invoiceNumber:
 *           type: string
 *         userId:
 *           type: string
 *           format: uuid
 *         subscriptionId:
 *           type: string
 *           format: uuid
 *           nullable: true
 *         subtotal:
 *           type: number
 *           format: decimal
 *         tax:
 *           type: number
 *           format: decimal
 *         discount:
 *           type: number
 *           format: decimal
 *         total:
 *           type: number
 *           format: decimal
 *         status:
 *           type: string
 *           enum: [draft, open, paid, void, uncollectible]
 *         dueDate:
 *           type: string
 *           format: date-time
 *           nullable: true
 *         paidAt:
 *           type: string
 *           format: date-time
 *           nullable: true
 *         paymentMethod:
 *           type: string
 *           enum: [card, bank_transfer, paypal, crypto]
 *           nullable: true
 *         isPaid:
 *           type: boolean
 *         isOverdue:
 *           type: boolean
 *         daysUntilDue:
 *           type: integer
 *           nullable: true
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 *     
 *     UsageStats:
 *       type: object
 *       properties:
 *         filesUploaded:
 *           type: integer
 *         storageUsed:
 *           type: number
 *         apiRequests:
 *           type: integer
 *         teamMembers:
 *           type: integer
 *         limits:
 *           type: object
 *           properties:
 *             maxFiles:
 *               type: integer
 *             maxStorage:
 *               type: integer
 *             maxApiRequests:
 *               type: integer
 *             maxTeamMembers:
 *               type: integer
 *         usagePercentages:
 *           type: object
 *           properties:
 *             files:
 *               type: number
 *             storage:
 *               type: number
 *             apiRequests:
 *               type: number
 *             teamMembers:
 *               type: number
 */

/**
 * @swagger
 * /api/v1/billing/plans:
 *   get:
 *     summary: Get subscription plans
 *     description: Retrieve all available subscription plans
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Subscription plans retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         plans:
 *                           type: array
 *                           items:
 *                             $ref: '#/components/schemas/SubscriptionPlan'
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/plans', billingController.getPlans);

/**
 * @swagger
 * /api/v1/billing/subscribe:
 *   post:
 *     summary: Subscribe to a plan
 *     description: Create a new subscription for the authenticated user
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - planId
 *             properties:
 *               planId:
 *                 type: string
 *                 format: uuid
 *                 description: ID of the subscription plan
 *               paymentMethodId:
 *                 type: string
 *                 description: Payment method ID (for Stripe integration)
 *               trialDays:
 *                 type: integer
 *                 minimum: 0
 *                 maximum: 30
 *                 description: Number of trial days
 *     responses:
 *       201:
 *         description: Subscription created successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         subscription:
 *                           $ref: '#/components/schemas/Subscription'
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.post('/subscribe',
  validateRequest({
    body: Joi.object({
      planId: Joi.string().uuid().required(),
      paymentMethodId: Joi.string().optional(),
      trialDays: Joi.number().integer().min(0).max(30).optional(),
    }),
  }),
  billingController.subscribe
);

/**
 * @swagger
 * /api/v1/billing/subscription:
 *   put:
 *     summary: Update subscription
 *     description: Update the user's current subscription plan
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - planId
 *             properties:
 *               planId:
 *                 type: string
 *                 format: uuid
 *                 description: ID of the new subscription plan
 *               prorate:
 *                 type: boolean
 *                 default: true
 *                 description: Whether to prorate the billing
 *     responses:
 *       200:
 *         description: Subscription updated successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         subscription:
 *                           $ref: '#/components/schemas/Subscription'
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: No active subscription found
 *       500:
 *         description: Internal server error
 */
router.put('/subscription',
  validateRequest({
    body: Joi.object({
      planId: Joi.string().uuid().required(),
      prorate: Joi.boolean().optional(),
    }),
  }),
  billingController.updateSubscription
);

/**
 * @swagger
 * /api/v1/billing/subscription:
 *   delete:
 *     summary: Cancel subscription
 *     description: Cancel the user's current subscription
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               immediately:
 *                 type: boolean
 *                 default: false
 *                 description: Whether to cancel immediately or at the end of the billing period
 *     responses:
 *       200:
 *         description: Subscription cancelled successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiResponse'
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: No active subscription found
 *       500:
 *         description: Internal server error
 */
router.delete('/subscription',
  validateRequest({
    body: Joi.object({
      immediately: Joi.boolean().optional(),
    }),
  }),
  billingController.cancelSubscription
);

/**
 * @swagger
 * /api/v1/billing/subscription:
 *   get:
 *     summary: Get current subscription
 *     description: Retrieve the user's current subscription details
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Subscription retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         subscription:
 *                           $ref: '#/components/schemas/Subscription'
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: No active subscription found
 *       500:
 *         description: Internal server error
 */
router.get('/subscription', billingController.getSubscription);

/**
 * @swagger
 * /api/v1/billing/invoices:
 *   get:
 *     summary: Get billing history
 *     description: Retrieve the user's billing history and invoices
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *         description: Page number
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 10
 *         description: Number of invoices per page
 *     responses:
 *       200:
 *         description: Billing history retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: array
 *                       items:
 *                         $ref: '#/components/schemas/Invoice'
 *                     pagination:
 *                       $ref: '#/components/schemas/Pagination'
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/invoices', billingController.getInvoices);

/**
 * @swagger
 * /api/v1/billing/invoices/{invoiceId}:
 *   get:
 *     summary: Get specific invoice
 *     description: Retrieve details of a specific invoice
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: invoiceId
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Invoice ID
 *     responses:
 *       200:
 *         description: Invoice retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         invoice:
 *                           $ref: '#/components/schemas/Invoice'
 *       401:
 *         description: Unauthorized
 *       404:
 *         description: Invoice not found
 *       500:
 *         description: Internal server error
 */
router.get('/invoices/:invoiceId', billingController.getInvoice);

/**
 * @swagger
 * /api/v1/billing/usage:
 *   get:
 *     summary: Get usage statistics
 *     description: Retrieve current usage statistics for the user's subscription
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: period
 *         schema:
 *           type: string
 *           enum: [current, last_month, last_year]
 *           default: current
 *         description: Usage period
 *     responses:
 *       200:
 *         description: Usage statistics retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       $ref: '#/components/schemas/UsageStats'
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/usage', billingController.getUsage);

/**
 * @swagger
 * /api/v1/billing/limits:
 *   get:
 *     summary: Get usage limits
 *     description: Retrieve usage limits for the user's current subscription
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Usage limits retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         maxFiles:
 *                           type: integer
 *                         maxStorage:
 *                           type: integer
 *                         maxApiRequests:
 *                           type: integer
 *                         maxTeamMembers:
 *                           type: integer
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/limits', billingController.getLimits);

/**
 * @swagger
 * /api/v1/billing/payment-methods:
 *   post:
 *     summary: Create payment method
 *     description: Add a new payment method for the user
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - paymentMethodId
 *             properties:
 *               paymentMethodId:
 *                 type: string
 *                 description: Payment method ID from payment processor
 *     responses:
 *       200:
 *         description: Payment method created successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         paymentMethod:
 *                           type: object
 *                           properties:
 *                             id:
 *                               type: string
 *                             type:
 *                               type: string
 *                             card:
 *                               type: object
 *                               properties:
 *                                 brand:
 *                                   type: string
 *                                 last4:
 *                                   type: string
 *                                 expMonth:
 *                                   type: integer
 *                                 expYear:
 *                                   type: integer
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.post('/payment-methods',
  validateRequest({
    body: Joi.object({
      paymentMethodId: Joi.string().required(),
    }),
  }),
  billingController.createPaymentMethod
);

/**
 * @swagger
 * /api/v1/billing/payment-methods:
 *   get:
 *     summary: Get payment methods
 *     description: Retrieve all payment methods for the user
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Payment methods retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         paymentMethods:
 *                           type: array
 *                           items:
 *                             type: object
 *                             properties:
 *                               id:
 *                                 type: string
 *                               type:
 *                                 type: string
 *                               card:
 *                                 type: object
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/payment-methods', billingController.getPaymentMethods);

/**
 * @swagger
 * /api/v1/billing/payment-methods/{paymentMethodId}:
 *   delete:
 *     summary: Delete payment method
 *     description: Remove a payment method for the user
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: paymentMethodId
 *         required: true
 *         schema:
 *           type: string
 *         description: Payment method ID
 *     responses:
 *       200:
 *         description: Payment method deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiResponse'
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.delete('/payment-methods/:paymentMethodId', billingController.deletePaymentMethod);

/**
 * @swagger
 * /api/v1/billing/webhooks:
 *   post:
 *     summary: Handle webhooks
 *     description: Handle webhooks from payment processors (e.g., Paddle)
 *     tags: [Billing]
 *     security: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             description: Webhook payload from payment processor
 *     responses:
 *       200:
 *         description: Webhook processed successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 received:
 *                   type: boolean
 *       400:
 *         description: Bad request
 *       500:
 *         description: Internal server error
 */
router.post('/webhooks', billingController.handleWebhook);

/**
 * @swagger
 * /api/v1/billing/checkout:
 *   post:
 *     summary: Create Paddle checkout
 *     description: Create a Paddle checkout session for purchasing products or subscriptions
 *     tags: [Billing]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - items
 *             properties:
 *               items:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     priceId:
 *                       type: string
 *                       description: Paddle price ID
 *                     quantity:
 *                       type: integer
 *                       minimum: 1
 *               customData:
 *                 type: object
 *                 description: Additional custom data
 *               returnUrl:
 *                 type: string
 *                 format: uri
 *                 description: URL to redirect after successful payment
 *     responses:
 *       200:
 *         description: Checkout created successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       properties:
 *                         checkoutUrl:
 *                           type: string
 *                           format: uri
 *       400:
 *         description: Bad request
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.post('/checkout',
  validateRequest({
    body: Joi.object({
      items: Joi.array().items(
        Joi.object({
          priceId: Joi.string().required(),
          quantity: Joi.number().integer().min(1).required(),
        })
      ).min(1).required(),
      customData: Joi.object().optional(),
      returnUrl: Joi.string().uri().optional(),
    }),
  }),
  billingController.createCheckout
);

/**
 * @swagger
 * /api/v1/billing/price-preview:
 *   post:
 *     summary: Get price preview
 *     description: Get a price preview with taxes and discounts for Paddle items
 *     tags: [Billing]
 *     security: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - items
 *             properties:
 *               items:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     priceId:
 *                       type: string
 *                       description: Paddle price ID
 *                     quantity:
 *                       type: integer
 *                       minimum: 1
 *               customerIpAddress:
 *                 type: string
 *                 format: ipv4
 *                 description: Customer IP address for tax calculation
 *     responses:
 *       200:
 *         description: Price preview retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       type: object
 *                       description: Price preview data from Paddle
 *       400:
 *         description: Bad request
 *       500:
 *         description: Internal server error
 */
router.post('/price-preview',
  validateRequest({
    body: Joi.object({
      items: Joi.array().items(
        Joi.object({
          priceId: Joi.string().required(),
          quantity: Joi.number().integer().min(1).required(),
        })
      ).min(1).required(),
      customerIpAddress: Joi.string().ip().optional(),
    }),
  }),
  billingController.getPricePreview
);

export default router;
