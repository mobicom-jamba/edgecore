import express from 'express';
import cors from 'cors';
import compression from 'compression';
import morgan from 'morgan';
import { config } from './config';
import { corsOptions, helmetConfig, apiRateLimit, requestSizeLimit } from './middleware/security';
import { sanitizeInput, xssProtection, sqlInjectionProtection } from './middleware/security';
import { requestLogger, morganStream } from './utils/logger';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import routes from './routes';

const app = express();

// Trust proxy (for rate limiting and IP detection)
app.set('trust proxy', 1);

// Security middleware
app.use(helmetConfig);
app.use(cors(corsOptions));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Compression middleware
app.use(compression());

// Request size limiting
app.use(requestSizeLimit);

// Security middleware
app.use(sanitizeInput);
app.use(xssProtection);
app.use(sqlInjectionProtection);

// Logging middleware
app.use(morgan('combined', { stream: morganStream }));
app.use(requestLogger);

// Rate limiting
app.use(apiRateLimit);

// API routes
app.use(`/api/${config.apiVersion}`, routes);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'EdgeCore API Server',
    version: config.apiVersion,
    environment: config.nodeEnv,
    timestamp: new Date().toISOString(),
  });
});

// 404 handler
app.use(notFoundHandler);

// Global error handler
app.use(errorHandler);

export default app;
