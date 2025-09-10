import { MigrationInterface, QueryRunner } from 'typeorm';

export class VideoLearningSchema1700000000002 implements MigrationInterface {
  name = 'VideoLearningSchema1700000000002';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create videos table
    await queryRunner.query(`
      CREATE TABLE "videos" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "userId" uuid NOT NULL,
        "youtubeUrl" character varying NOT NULL,
        "youtubeVideoId" character varying NOT NULL,
        "title" character varying NOT NULL,
        "description" text,
        "duration" integer,
        "thumbnailUrl" character varying,
        "channelName" character varying,
        "status" character varying NOT NULL DEFAULT 'pending',
        "processingStage" character varying NOT NULL DEFAULT 'extracting_transcript',
        "transcript" text,
        "transcriptSegments" jsonb,
        "summary" text,
        "keyTopics" jsonb,
        "learningObjectives" jsonb,
        "metadata" jsonb,
        "processingLog" jsonb,
        "errorMessage" character varying,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "UQ_videos_youtubeVideoId" UNIQUE ("youtubeVideoId"),
        CONSTRAINT "PK_videos_id" PRIMARY KEY ("id")
      )
    `);

    // Create knowledge_extracts table
    await queryRunner.query(`
      CREATE TABLE "knowledge_extracts" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "userId" uuid NOT NULL,
        "videoId" uuid NOT NULL,
        "title" character varying NOT NULL,
        "content" text NOT NULL,
        "type" character varying NOT NULL,
        "difficultyLevel" character varying NOT NULL DEFAULT 'intermediate',
        "status" character varying NOT NULL DEFAULT 'active',
        "tags" jsonb,
        "relatedConcepts" jsonb,
        "startTime" integer NOT NULL DEFAULT 0,
        "endTime" integer NOT NULL DEFAULT 0,
        "confidenceScore" decimal(3,2) NOT NULL DEFAULT 0,
        "sourceContext" jsonb,
        "metadata" jsonb,
        "reviewCount" integer NOT NULL DEFAULT 0,
        "lastReviewedAt" TIMESTAMP,
        "nextReviewAt" TIMESTAMP,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_knowledge_extracts_id" PRIMARY KEY ("id")
      )
    `);

    // Create learning_cards table
    await queryRunner.query(`
      CREATE TABLE "learning_cards" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "userId" uuid NOT NULL,
        "knowledgeExtractId" uuid NOT NULL,
        "question" character varying NOT NULL,
        "answer" text NOT NULL,
        "type" character varying NOT NULL DEFAULT 'flashcard',
        "difficulty" character varying NOT NULL DEFAULT 'medium',
        "options" jsonb,
        "hints" jsonb,
        "explanation" text,
        "tags" jsonb,
        "reviewCount" integer NOT NULL DEFAULT 0,
        "correctCount" integer NOT NULL DEFAULT 0,
        "incorrectCount" integer NOT NULL DEFAULT 0,
        "successRate" decimal(5,2) NOT NULL DEFAULT 0,
        "currentInterval" integer NOT NULL DEFAULT 0,
        "easeFactor" integer NOT NULL DEFAULT 0,
        "lastReviewedAt" TIMESTAMP,
        "nextReviewAt" TIMESTAMP,
        "isActive" boolean NOT NULL DEFAULT true,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_learning_cards_id" PRIMARY KEY ("id")
      )
    `);

    // Create learning_sessions table
    await queryRunner.query(`
      CREATE TABLE "learning_sessions" (
        "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
        "userId" uuid NOT NULL,
        "videoId" uuid,
        "knowledgeExtractId" uuid,
        "learningCardId" uuid,
        "type" character varying NOT NULL,
        "status" character varying NOT NULL DEFAULT 'active',
        "startedAt" TIMESTAMP,
        "completedAt" TIMESTAMP,
        "duration" integer NOT NULL DEFAULT 0,
        "cardsReviewed" integer NOT NULL DEFAULT 0,
        "correctAnswers" integer NOT NULL DEFAULT 0,
        "incorrectAnswers" integer NOT NULL DEFAULT 0,
        "accuracy" decimal(5,2) NOT NULL DEFAULT 0,
        "reviewResults" jsonb,
        "sessionData" jsonb,
        "analytics" jsonb,
        "createdAt" TIMESTAMP NOT NULL DEFAULT now(),
        "updatedAt" TIMESTAMP NOT NULL DEFAULT now(),
        CONSTRAINT "PK_learning_sessions_id" PRIMARY KEY ("id")
      )
    `);

    // Create indexes for videos table
    await queryRunner.query(`CREATE INDEX "IDX_videos_userId" ON "videos" ("userId")`);
    await queryRunner.query(`CREATE INDEX "IDX_videos_youtubeVideoId" ON "videos" ("youtubeVideoId")`);
    await queryRunner.query(`CREATE INDEX "IDX_videos_status" ON "videos" ("status")`);
    await queryRunner.query(`CREATE INDEX "IDX_videos_processingStage" ON "videos" ("processingStage")`);
    await queryRunner.query(`CREATE INDEX "IDX_videos_createdAt" ON "videos" ("createdAt")`);

    // Create indexes for knowledge_extracts table
    await queryRunner.query(`CREATE INDEX "IDX_knowledge_extracts_userId" ON "knowledge_extracts" ("userId")`);
    await queryRunner.query(`CREATE INDEX "IDX_knowledge_extracts_videoId" ON "knowledge_extracts" ("videoId")`);
    await queryRunner.query(`CREATE INDEX "IDX_knowledge_extracts_type" ON "knowledge_extracts" ("type")`);
    await queryRunner.query(`CREATE INDEX "IDX_knowledge_extracts_status" ON "knowledge_extracts" ("status")`);
    await queryRunner.query(`CREATE INDEX "IDX_knowledge_extracts_nextReviewAt" ON "knowledge_extracts" ("nextReviewAt")`);

    // Create indexes for learning_cards table
    await queryRunner.query(`CREATE INDEX "IDX_learning_cards_userId" ON "learning_cards" ("userId")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_cards_knowledgeExtractId" ON "learning_cards" ("knowledgeExtractId")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_cards_type" ON "learning_cards" ("type")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_cards_difficulty" ON "learning_cards" ("difficulty")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_cards_isActive" ON "learning_cards" ("isActive")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_cards_nextReviewAt" ON "learning_cards" ("nextReviewAt")`);

    // Create indexes for learning_sessions table
    await queryRunner.query(`CREATE INDEX "IDX_learning_sessions_userId" ON "learning_sessions" ("userId")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_sessions_videoId" ON "learning_sessions" ("videoId")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_sessions_knowledgeExtractId" ON "learning_sessions" ("knowledgeExtractId")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_sessions_learningCardId" ON "learning_sessions" ("learningCardId")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_sessions_type" ON "learning_sessions" ("type")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_sessions_status" ON "learning_sessions" ("status")`);
    await queryRunner.query(`CREATE INDEX "IDX_learning_sessions_startedAt" ON "learning_sessions" ("startedAt")`);

    // Add foreign key constraints
    await queryRunner.query(`
      ALTER TABLE "videos" 
      ADD CONSTRAINT "FK_videos_userId" 
      FOREIGN KEY ("userId") 
      REFERENCES "users"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "knowledge_extracts" 
      ADD CONSTRAINT "FK_knowledge_extracts_userId" 
      FOREIGN KEY ("userId") 
      REFERENCES "users"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "knowledge_extracts" 
      ADD CONSTRAINT "FK_knowledge_extracts_videoId" 
      FOREIGN KEY ("videoId") 
      REFERENCES "videos"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "learning_cards" 
      ADD CONSTRAINT "FK_learning_cards_userId" 
      FOREIGN KEY ("userId") 
      REFERENCES "users"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "learning_cards" 
      ADD CONSTRAINT "FK_learning_cards_knowledgeExtractId" 
      FOREIGN KEY ("knowledgeExtractId") 
      REFERENCES "knowledge_extracts"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "learning_sessions" 
      ADD CONSTRAINT "FK_learning_sessions_userId" 
      FOREIGN KEY ("userId") 
      REFERENCES "users"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "learning_sessions" 
      ADD CONSTRAINT "FK_learning_sessions_videoId" 
      FOREIGN KEY ("videoId") 
      REFERENCES "videos"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "learning_sessions" 
      ADD CONSTRAINT "FK_learning_sessions_knowledgeExtractId" 
      FOREIGN KEY ("knowledgeExtractId") 
      REFERENCES "knowledge_extracts"("id") 
      ON DELETE CASCADE
    `);

    await queryRunner.query(`
      ALTER TABLE "learning_sessions" 
      ADD CONSTRAINT "FK_learning_sessions_learningCardId" 
      FOREIGN KEY ("learningCardId") 
      REFERENCES "learning_cards"("id") 
      ON DELETE CASCADE
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    // Drop foreign key constraints
    await queryRunner.query(`ALTER TABLE "learning_sessions" DROP CONSTRAINT "FK_learning_sessions_learningCardId"`);
    await queryRunner.query(`ALTER TABLE "learning_sessions" DROP CONSTRAINT "FK_learning_sessions_knowledgeExtractId"`);
    await queryRunner.query(`ALTER TABLE "learning_sessions" DROP CONSTRAINT "FK_learning_sessions_videoId"`);
    await queryRunner.query(`ALTER TABLE "learning_sessions" DROP CONSTRAINT "FK_learning_sessions_userId"`);
    await queryRunner.query(`ALTER TABLE "learning_cards" DROP CONSTRAINT "FK_learning_cards_knowledgeExtractId"`);
    await queryRunner.query(`ALTER TABLE "learning_cards" DROP CONSTRAINT "FK_learning_cards_userId"`);
    await queryRunner.query(`ALTER TABLE "knowledge_extracts" DROP CONSTRAINT "FK_knowledge_extracts_videoId"`);
    await queryRunner.query(`ALTER TABLE "knowledge_extracts" DROP CONSTRAINT "FK_knowledge_extracts_userId"`);
    await queryRunner.query(`ALTER TABLE "videos" DROP CONSTRAINT "FK_videos_userId"`);

    // Drop indexes
    await queryRunner.query(`DROP INDEX "IDX_learning_sessions_startedAt"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_sessions_status"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_sessions_type"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_sessions_learningCardId"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_sessions_knowledgeExtractId"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_sessions_videoId"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_sessions_userId"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_cards_nextReviewAt"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_cards_isActive"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_cards_difficulty"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_cards_type"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_cards_knowledgeExtractId"`);
    await queryRunner.query(`DROP INDEX "IDX_learning_cards_userId"`);
    await queryRunner.query(`DROP INDEX "IDX_knowledge_extracts_nextReviewAt"`);
    await queryRunner.query(`DROP INDEX "IDX_knowledge_extracts_status"`);
    await queryRunner.query(`DROP INDEX "IDX_knowledge_extracts_type"`);
    await queryRunner.query(`DROP INDEX "IDX_knowledge_extracts_videoId"`);
    await queryRunner.query(`DROP INDEX "IDX_knowledge_extracts_userId"`);
    await queryRunner.query(`DROP INDEX "IDX_videos_createdAt"`);
    await queryRunner.query(`DROP INDEX "IDX_videos_processingStage"`);
    await queryRunner.query(`DROP INDEX "IDX_videos_status"`);
    await queryRunner.query(`DROP INDEX "IDX_videos_youtubeVideoId"`);
    await queryRunner.query(`DROP INDEX "IDX_videos_userId"`);

    // Drop tables
    await queryRunner.query(`DROP TABLE "learning_sessions"`);
    await queryRunner.query(`DROP TABLE "learning_cards"`);
    await queryRunner.query(`DROP TABLE "knowledge_extracts"`);
    await queryRunner.query(`DROP TABLE "videos"`);
  }
}
