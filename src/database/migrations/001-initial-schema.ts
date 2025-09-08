import { MigrationInterface, QueryRunner } from 'typeorm';

export class InitialSchema1700000000000 implements MigrationInterface {
  name = 'InitialSchema1700000000000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create users table
    await queryRunner.query(`
      CREATE TABLE "users" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "email" character varying NOT NULL,
        "firstName" character varying NOT NULL,
        "lastName" character varying NOT NULL,
        "password" character varying NOT NULL,
        "role" character varying NOT NULL DEFAULT 'user',
        "isEmailVerified" boolean NOT NULL DEFAULT false,
        "emailVerificationToken" character varying,
        "passwordResetToken" character varying,
        "passwordResetExpires" TIMESTAMP,
        "lastLoginAt" TIMESTAMP,
        "isActive" boolean NOT NULL DEFAULT true,
        "avatar" character varying,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "UQ_users_email" UNIQUE ("email"),
        CONSTRAINT "PK_users_id" PRIMARY KEY ("id")
      )
    `);

    // Create files table
    await queryRunner.query(`
      CREATE TABLE "files" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "filename" character varying NOT NULL,
        "originalName" character varying NOT NULL,
        "mimetype" character varying NOT NULL,
        "size" integer NOT NULL,
        "url" character varying NOT NULL,
        "key" character varying NOT NULL,
        "type" character varying NOT NULL DEFAULT 'other',
        "description" character varying,
        "isPublic" boolean NOT NULL DEFAULT true,
        "isDeleted" boolean NOT NULL DEFAULT false,
        "deletedAt" TIMESTAMP,
        "metadata" jsonb,
        "userId" uuid NOT NULL,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_files_id" PRIMARY KEY ("id")
      )
    `);

    // Create indexes
    await queryRunner.query(`CREATE INDEX "IDX_users_email" ON "users" ("email")`);
    await queryRunner.query(`CREATE INDEX "IDX_users_role" ON "users" ("role")`);
    await queryRunner.query(`CREATE INDEX "IDX_users_isActive" ON "users" ("isActive")`);
    await queryRunner.query(`CREATE INDEX "IDX_files_userId" ON "files" ("userId")`);
    await queryRunner.query(`CREATE INDEX "IDX_files_type" ON "files" ("type")`);
    await queryRunner.query(`CREATE INDEX "IDX_files_isDeleted" ON "files" ("isDeleted")`);
    await queryRunner.query(`CREATE INDEX "IDX_files_createdAt" ON "files" ("createdAt")`);

    // Add foreign key constraint
    await queryRunner.query(`
      ALTER TABLE "files" 
      ADD CONSTRAINT "FK_files_userId" 
      FOREIGN KEY ("userId") 
      REFERENCES "users"("id") 
      ON DELETE CASCADE
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop foreign key constraint
    await queryRunner.query(`ALTER TABLE "files" DROP CONSTRAINT "FK_files_userId"`);

    // Drop indexes
    await queryRunner.query(`DROP INDEX "IDX_files_createdAt"`);
    await queryRunner.query(`DROP INDEX "IDX_files_isDeleted"`);
    await queryRunner.query(`DROP INDEX "IDX_files_type"`);
    await queryRunner.query(`DROP INDEX "IDX_files_userId"`);
    await queryRunner.query(`DROP INDEX "IDX_users_isActive"`);
    await queryRunner.query(`DROP INDEX "IDX_users_role"`);
    await queryRunner.query(`DROP INDEX "IDX_users_email"`);

    // Drop tables
    await queryRunner.query(`DROP TABLE "files"`);
    await queryRunner.query(`DROP TABLE "users"`);
  }
}
