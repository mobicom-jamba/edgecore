# 🎓 YouTube Learning Platform

A comprehensive educational technology platform that transforms YouTube videos into structured, interactive learning experiences using AI-powered content analysis and spaced repetition algorithms.

## 🌟 Features

### 🎥 Video Processing Pipeline
- **YouTube Integration**: Extract metadata, transcripts, and content from YouTube videos
- **AI-Powered Analysis**: Automatic content summarization, key topic extraction, and concept identification
- **Knowledge Structuring**: Organize information into digestible learning materials
- **Real-time Processing**: Monitor video processing progress with detailed status updates

### 🧠 Learning Optimization
- **Spaced Repetition**: SM-2 algorithm for optimal review scheduling
- **Multiple Card Types**: Flashcards, multiple choice, true/false, fill-in-blank questions
- **Adaptive Difficulty**: Dynamic difficulty adjustment based on performance
- **Progress Analytics**: Comprehensive learning statistics and insights

### 👥 User Management
- **Role-Based Access**: Admin, moderator, and user roles with granular permissions
- **Bulk Operations**: Import/export users, bulk role management
- **User Analytics**: Activity tracking, engagement metrics, learning patterns
- **Admin Dashboard**: System statistics, user management, analytics

### 💳 Billing & Subscriptions
- **Subscription Plans**: Free, Basic, Pro, Enterprise tiers
- **Usage Tracking**: Monitor file uploads, storage, API requests, team members
- **Payment Processing**: Paddle integration with invoice generation
- **Webhook Support**: Real-time payment status updates

## 🏗️ Architecture

### Backend (Node.js + TypeScript)
- **Framework**: Express.js with TypeScript
- **Database**: PostgreSQL with TypeORM
- **Authentication**: JWT-based with role-based access control
- **API Documentation**: Complete Swagger/OpenAPI documentation
- **Logging**: Winston-based logging with business analytics

### Frontend (Next.js + TypeScript)
- **Framework**: Next.js 14 with TypeScript
- **Styling**: Tailwind CSS with custom design system
- **State Management**: React Query for server state
- **Forms**: React Hook Form with validation
- **UI Components**: Custom component library with Lucide icons

### Database Schema
```
Users → Videos → Knowledge Extracts → Learning Cards
  ↓         ↓           ↓                ↓
Billing → Sessions → Analytics → Progress Tracking
```

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- PostgreSQL 13+
- Redis (optional, for caching)

### Backend Setup

1. **Clone and Install**
   ```bash
   git clone <repository-url>
   cd edgecore
   yarn install
   ```

2. **Environment Configuration**
   ```bash
   cp env.example .env
   # Edit .env with your configuration
   ```

3. **Database Setup**
   ```bash
   # Start PostgreSQL and create database
   createdb youtube_learning
   
   # Run migrations
   yarn migrate
   
   # Seed initial data
   yarn seed
   ```

4. **Start development server**
   ```bash
   npm run dev
   ```

### Frontend Setup (Skill Hub)

1. **Navigate to Frontend**
   ```bash
   cd skill-hub
   yarn install
   ```

2. **Start Development Server**
   ```bash
   yarn dev
   ```

3. **Access Application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3001
   - API Documentation: http://localhost:3001/api-docs

## 📚 API Endpoints

### Authentication
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/auth/profile` - Get user profile
- `POST /api/v1/auth/logout` - User logout

### Video Management
- `POST /api/v1/videos` - Submit YouTube video for processing
- `GET /api/v1/videos` - List user's videos with filtering
- `GET /api/v1/videos/:id` - Get video details and knowledge extracts
- `GET /api/v1/videos/:id/status` - Get processing status
- `DELETE /api/v1/videos/:id` - Delete video and associated data

### Learning System
- `GET /api/v1/videos/dashboard` - Learning dashboard with stats
- `GET /api/v1/videos/review/session` - Get cards for review
- `POST /api/v1/videos/review/submit` - Submit card review
- `POST /api/v1/videos/review/complete` - Complete review session

### Admin Features
- `GET /api/v1/admin/users` - List all users with filtering
- `PUT /api/v1/admin/users/:id` - Update user details
- `GET /api/v1/admin/stats` - System statistics
- `GET /api/v1/admin/analytics/users` - User analytics
- `POST /api/v1/admin/users/bulk` - Bulk user operations

### Billing System
- `GET /api/v1/billing/plans` - Get subscription plans
- `POST /api/v1/billing/subscribe` - Subscribe to plan
- `GET /api/v1/billing/usage` - Get usage statistics
- `GET /api/v1/billing/invoices` - Get billing history

## 🔧 Configuration

### Environment Variables
```env
# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=youtube_learning
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=password

# JWT
JWT_SECRET=your-jwt-secret
JWT_EXPIRES_IN=7d

# Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password

# AWS S3
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
AWS_S3_BUCKET=your-s3-bucket

# Paddle
PADDLE_API_KEY=your-paddle-api-key
PADDLE_ENVIRONMENT=sandbox
PADDLE_WEBHOOK_SECRET=your-paddle-webhook-secret
PADDLE_VENDOR_ID=your-paddle-vendor-id

# Email
EMAIL_SERVICE=sendgrid
SENDGRID_API_KEY=your-sendgrid-api-key
FROM_EMAIL=noreply@yourdomain.com
```

## 📚 API Documentation

Once the server is running, visit:
- **Swagger UI**: `http://localhost:3000/api-docs`
- **Health Check**: `http://localhost:3000/api/v1/health`

## 🏗️ Project Structure

```
src/
├── config/           # Configuration files
├── controllers/      # Request handlers
├── database/         # Migrations and seeds
├── middleware/       # Custom middleware
├── models/          # Database entities
├── routes/          # API routes
├── services/        # Business logic
├── types/           # TypeScript type definitions
├── utils/           # Utility functions
├── app.ts           # Express app configuration
└── index.ts         # Application entry point
```

## 🔐 Authentication

### Register
```bash
POST /api/v1/auth/register
{
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "password": "password123"
}
```

### Login
```bash
POST /api/v1/auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

### Protected Routes
Include the JWT token in the Authorization header:
```
Authorization: Bearer <your-jwt-token>
```

## 📁 File Management

### Upload File
```bash
POST /api/v1/files/upload
Content-Type: multipart/form-data

file: <file>
description: "File description"
isPublic: true
```

### Get Files
```bash
GET /api/v1/files?page=1&limit=10&search=document
```

## 🧪 Testing

```bash
# Run all tests
yarn test

# Run tests with coverage
yarn test:coverage

# Run tests in watch mode
yarn test:watch
```

## 📦 Deployment

### Docker Deployment
```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server
npm run test         # Run tests
npm run lint         # Run ESLint
npm run migrate      # Run database migrations
npm run seed         # Seed database
```

## 🔒 Security Features

- **Rate Limiting**: Configurable rate limits for different endpoints
- **Input Validation**: Joi-based request validation
- **SQL Injection Protection**: Parameterized queries and input sanitization
- **XSS Protection**: Input sanitization and content security policy
- **CORS**: Configurable cross-origin resource sharing
- **Helmet**: Security headers
- **File Upload Security**: File type and size validation

## 📊 Monitoring

- **Logging**: Structured logging with Winston
- **Performance Monitoring**: Request timing and performance metrics
- **Error Tracking**: Centralized error handling and logging
- **Health Checks**: Built-in health check endpoints

## 🚀 Deployment

### Docker (Recommended)
```bash
# Build image
docker build -t edgecore .

# Run container
docker run -p 3000:3000 --env-file .env edgecore
```

### Manual Deployment
```bash
# Build application
npm run build

# Start production server
npm start
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **TypeORM** for database management
- **React Query** for server state management
- **Tailwind CSS** for styling
- **Lucide React** for icons
- **Framer Motion** for animations

## 📞 Support

For support, email support@youtubelearning.com or join our Discord community.

---

**Built with ❤️ for the future of education**
