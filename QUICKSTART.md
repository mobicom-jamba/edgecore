# EdgeCore Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites

- Node.js 18+
- PostgreSQL 12+
- Git

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd edgecore
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 2. Configure Environment

Edit `.env` file with your settings:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_NAME=edgecore_db

# JWT Secrets (generate strong secrets)
JWT_SECRET=your-super-secret-jwt-key
JWT_REFRESH_SECRET=your-super-secret-refresh-key

# AWS S3 (for file uploads)
AWS_ACCESS_KEY_ID=your-aws-key
AWS_SECRET_ACCESS_KEY=your-aws-secret
AWS_S3_BUCKET=your-bucket-name
```

### 3. Start Development Server

```bash
npm run dev
```

### 4. Test the API

```bash
# Health check
curl http://localhost:3000/api/v1/health

# Register a user
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "password": "password123"
  }'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

## 🔑 Default Credentials

**Admin User:**

- Email: `admin@edgecore.com`
- Password: `admin123456`

**Test User:**

- Email: `test@edgecore.com`
- Password: `test123456`

## 📚 API Endpoints

### Authentication

- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/refresh-token` - Refresh JWT token
- `GET /api/v1/auth/profile` - Get user profile (protected)
- `POST /api/v1/auth/forgot-password` - Request password reset
- `POST /api/v1/auth/reset-password` - Reset password

### File Management

- `POST /api/v1/files/upload` - Upload file (protected)
- `GET /api/v1/files` - Get user files (protected)
- `GET /api/v1/files/:id` - Get specific file (protected)
- `PUT /api/v1/files/:id` - Update file (protected)
- `DELETE /api/v1/files/:id` - Delete file (protected)

### System

- `GET /api/v1/health` - Health check
- `GET /api-docs` - API documentation (Swagger)

## 🛠️ Development Commands

```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server
npm test             # Run tests
npm run lint         # Run ESLint
npm run migrate      # Run database migrations
npm run seed         # Seed database with test data
```

## 🐳 Docker Setup

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop services
docker-compose down
```

## 🔧 Configuration

### Environment Variables

All configuration is done through environment variables in `.env` file. See `env.example` for all available options.

### Database

- Uses PostgreSQL with TypeORM
- Automatic migrations on startup
- Seeded with default users

### Security

- JWT-based authentication
- Rate limiting on all endpoints
- Input validation and sanitization
- CORS protection
- Helmet security headers

### File Storage

- AWS S3 integration
- File type validation
- Size limits
- Secure file serving

## 📊 Monitoring

- Structured logging with Winston
- Request/response logging
- Error tracking
- Performance monitoring
- Health check endpoints

## 🚀 Production Deployment

### Using Docker

```bash
docker build -t edgecore .
docker run -p 3000:3000 --env-file .env edgecore
```

### Manual Deployment

```bash
npm run build
npm start
```

### Environment Setup

- Set `NODE_ENV=production`
- Use strong JWT secrets
- Configure production database
- Set up SSL certificates
- Configure reverse proxy (Nginx)

## 🆘 Troubleshooting

### Common Issues

1. **Database Connection Error**

   - Check PostgreSQL is running
   - Verify database credentials in `.env`
   - Ensure database exists

2. **JWT Token Errors**

   - Check JWT_SECRET is set
   - Verify token format in Authorization header
   - Check token expiration

3. **File Upload Issues**

   - Verify AWS S3 credentials
   - Check file size limits
   - Ensure allowed file types

4. **Port Already in Use**
   - Change PORT in `.env`
   - Kill existing process: `lsof -ti:3000 | xargs kill`

### Getting Help

- Check logs in `logs/` directory
- Review API documentation at `/api-docs`
- Check health endpoint: `/api/v1/health`

## 📈 Next Steps

1. **Customize**: Modify models, controllers, and services for your needs
2. **Extend**: Add new features and endpoints
3. **Deploy**: Set up production environment
4. **Monitor**: Configure monitoring and alerting
5. **Scale**: Add load balancing and caching

## 🎯 Features Overview

✅ **Authentication & Authorization**

- User registration/login
- JWT token management
- Role-based access control
- Password reset functionality

✅ **File Management**

- Secure file upload
- AWS S3 integration
- File metadata storage
- Download URL generation

✅ **Search & Filtering**

- Advanced search capabilities
- Pagination and sorting
- Filter by file type, user, etc.

✅ **Security**

- Rate limiting
- Input validation
- SQL injection protection
- XSS protection
- CORS configuration

✅ **Monitoring**

- Structured logging
- Error tracking
- Performance monitoring
- Health checks

✅ **Email Service**

- SendGrid/Mailgun integration
- Email templates
- Welcome emails
- Password reset emails

✅ **API Documentation**

- Swagger/OpenAPI
- Interactive documentation
- Request/response examples

This is a production-ready backend framework that you can use as a foundation for any application requiring user management, file handling, and secure API endpoints.
