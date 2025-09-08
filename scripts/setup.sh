#!/bin/bash

# EdgeCore Setup Script
echo "🚀 Setting up EdgeCore..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ is required. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js version: $(node -v)"

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL is not installed. Please install PostgreSQL 12+ first."
    exit 1
fi

echo "✅ PostgreSQL is installed"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cp env.example .env
    echo "⚠️  Please edit .env file with your configuration before continuing."
    echo "   Required: Database credentials, JWT secrets, AWS S3 credentials"
    read -p "Press Enter to continue after editing .env file..."
fi

# Create logs directory
mkdir -p logs

# Create uploads directory
mkdir -p uploads

# Check if database exists
echo "🗄️  Checking database connection..."
DB_NAME=$(grep DB_NAME .env | cut -d'=' -f2)
DB_HOST=$(grep DB_HOST .env | cut -d'=' -f2)
DB_PORT=$(grep DB_PORT .env | cut -d'=' -f2)
DB_USERNAME=$(grep DB_USERNAME .env | cut -d'=' -f2)

if ! psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME" -d "$DB_NAME" -c '\q' 2>/dev/null; then
    echo "📊 Creating database..."
    createdb -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USERNAME" "$DB_NAME"
fi

# Run migrations
echo "🔄 Running database migrations..."
npm run migrate

# Seed database
echo "🌱 Seeding database..."
npm run seed

# Build the application
echo "🔨 Building application..."
npm run build

echo "✅ Setup completed successfully!"
echo ""
echo "🎉 EdgeCore is ready to use!"
echo ""
echo "📋 Next steps:"
echo "   1. Start the development server: npm run dev"
echo "   2. Visit: http://localhost:3000/api/v1/health"
echo "   3. API Documentation: http://localhost:3000/api-docs"
echo ""
echo "🔐 Default admin credentials:"
echo "   Email: admin@edgecore.com"
echo "   Password: admin123456"
echo ""
echo "👤 Default test user credentials:"
echo "   Email: test@edgecore.com"
echo "   Password: test123456"
