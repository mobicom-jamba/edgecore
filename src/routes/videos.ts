import { Router } from 'express';
import { VideoController } from '../controllers/VideoController';
import { AuthMiddleware } from '../middleware/auth';
import { validateRequest } from '../middleware/validation';
import { ReviewQuality } from '../types';
import Joi from 'joi';

const router = Router();
const videoController = new VideoController();
const authMiddleware = new AuthMiddleware();

// Apply authentication to all routes
router.use(authMiddleware.authenticate);

/**
 * @swagger
 * components:
 *   schemas:
 *     Video:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           format: uuid
 *         userId:
 *           type: string
 *           format: uuid
 *         youtubeUrl:
 *           type: string
 *           format: uri
 *         youtubeVideoId:
 *           type: string
 *         title:
 *           type: string
 *         description:
 *           type: string
 *         duration:
 *           type: integer
 *         durationFormatted:
 *           type: string
 *         thumbnailUrl:
 *           type: string
 *           format: uri
 *         channelName:
 *           type: string
 *         status:
 *           type: string
 *           enum: [pending, processing, completed, failed]
 *         processingStage:
 *           type: string
 *           enum: [extracting_transcript, analyzing_content, extracting_knowledge, structuring_content, completed]
 *         summary:
 *           type: string
 *         keyTopics:
 *           type: array
 *           items:
 *             type: string
 *         learningObjectives:
 *           type: array
 *           items:
 *             type: string
 *         metadata:
 *           type: object
 *         isProcessed:
 *           type: boolean
 *         isProcessing:
 *           type: boolean
 *         hasTranscript:
 *           type: boolean
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 *     
 *     KnowledgeExtract:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           format: uuid
 *         title:
 *           type: string
 *         content:
 *           type: string
 *         type:
 *           type: string
 *           enum: [concept, definition, insight, example, step, principle, fact, quote]
 *         difficultyLevel:
 *           type: string
 *           enum: [beginner, intermediate, advanced]
 *         status:
 *           type: string
 *           enum: [active, archived, reviewed]
 *         tags:
 *           type: array
 *           items:
 *             type: string
 *         startTime:
 *           type: integer
 *         endTime:
 *           type: integer
 *         timeRange:
 *           type: string
 *         confidenceScore:
 *           type: number
 *         confidencePercentage:
 *           type: integer
 *         reviewCount:
 *           type: integer
 *         isDueForReview:
 *           type: boolean
 *         createdAt:
 *           type: string
 *           format: date-time
 *     
 *     LearningCard:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *           format: uuid
 *         question:
 *           type: string
 *         answer:
 *           type: string
 *         type:
 *           type: string
 *           enum: [flashcard, quiz, fill_blank, multiple_choice, true_false, matching]
 *         difficulty:
 *           type: string
 *           enum: [easy, medium, hard]
 *         options:
 *           type: array
 *           items:
 *             type: string
 *         hints:
 *           type: array
 *           items:
 *             type: string
 *         explanation:
 *           type: string
 *         reviewCount:
 *           type: integer
 *         successRate:
 *           type: number
 *         accuracy:
 *           type: integer
 *         masteryLevel:
 *           type: string
 *         isDueForReview:
 *           type: boolean
 *         nextReviewInDays:
 *           type: integer
 *         createdAt:
 *           type: string
 *           format: date-time
 *     
 *     LearningStats:
 *       type: object
 *       properties:
 *         totalVideos:
 *           type: integer
 *         totalExtracts:
 *           type: integer
 *         totalCards:
 *           type: integer
 *         cardsReviewed:
 *           type: integer
 *         cardsMastered:
 *           type: integer
 *         averageAccuracy:
 *           type: integer
 *         studyStreak:
 *           type: integer
 *         timeSpent:
 *           type: integer
 *         progressBySubject:
 *           type: object
 *           additionalProperties:
 *             type: integer
 *     
 *     ReviewSession:
 *       type: object
 *       properties:
 *         sessionId:
 *           type: string
 *           format: uuid
 *         totalCards:
 *           type: integer
 *         cards:
 *           type: array
 *           items:
 *             type: object
 *             properties:
 *               id:
 *                 type: string
 *                 format: uuid
 *               question:
 *                 type: string
 *               answer:
 *                 type: string
 *               type:
 *                 type: string
 *               difficulty:
 *                 type: string
 *               hints:
 *                 type: array
 *                 items:
 *                   type: string
 *               explanation:
 *                 type: string
 *               lastReviewed:
 *                 type: string
 *                 format: date-time
 *               reviewCount:
 *                 type: integer
 *               successRate:
 *                 type: number
 */

/**
 * @swagger
 * /api/v1/videos:
 *   post:
 *     summary: Submit YouTube video for processing
 *     description: Submit a YouTube video URL for knowledge extraction and learning card generation
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - youtubeUrl
 *             properties:
 *               youtubeUrl:
 *                 type: string
 *                 format: uri
 *                 description: YouTube video URL
 *                 example: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
 *               learningObjectives:
 *                 type: array
 *                 items:
 *                   type: string
 *                 description: Optional learning objectives for the video
 *                 example: ["Understand machine learning basics", "Learn about neural networks"]
 *     responses:
 *       201:
 *         description: Video submitted for processing successfully
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
 *                         video:
 *                           $ref: '#/components/schemas/Video'
 *       400:
 *         description: Bad request - Invalid YouTube URL
 *       409:
 *         description: Conflict - Video already exists
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.post('/',
  validateRequest({
    body: Joi.object({
      youtubeUrl: Joi.string().uri().required(),
      learningObjectives: Joi.array().items(Joi.string()).optional(),
    }),
  }),
  videoController.submitVideo
);

/**
 * @swagger
 * /api/v1/videos:
 *   get:
 *     summary: Get user's videos
 *     description: Retrieve a paginated list of user's videos with filtering and search
 *     tags: [Videos]
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
 *         description: Number of videos per page
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search term for title, description, or channel name
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *           enum: [pending, processing, completed, failed]
 *         description: Filter by processing status
 *       - in: query
 *         name: sortBy
 *         schema:
 *           type: string
 *           enum: [createdAt, updatedAt, title, duration]
 *           default: createdAt
 *         description: Field to sort by
 *       - in: query
 *         name: sortOrder
 *         schema:
 *           type: string
 *           enum: [ASC, DESC]
 *           default: DESC
 *         description: Sort order
 *     responses:
 *       200:
 *         description: Videos retrieved successfully
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
 *                         $ref: '#/components/schemas/Video'
 *                     pagination:
 *                       $ref: '#/components/schemas/Pagination'
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/', videoController.getVideos);

/**
 * @swagger
 * /api/v1/videos/{id}:
 *   get:
 *     summary: Get video details
 *     description: Retrieve detailed information about a specific video including knowledge extracts and learning sessions
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Video ID
 *     responses:
 *       200:
 *         description: Video details retrieved successfully
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
 *                         video:
 *                           allOf:
 *                             - $ref: '#/components/schemas/Video'
 *                             - type: object
 *                               properties:
 *                                 knowledgeExtracts:
 *                                   type: array
 *                                   items:
 *                                     $ref: '#/components/schemas/KnowledgeExtract'
 *                                 learningSessions:
 *                                   type: array
 *                                   items:
 *                                     type: object
 *       404:
 *         description: Video not found
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/:id', videoController.getVideo);

/**
 * @swagger
 * /api/v1/videos/{id}/status:
 *   get:
 *     summary: Get video processing status
 *     description: Get the current processing status and progress of a video
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Video ID
 *     responses:
 *       200:
 *         description: Video status retrieved successfully
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
 *                         status:
 *                           type: string
 *                           enum: [pending, processing, completed, failed]
 *                         stage:
 *                           type: string
 *                           enum: [extracting_transcript, analyzing_content, extracting_knowledge, structuring_content, completed]
 *                         progress:
 *                           type: integer
 *                           minimum: 0
 *                           maximum: 100
 *                         log:
 *                           type: array
 *                           items:
 *                             type: object
 *       404:
 *         description: Video not found
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/:id/status', videoController.getVideoStatus);

/**
 * @swagger
 * /api/v1/videos/{id}:
 *   delete:
 *     summary: Delete video
 *     description: Delete a video and all associated knowledge extracts and learning cards
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *         description: Video ID
 *     responses:
 *       200:
 *         description: Video deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ApiResponse'
 *       404:
 *         description: Video not found
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.delete('/:id', videoController.deleteVideo);

/**
 * @swagger
 * /api/v1/videos/dashboard:
 *   get:
 *     summary: Get learning dashboard
 *     description: Get comprehensive learning statistics and progress data
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Learning dashboard retrieved successfully
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
 *                         stats:
 *                           $ref: '#/components/schemas/LearningStats'
 *                         learningPath:
 *                           type: object
 *                           properties:
 *                             videos:
 *                               type: array
 *                               items:
 *                                 type: object
 *                                 properties:
 *                                   id:
 *                                     type: string
 *                                   title:
 *                                     type: string
 *                                   thumbnailUrl:
 *                                     type: string
 *                                   duration:
 *                                     type: integer
 *                                   progress:
 *                                     type: number
 *                                   conceptsLearned:
 *                                     type: integer
 *                                   totalConcepts:
 *                                     type: integer
 *                             recommendations:
 *                               type: array
 *                               items:
 *                                 type: object
 *                                 properties:
 *                                   id:
 *                                     type: string
 *                                   title:
 *                                     type: string
 *                                   reason:
 *                                     type: string
 *                                   difficulty:
 *                                     type: string
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/dashboard', videoController.getLearningDashboard);

/**
 * @swagger
 * /api/v1/videos/review/session:
 *   get:
 *     summary: Get review session
 *     description: Get cards for a spaced repetition review session
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 50
 *           default: 20
 *         description: Maximum number of cards in the session
 *     responses:
 *       200:
 *         description: Review session created successfully
 *         content:
 *           application/json:
 *             schema:
 *               allOf:
 *                 - $ref: '#/components/schemas/ApiResponse'
 *                 - type: object
 *                   properties:
 *                     data:
 *                       $ref: '#/components/schemas/ReviewSession'
 *       401:
 *         description: Unauthorized
 *       500:
 *         description: Internal server error
 */
router.get('/review/session', videoController.getReviewSession);

/**
 * @swagger
 * /api/v1/videos/review/submit:
 *   post:
 *     summary: Submit card review
 *     description: Submit a card review with quality rating for spaced repetition algorithm
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - sessionId
 *               - cardId
 *               - quality
 *               - responseTime
 *             properties:
 *               sessionId:
 *                 type: string
 *                 format: uuid
 *                 description: Review session ID
 *               cardId:
 *                 type: string
 *                 format: uuid
 *                 description: Learning card ID
 *               quality:
 *                 type: string
 *                 enum: [again, hard, good, easy]
 *                 description: Review quality rating
 *               responseTime:
 *                 type: integer
 *                 minimum: 0
 *                 description: Response time in milliseconds
 *     responses:
 *       200:
 *         description: Card review submitted successfully
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
router.post('/review/submit',
  validateRequest({
    body: Joi.object({
      sessionId: Joi.string().uuid().required(),
      cardId: Joi.string().uuid().required(),
      quality: Joi.string().valid('again', 'hard', 'good', 'easy').required(),
      responseTime: Joi.number().integer().min(0).required(),
    }),
  }),
  videoController.submitCardReview
);

/**
 * @swagger
 * /api/v1/videos/review/complete:
 *   post:
 *     summary: Complete review session
 *     description: Mark a review session as completed and calculate analytics
 *     tags: [Videos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - sessionId
 *             properties:
 *               sessionId:
 *                 type: string
 *                 format: uuid
 *                 description: Review session ID
 *     responses:
 *       200:
 *         description: Review session completed successfully
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
router.post('/review/complete',
  validateRequest({
    body: Joi.object({
      sessionId: Joi.string().uuid().required(),
    }),
  }),
  videoController.completeReviewSession
);

export default router;
