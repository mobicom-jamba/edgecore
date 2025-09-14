import { MigrationInterface, QueryRunner, TableColumn } from 'typeorm';

export class AddPaddleFields1700000000000 implements MigrationInterface {
  name = 'AddPaddleFields1700000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Add Paddle fields to users table
    await queryRunner.addColumn(
      'users',
      new TableColumn({
        name: 'paddleCustomerId',
        type: 'varchar',
        isNullable: true,
      })
    );

    // Add Paddle fields to subscriptions table
    await queryRunner.addColumn(
      'subscriptions',
      new TableColumn({
        name: 'paddleSubscriptionId',
        type: 'varchar',
        isNullable: true,
      })
    );

    await queryRunner.addColumn(
      'subscriptions',
      new TableColumn({
        name: 'paddleCustomerId',
        type: 'varchar',
        isNullable: true,
      })
    );

    // Add Paddle fields to subscription_plans table
    await queryRunner.addColumn(
      'subscription_plans',
      new TableColumn({
        name: 'paddleProductId',
        type: 'varchar',
        isNullable: true,
      })
    );

    await queryRunner.addColumn(
      'subscription_plans',
      new TableColumn({
        name: 'paddlePriceId',
        type: 'varchar',
        isNullable: true,
      })
    );

    // Add Paddle fields to invoices table
    await queryRunner.addColumn(
      'invoices',
      new TableColumn({
        name: 'paddleTransactionId',
        type: 'varchar',
        isNullable: true,
      })
    );

    await queryRunner.addColumn(
      'invoices',
      new TableColumn({
        name: 'paddleInvoiceId',
        type: 'varchar',
        isNullable: true,
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Remove Paddle fields from invoices table
    await queryRunner.dropColumn('invoices', 'paddleInvoiceId');
    await queryRunner.dropColumn('invoices', 'paddleTransactionId');

    // Remove Paddle fields from subscription_plans table
    await queryRunner.dropColumn('subscription_plans', 'paddlePriceId');
    await queryRunner.dropColumn('subscription_plans', 'paddleProductId');

    // Remove Paddle fields from subscriptions table
    await queryRunner.dropColumn('subscriptions', 'paddleCustomerId');
    await queryRunner.dropColumn('subscriptions', 'paddleSubscriptionId');

    // Remove Paddle fields from users table
    await queryRunner.dropColumn('users', 'paddleCustomerId');
  }
}
