# 🎓 Skill Hub - YouTube Learning Platform Frontend

A modern Next.js frontend for the YouTube Learning Platform that transforms educational videos into interactive learning experiences.

## ✨ Features

### 🎨 Modern UI/UX
- **Next.js 14** with App Router
- **TypeScript** for type safety
- **Tailwind CSS** with custom design system
- **Radix UI** components for accessibility
- **Framer Motion** for smooth animations
- **React Query** for server state management

### 🧠 Learning Features
- **Video Processing Dashboard** - Track video processing status
- **Interactive Learning Cards** - Spaced repetition flashcards
- **Progress Analytics** - Detailed learning statistics
- **Knowledge Extraction** - AI-powered content analysis
- **Study Sessions** - Structured learning sessions

### 🔐 Authentication
- **JWT-based authentication**
- **Protected routes**
- **User profile management**
- **Role-based access control**

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Backend API running on port 3001

### Installation

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Environment setup**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your API URL
   ```

3. **Start development server**
   ```bash
   npm run dev
   ```

4. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3001

## 🏗️ Project Structure

```
src/
├── app/                    # Next.js App Router
│   ├── dashboard/         # Dashboard page
│   ├── login/            # Login page
│   ├── register/         # Registration page
│   ├── videos/           # Video management
│   ├── learning/         # Learning interface
│   └── layout.tsx        # Root layout
├── components/           # Reusable components
│   ├── ui/              # Base UI components
│   ├── video-submit-modal.tsx
│   └── providers.tsx    # Context providers
├── contexts/            # React contexts
│   └── auth-context.tsx # Authentication context
├── lib/                 # Utilities and configurations
│   ├── api.ts          # API client
│   └── utils.ts        # Helper functions
└── types/              # TypeScript type definitions
```

## 🎯 Key Components

### Authentication
- **Login/Register** - User authentication
- **Protected Routes** - Route protection
- **User Context** - Global user state

### Dashboard
- **Learning Stats** - Progress overview
- **Recent Videos** - Latest content
- **Recommendations** - AI-suggested content
- **Quick Actions** - Add videos, start learning

### Video Management
- **Video Submission** - Add YouTube videos
- **Processing Status** - Real-time updates
- **Content Library** - Browse videos
- **Knowledge Extracts** - AI-generated insights

### Learning Interface
- **Spaced Repetition** - Optimized review system
- **Interactive Cards** - Multiple question types
- **Progress Tracking** - Learning analytics
- **Study Sessions** - Structured learning

## 🔧 Configuration

### Environment Variables
```env
NEXT_PUBLIC_API_URL=http://localhost:3001/api/v1
NEXT_PUBLIC_APP_NAME=Skill Hub
NEXT_PUBLIC_APP_DESCRIPTION=Transform YouTube videos into structured, interactive learning experiences
```

### API Integration
The frontend integrates with the backend API through:
- **RESTful endpoints** for CRUD operations
- **Real-time updates** for processing status
- **Authentication** via JWT tokens
- **Error handling** with user-friendly messages

## 🎨 Design System

### Colors
- **Primary**: Blue gradient for main actions
- **Secondary**: Gray for secondary elements
- **Success**: Green for positive actions
- **Warning**: Yellow for warnings
- **Destructive**: Red for dangerous actions

### Typography
- **Font**: Inter for clean, modern look
- **Sizes**: Responsive typography scale
- **Weights**: 300-800 for hierarchy

### Components
- **Buttons**: Multiple variants and sizes
- **Cards**: Consistent spacing and shadows
- **Forms**: Accessible form components
- **Modals**: Overlay dialogs
- **Badges**: Status indicators

## 📱 Responsive Design

- **Mobile-first** approach
- **Breakpoints**: sm, md, lg, xl
- **Grid system** for layouts
- **Flexible components** for all screen sizes

## 🧪 Development

### Available Scripts
```bash
npm run dev          # Start development server
npm run build        # Build for production
npm run start        # Start production server
npm run lint         # Run ESLint
npm run type-check   # Run TypeScript check
```

### Code Quality
- **ESLint** for code linting
- **TypeScript** for type checking
- **Prettier** for code formatting
- **Husky** for git hooks

## 🚀 Deployment

### Vercel (Recommended)
```bash
npm run build
# Deploy to Vercel
```

### Docker
```bash
docker build -t skill-hub .
docker run -p 3000:3000 skill-hub
```

### Environment Setup
1. Set `NEXT_PUBLIC_API_URL` to your backend URL
2. Configure authentication settings
3. Set up analytics (optional)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

---

**Built with ❤️ for the future of education**