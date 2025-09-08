import 'reflect-metadata';
import app from './app';
import { config } from './config';
import { initializeDatabase } from './config/database';
import { logInfo, logError } from './utils/logger';

const startServer = async (): Promise<void> => {
  try {
    // Initialize database connection
    await initializeDatabase();

    // Start the server
    const server = app.listen(config.port, () => {
      logInfo(`🚀 Server running on port ${config.port}`);
      logInfo(`📊 Environment: ${config.nodeEnv}`);
      logInfo(`🔗 API Version: ${config.apiVersion}`);
      logInfo(`🌐 Health check: http://localhost:${config.port}/api/${config.apiVersion}/health`);
    });

    // Graceful shutdown
    const gracefulShutdown = (signal: string) => {
      logInfo(`📡 Received ${signal}. Starting graceful shutdown...`);
      
      server.close(() => {
        logInfo('✅ HTTP server closed');
        process.exit(0);
      });

      // Force close server after 10 seconds
      setTimeout(() => {
        logError(new Error('Could not close connections in time, forcefully shutting down'));
        process.exit(1);
      }, 10000);
    };

    // Listen for termination signals
    process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
    process.on('SIGINT', () => gracefulShutdown('SIGINT'));

  } catch (error) {
    logError(error as Error, 'Server startup');
    process.exit(1);
  }
};

// Start the server
startServer();
