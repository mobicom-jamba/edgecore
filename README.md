# EdgeCore

A professional, reusable backend framework with clean architecture built with TypeScript, Express, and PostgreSQL.

## 🚀 Features

### Core Features
- **Authentication & Authorization**: JWT-based auth with role-based access control
- **File Management**: Secure file upload with AWS S3 integration
- **Search & Filtering**: Advanced search with pagination and sorting
- **Database**: TypeORM with PostgreSQL and migrations
- **Monitoring & Logging**: Winston-based logging with performance monitoring
- **Email Service**: SendGrid/Mailgun integration with templates
- **Security**: Comprehensive security middleware and validation
- **API Documentation**: Swagger/OpenAPI documentation

### Architecture
- **Clean Architecture**: Separation of concerns with services, controllers, and middleware
- **Type Safety**: Full TypeScript support with strict type checking
- **Error Handling**: Centralized error handling with custom error classes
- **Validation**: Joi-based request validation
- **Security**: Rate limiting, CORS, helmet, input sanitization
- **Logging**: Structured logging with different levels
- **Testing**: Jest setup for unit and integration tests

## 📋 Prerequisites

- Node.js 18+ 
- PostgreSQL 12+
- Redis (optional, for caching)
- AWS S3 account (for file storage)

## 🛠️ Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd edgecore
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Environment setup**
   ```bash
   cp env.example .env
   # Edit .env with your configuration
   ```

4. **Database setup**
   ```bash
   # Create PostgreSQL database
   createdb edgecore_db
   
   # Run migrations
   npm run migrate
   
   # Seed database (optional)
   npm run seed
   ```

5. **Start development server**
   ```bash
   npm run dev
   ```

## 🔧 Configuration

### Environment Variables

Copy `env.example` to `.env` and configure:

```env
# Server
NODE_ENV=development
PORT=3000
API_VERSION=v1

# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=password
DB_NAME=edgecore_db

# JWT
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=24h

# AWS S3
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_REGION=us-east-1
AWS_S3_BUCKET=your-s3-bucket

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
# Run tests
npm test

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode
npm run test:watch
```

## 📦 Scripts

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
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Contact: support@edgecore.com

## 🔄 Version History

- **v1.0.0** - Initial release with core features
  - Authentication & Authorization
  - File Management
  - Search & Filtering
  - Database integration
  - Security middleware
  - API documentation
