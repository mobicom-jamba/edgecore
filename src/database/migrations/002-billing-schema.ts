import { MigrationInterface, QueryRunner } from 'typeorm';

export class BillingSchema1700000000001 implements MigrationInterface {
  name = 'BillingSchema1700000000001';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create subscription_plans table
    await queryRunner.query(`
      CREATE TABLE "subscription_plans" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "name" character varying NOT NULL,
        "slug" character varying NOT NULL,
        "description" text,
        "type" character varying NOT NULL,
        "price" decimal(10,2) NOT NULL,
        "billingCycle" character varying NOT NULL DEFAULT 'monthly',
        "features" jsonb NOT NULL DEFAULT '{}',
        "limits" jsonb,
        "isActive" boolean NOT NULL DEFAULT true,
        "isPopular" boolean NOT NULL DEFAULT false,
        "sortOrder" integer NOT NULL DEFAULT 0,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "UQ_subscription_plans_name" UNIQUE ("name"),
        CONSTRAINT "UQ_subscription_plans_slug" UNIQUE ("slug"),
        CONSTRAINT "PK_subscription_plans_id" PRIMARY KEY ("id")
      )
    `);

    // Create subscriptions table
    await queryRunner.query(`
      CREATE TABLE "subscriptions" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "userId" uuid NOT NULL,
        "planId" uuid NOT NULL,
        "status" character varying NOT NULL DEFAULT 'active',
        "currentPeriodStart" TIMESTAMP NOT NULL,
        "currentPeriodEnd" TIMESTAMP NOT NULL,
        "trialStart" TIMESTAMP,
        "trialEnd" TIMESTAMP,
        "cancelledAt" TIMESTAMP,
        "endedAt" TIMESTAMP,
        "stripeSubscriptionId" character varying,
        "stripeCustomerId" character varying,
        "metadata" jsonb,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_subscriptions_id" PRIMARY KEY ("id")
      )
    `);

    // Create invoices table
    await queryRunner.query(`
      CREATE TABLE "invoices" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "invoiceNumber" character varying NOT NULL,
        "userId" uuid NOT NULL,
        "subscriptionId" uuid,
        "subtotal" decimal(10,2) NOT NULL,
        "tax" decimal(10,2) NOT NULL DEFAULT 0,
        "discount" decimal(10,2) NOT NULL DEFAULT 0,
        "total" decimal(10,2) NOT NULL,
        "status" character varying NOT NULL DEFAULT 'draft',
        "dueDate" TIMESTAMP,
        "paidAt" TIMESTAMP,
        "paymentMethod" character varying,
        "stripeInvoiceId" character varying,
        "stripePaymentIntentId" character varying,
        "lineItems" jsonb,
        "metadata" jsonb,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "UQ_invoices_invoiceNumber" UNIQUE ("invoiceNumber"),
        CONSTRAINT "PK_invoices_id" PRIMARY KEY ("id")
      )
    `);

    // Create indexes
    await queryRunner.query(`CREATE INDEX "IDX_subscription_plans_type" ON "subscription_plans" ("type")`);
    await queryRunner.query(`CREATE INDEX "IDX_subscription_plans_isActive" ON "subscription_plans" ("isActive")`);
    await queryRunner.query(`CREATE INDEX "IDX_subscription_plans_sortOrder" ON "subscription_plans" ("sortOrder")`);
    
    await queryRunner.query(`CREATE INDEX "IDX_subscriptions_userId" ON "subscriptions" ("userId")`);
    await queryRunner.query(`CREATE INDEX "IDX_subscriptions_planId" ON "subscriptions" ("planId")`);
    await queryRunner.query(`CREATE INDEX "IDX_subscriptions_status" ON "subscriptions" ("status")`);
    await queryRunner.query(`CREATE INDEX "IDX_subscriptions_stripeSubscriptionId" ON "subscriptions" ("stripeSubscriptionId")`);
    
    await queryRunner.query(`CREATE INDEX "IDX_invoices_userId" ON "invoices" ("userId")`);
    await queryRunner.query(`CREATE INDEX "IDX_invoices_subscriptionId" ON "invoices" ("subscriptionId")`);
    await queryRunner.query(`CREATE INDEX "IDX_invoices_status" ON "invoices" ("status")`);
    await queryRunner.query(`CREATE INDEX "IDX_invoices_dueDate" ON "invoices" ("dueDate")`);

    // Add foreign key constraints
    await queryRunner.query(`
      ALTER TABLE "subscriptions" 
      ADD CONSTRAINT "FK_subscriptions_userId" 
      FOREIGN KEY ("userId") 
      REFERENCES "users"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "subscriptions" 
      ADD CONSTRAINT "FK_subscriptions_planId" 
      FOREIGN KEY ("planId") 
      REFERENCES "subscription_plans"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "invoices" 
      ADD CONSTRAINT "FK_invoices_userId" 
      FOREIGN KEY ("userId") 
      REFERENCES "users"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "invoices" 
      ADD CONSTRAINT "FK_invoices_subscriptionId" 
      FOREIGN KEY ("subscriptionId") 
      REFERENCES "subscriptions"("id") 
      ON DELETE SET NULL
    `);

    // Insert default subscription plans
    await queryRunner.query(`
      INSERT INTO "subscription_plans" ("id", "name", "slug", "description", "type", "price", "billingCycle", "features", "limits", "isActive", "isPopular", "sortOrder") VALUES
      ('550e8400-e29b-41d4-a716-446655440000', 'Free', 'free', 'Perfect for getting started', 'free', 0.00, 'monthly', '{"storage": "1GB", "files": "100", "support": "Community"}'::jsonb, '{"maxFiles": 100, "maxStorage": 1073741824, "maxApiRequests": 1000, "maxTeamMembers": 1}'::jsonb, true, false, 1),
      ('550e8400-e29b-41d4-a716-446655440001', 'Basic', 'basic', 'Great for small teams', 'basic', 9.99, 'monthly', '{"storage": "10GB", "files": "1000", "support": "Email"}'::jsonb, '{"maxFiles": 1000, "maxStorage": 10737418240, "maxApiRequests": 10000, "maxTeamMembers": 5}'::jsonb, true, true, 2),
      ('550e8400-e29b-41d4-a716-446655440002', 'Pro', 'pro', 'Perfect for growing businesses', 'pro', 29.99, 'monthly', '{"storage": "100GB", "files": "10000", "support": "Priority"}'::jsonb, '{"maxFiles": 10000, "maxStorage": 107374182400, "maxApiRequests": 100000, "maxTeamMembers": 25}'::jsonb, true, false, 3),
      ('550e8400-e29b-41d4-a716-446655440003', 'Enterprise', 'enterprise', 'For large organizations', 'enterprise', 99.99, 'monthly', '{"storage": "Unlimited", "files": "Unlimited", "support": "24/7 Phone"}'::jsonb, '{"maxFiles": -1, "maxStorage": -1, "maxApiRequests": -1, "maxTeamMembers": -1}'::jsonb, true, false, 4)
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop foreign key constraints
    await queryRunner.query(`ALTER TABLE "invoices" DROP CONSTRAINT "FK_invoices_subscriptionId"`);
    await queryRunner.query(`ALTER TABLE "invoices" DROP CONSTRAINT "FK_invoices_userId"`);
    await queryRunner.query(`ALTER TABLE "subscriptions" DROP CONSTRAINT "FK_subscriptions_planId"`);
    await queryRunner.query(`ALTER TABLE "subscriptions" DROP CONSTRAINT "FK_subscriptions_userId"`);

    // Drop indexes
    await queryRunner.query(`DROP INDEX "IDX_invoices_dueDate"`);
    await queryRunner.query(`DROP INDEX "IDX_invoices_status"`);
    await queryRunner.query(`DROP INDEX "IDX_invoices_subscriptionId"`);
    await queryRunner.query(`DROP INDEX "IDX_invoices_userId"`);
    await queryRunner.query(`DROP INDEX "IDX_subscriptions_stripeSubscriptionId"`);
    await queryRunner.query(`DROP INDEX "IDX_subscriptions_status"`);
    await queryRunner.query(`DROP INDEX "IDX_subscriptions_planId"`);
    await queryRunner.query(`DROP INDEX "IDX_subscriptions_userId"`);
    await queryRunner.query(`DROP INDEX "IDX_subscription_plans_sortOrder"`);
    await queryRunner.query(`DROP INDEX "IDX_subscription_plans_isActive"`);
    await queryRunner.query(`DROP INDEX "IDX_subscription_plans_type"`);

    // Drop tables
    await queryRunner.query(`DROP TABLE "invoices"`);
    await queryRunner.query(`DROP TABLE "subscriptions"`);
    await queryRunner.query(`DROP TABLE "subscription_plans"`);
  }
}
