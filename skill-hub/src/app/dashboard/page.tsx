"use client";

import { useQuery } from '@tanstack/react-query';
import { 
  Video, 
  BookOpen, 
  Brain, 
  TrendingUp, 
  Clock, 
  Target,
  BarChart3,
  Users,
  Plus,
  Play,
  Star,
  Award,
  Zap,
  Sparkles,
  ArrowRight,
  Calendar,
  Timer,
  CheckCircle2,
  CreditCard
} from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { apiService } from '@/lib/api';
import { formatDate, getInitials } from '@/lib/utils';
import { VideoSubmitModal } from '@/components/video-submit-modal';
import { LearningStats } from '@/components/learning-stats';
import { ProgressChart } from '@/components/progress-chart';
import { Navigation } from '@/components/navigation';
import { useState } from 'react';
import Link from 'next/link';

export default function DashboardPage() {
  const [showVideoModal, setShowVideoModal] = useState(false);

  const { data: dashboardData, isLoading } = useQuery({
    queryKey: ['dashboard'],
    queryFn: () => apiService.getDashboard().then(res => res.data.data),
    refetchInterval: 30000, // Refetch every 30 seconds
  });

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-gray-100">
        <div className="space-y-10 p-8 max-w-7xl mx-auto">
          {/* Hero Section Skeleton */}
          <div className="relative overflow-hidden rounded-3xl bg-white border border-gray-200/60 p-10 shadow-xl shadow-gray-900/5">
            <div className="animate-pulse">
              <div className="h-16 bg-gray-200 rounded-2xl w-1/3 mb-6"></div>
              <div className="h-8 bg-gray-200 rounded w-1/2 mb-8"></div>
              <div className="h-12 bg-gray-200 rounded-2xl w-40"></div>
            </div>
          </div>
          
          {/* Stats Cards Skeleton */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            {[...Array(4)].map((_, i) => (
              <Card key={i} className="bg-white border border-gray-200/60 rounded-2xl shadow-lg shadow-gray-900/5">
                <CardContent className="p-8">
                  <div className="animate-pulse">
                    <div className="h-16 w-16 bg-gray-200 rounded-2xl mb-6"></div>
                    <div className="h-4 bg-gray-200 rounded w-3/4 mb-4"></div>
                    <div className="h-12 bg-gray-200 rounded w-1/2 mb-4"></div>
                    <div className="h-1 bg-gray-200 rounded-full"></div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </div>
    );
  }

  const { stats, learningPath } = dashboardData || {};

  const statCards = [
    {
      title: 'Total Videos',
      value: stats?.totalVideos || 0,
      icon: Video,
      change: '+12%',
      changeType: 'positive',
    },
    {
      title: 'Knowledge Extracts',
      value: stats?.totalExtracts || 0,
      icon: BookOpen,
      change: '+8%',
      changeType: 'positive',
    },
    {
      title: 'Learning Cards',
      value: stats?.totalCards || 0,
      icon: Brain,
      change: '+15%',
      changeType: 'positive',
    },
    {
      title: 'Study Streak',
      value: `${stats?.studyStreak || 0} days`,
      icon: TrendingUp,
      change: '🔥',
      changeType: 'fire',
    },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-gray-100">
      <Navigation />
      <div className="space-y-10 p-8 max-w-7xl mx-auto">
        {/* Hero Section */}
        <div className="relative overflow-hidden rounded-3xl bg-white border border-gray-200/60 p-10 shadow-xl shadow-gray-900/5">
          <div className="absolute inset-0 bg-gradient-to-br from-gray-50/50 to-transparent"></div>
          <div className="relative">
            <div className="flex items-center justify-between">
              <div className="space-y-6">
                <div className="flex items-center gap-4">
                  <div className="p-3 bg-gradient-to-br from-gray-100 to-gray-200 rounded-2xl shadow-sm">
                    <Sparkles className="h-7 w-7 text-gray-700" />
                  </div>
                  <div>
                    <h1 className="text-5xl font-bold text-gray-900 tracking-tight">
                      Learning Dashboard
                    </h1>
                    <div className="flex items-center gap-2 mt-2">
                      <div className="w-2 h-2 bg-gray-400 rounded-full animate-pulse"></div>
                      <span className="text-sm text-gray-500 font-medium">AI-Powered Learning Platform</span>
                    </div>
                  </div>
                </div>
                <p className="text-xl text-gray-600 max-w-3xl leading-relaxed">
                  Transform your YouTube videos into structured learning experiences with AI-powered insights, 
                  spaced repetition, and personalized learning paths.
                </p>
                <div className="flex items-center gap-6">
                  <Button 
                    onClick={() => setShowVideoModal(true)}
                    size="lg"
                    className="bg-gray-900 hover:bg-gray-800 text-white px-8 py-4 text-lg font-semibold shadow-lg hover:shadow-xl transition-all duration-300 hover:-translate-y-0.5"
                  >
                    <Plus className="mr-3 h-5 w-5" />
                    Add New Video
                  </Button>
                  <div className="flex items-center gap-3 text-gray-500 bg-gray-50 px-4 py-2 rounded-xl">
                    <Clock className="h-4 w-4" />
                    <span className="text-sm font-medium">Last updated: {new Date().toLocaleTimeString()}</span>
                  </div>
                </div>
              </div>
              <div className="hidden lg:block">
                <div className="w-32 h-32 bg-gradient-to-br from-gray-100 to-gray-200 rounded-3xl shadow-lg"></div>
              </div>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          <Card className="group bg-white border border-gray-200/60 hover:shadow-xl hover:shadow-gray-900/10 transition-all duration-500 hover:-translate-y-2 rounded-2xl overflow-hidden">
            <CardContent className="p-8">
              <div className="flex items-center gap-4 mb-6">
                <div className="p-4 rounded-2xl bg-gradient-to-br from-blue-100 to-blue-200 group-hover:from-blue-200 group-hover:to-blue-300 transition-all duration-300 shadow-sm">
                  <CreditCard className="h-7 w-7 text-blue-700 group-hover:scale-110 transition-transform duration-300" />
                </div>
                <div>
                  <h3 className="text-lg font-bold text-gray-900">Billing & Plans</h3>
                  <p className="text-sm text-gray-600">Manage your subscription</p>
                </div>
              </div>
              <p className="text-gray-600 mb-6">
                View your current plan, usage statistics, and manage your billing preferences.
              </p>
              <Link href="/billing">
                <Button className="w-full bg-blue-600 hover:bg-blue-700 text-white">
                  <CreditCard className="w-4 h-4 mr-2" />
                  Manage Billing
                </Button>
              </Link>
            </CardContent>
          </Card>

          <Card className="group bg-white border border-gray-200/60 hover:shadow-xl hover:shadow-gray-900/10 transition-all duration-500 hover:-translate-y-2 rounded-2xl overflow-hidden">
            <CardContent className="p-8">
              <div className="flex items-center gap-4 mb-6">
                <div className="p-4 rounded-2xl bg-gradient-to-br from-green-100 to-green-200 group-hover:from-green-200 group-hover:to-green-300 transition-all duration-300 shadow-sm">
                  <Plus className="h-7 w-7 text-green-700 group-hover:scale-110 transition-transform duration-300" />
                </div>
                <div>
                  <h3 className="text-lg font-bold text-gray-900">Add Video</h3>
                  <p className="text-sm text-gray-600">Start learning</p>
                </div>
              </div>
              <p className="text-gray-600 mb-6">
                Transform any YouTube video into interactive learning content with AI.
              </p>
              <Button 
                onClick={() => setShowVideoModal(true)}
                className="w-full bg-green-600 hover:bg-green-700 text-white"
              >
                <Plus className="w-4 h-4 mr-2" />
                Add New Video
              </Button>
            </CardContent>
          </Card>

          <Card className="group bg-white border border-gray-200/60 hover:shadow-xl hover:shadow-gray-900/10 transition-all duration-500 hover:-translate-y-2 rounded-2xl overflow-hidden">
            <CardContent className="p-8">
              <div className="flex items-center gap-4 mb-6">
                <div className="p-4 rounded-2xl bg-gradient-to-br from-purple-100 to-purple-200 group-hover:from-purple-200 group-hover:to-purple-300 transition-all duration-300 shadow-sm">
                  <Brain className="h-7 w-7 text-purple-700 group-hover:scale-110 transition-transform duration-300" />
                </div>
                <div>
                  <h3 className="text-lg font-bold text-gray-900">Study Session</h3>
                  <p className="text-sm text-gray-600">Review cards</p>
                </div>
              </div>
              <p className="text-gray-600 mb-6">
                Start a spaced repetition session to review your learning cards.
              </p>
              <Button className="w-full bg-purple-600 hover:bg-purple-700 text-white">
                <Brain className="w-4 h-4 mr-2" />
                Start Studying
              </Button>
            </CardContent>
          </Card>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {statCards.map((stat, index) => (
            <Card 
              key={index} 
              className="group bg-white border border-gray-200/60 hover:shadow-xl hover:shadow-gray-900/10 transition-all duration-500 hover:-translate-y-2 rounded-2xl overflow-hidden"
            >
              <CardContent className="p-8">
                <div className="flex items-center justify-between mb-6">
                  <div className="p-4 rounded-2xl bg-gradient-to-br from-gray-100 to-gray-200 group-hover:from-gray-200 group-hover:to-gray-300 transition-all duration-300 shadow-sm">
                    <stat.icon className="h-7 w-7 text-gray-700 group-hover:scale-110 transition-transform duration-300" />
                  </div>
                  <div className="text-right">
                    <span className={`text-xs font-bold px-3 py-1.5 rounded-full shadow-sm ${
                      stat.changeType === 'positive' ? 'bg-gray-100 text-gray-700' :
                      stat.changeType === 'fire' ? 'bg-gray-100 text-gray-700' :
                      'bg-gray-100 text-gray-700'
                    }`}>
                      {stat.change}
                    </span>
                  </div>
                </div>
                <div className="space-y-2">
                  <p className="text-sm font-semibold text-gray-600 uppercase tracking-wide">{stat.title}</p>
                  <p className="text-4xl font-bold text-gray-900 group-hover:text-gray-700 transition-colors duration-300">
                    {stat.value}
                  </p>
                </div>
                <div className="mt-4 h-1 bg-gray-100 rounded-full overflow-hidden">
                  <div className="h-full bg-gradient-to-r from-gray-300 to-gray-400 rounded-full w-0 group-hover:w-full transition-all duration-1000 ease-out"></div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Learning Progress & Statistics */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Progress Overview */}
          <Card className="bg-white border border-gray-200/60 rounded-2xl shadow-lg shadow-gray-900/5 overflow-hidden">
            <CardHeader className="pb-6 bg-gradient-to-r from-gray-50 to-white border-b border-gray-100">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="p-3 bg-gradient-to-br from-gray-100 to-gray-200 rounded-2xl shadow-sm">
                    <BarChart3 className="h-6 w-6 text-gray-700" />
                  </div>
                  <div>
                    <CardTitle className="text-2xl text-gray-900 font-bold">Learning Progress</CardTitle>
                    <p className="text-sm text-gray-500 mt-1">Track your learning journey</p>
                  </div>
                </div>
                <Badge variant="secondary" className="bg-gray-100 text-gray-700 px-3 py-1.5 font-semibold">
                  <TrendingUp className="h-3 w-3 mr-2" />
                  Active
                </Badge>
              </div>
            </CardHeader>
            <CardContent className="p-8">
              {stats?.progressBySubject && Object.keys(stats.progressBySubject).length > 0 ? (
                <div className="space-y-8">
                  {Object.entries(stats.progressBySubject).map(([subject, progress]) => (
                    <div key={subject} className="space-y-4">
                      <div className="flex justify-between items-center">
                        <span className="font-bold text-gray-900 text-lg">{subject}</span>
                        <span className="text-sm font-bold text-gray-700 bg-gray-100 px-4 py-2 rounded-full shadow-sm">
                          {progress as number}%
                        </span>
                      </div>
                      <div className="relative">
                        <div className="w-full bg-gray-200 rounded-full h-4 shadow-inner">
                          <div 
                            className="h-4 bg-gradient-to-r from-gray-700 to-gray-900 rounded-full transition-all duration-1000 ease-out shadow-sm"
                            style={{ width: `${progress as number}%` }}
                          />
                        </div>
                        <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent rounded-full animate-pulse"></div>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="text-center py-16">
                  <div className="w-24 h-24 bg-gradient-to-br from-gray-100 to-gray-200 rounded-3xl flex items-center justify-center mx-auto mb-6 shadow-lg">
                    <Target className="h-12 w-12 text-gray-600" />
                  </div>
                  <h3 className="text-2xl font-bold text-gray-900 mb-3">Start Your Learning Journey</h3>
                  <p className="text-gray-500 mb-8 max-w-md mx-auto leading-relaxed">Add videos to begin tracking your progress and unlock personalized learning insights</p>
                  <Button onClick={() => setShowVideoModal(true)} className="bg-gray-900 hover:bg-gray-800 px-8 py-3 text-lg font-semibold shadow-lg hover:shadow-xl transition-all duration-300">
                    <Plus className="mr-3 h-5 w-5" />
                    Add First Video
                  </Button>
                </div>
              )}
            </CardContent>
          </Card>

          {/* Study Statistics */}
          <Card className="bg-white border border-gray-200/60 rounded-2xl shadow-lg shadow-gray-900/5 overflow-hidden">
            <CardHeader className="pb-6 bg-gradient-to-r from-gray-50 to-white border-b border-gray-100">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="p-3 bg-gradient-to-br from-gray-100 to-gray-200 rounded-2xl shadow-sm">
                    <Award className="h-6 w-6 text-gray-700" />
                  </div>
                  <div>
                    <CardTitle className="text-2xl text-gray-900 font-bold">Study Statistics</CardTitle>
                    <p className="text-sm text-gray-500 mt-1">Your learning achievements</p>
                  </div>
                </div>
                <Badge variant="secondary" className="bg-gray-100 text-gray-700 px-3 py-1.5 font-semibold">
                  <Star className="h-3 w-3 mr-2" />
                  Achievements
                </Badge>
              </div>
            </CardHeader>
            <CardContent className="p-8">
              <div className="space-y-6">
                <div className="flex justify-between items-center p-6 bg-gradient-to-r from-gray-50 to-gray-100 rounded-2xl border border-gray-200/50 hover:shadow-md transition-all duration-300">
                  <div className="flex items-center gap-4">
                    <div className="p-3 bg-white rounded-xl shadow-sm">
                      <BookOpen className="h-5 w-5 text-gray-600" />
                    </div>
                    <span className="font-bold text-gray-900 text-lg">Cards Reviewed</span>
                  </div>
                  <span className="text-3xl font-bold text-gray-900">{stats?.cardsReviewed || 0}</span>
                </div>
                
                <div className="flex justify-between items-center p-6 bg-gradient-to-r from-gray-50 to-gray-100 rounded-2xl border border-gray-200/50 hover:shadow-md transition-all duration-300">
                  <div className="flex items-center gap-4">
                    <div className="p-3 bg-white rounded-xl shadow-sm">
                      <CheckCircle2 className="h-5 w-5 text-gray-600" />
                    </div>
                    <span className="font-bold text-gray-900 text-lg">Cards Mastered</span>
                  </div>
                  <span className="text-3xl font-bold text-gray-900">{stats?.cardsMastered || 0}</span>
                </div>
                
                <div className="flex justify-between items-center p-6 bg-gradient-to-r from-gray-50 to-gray-100 rounded-2xl border border-gray-200/50 hover:shadow-md transition-all duration-300">
                  <div className="flex items-center gap-4">
                    <div className="p-3 bg-white rounded-xl shadow-sm">
                      <Target className="h-5 w-5 text-gray-600" />
                    </div>
                    <span className="font-bold text-gray-900 text-lg">Average Accuracy</span>
                  </div>
                  <span className="text-3xl font-bold text-gray-900">{stats?.averageAccuracy || 0}%</span>
                </div>
                
                <div className="flex justify-between items-center p-6 bg-gradient-to-r from-gray-50 to-gray-100 rounded-2xl border border-gray-200/50 hover:shadow-md transition-all duration-300">
                  <div className="flex items-center gap-4">
                    <div className="p-3 bg-white rounded-xl shadow-sm">
                      <Timer className="h-5 w-5 text-gray-600" />
                    </div>
                    <span className="font-bold text-gray-900 text-lg">Time Spent</span>
                  </div>
                  <span className="text-3xl font-bold text-gray-900">
                    {stats?.timeSpent ? Math.floor(stats.timeSpent / 3600) : 0}h
                  </span>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Recent Videos */}
        <Card className="bg-white border border-gray-200/60 rounded-2xl shadow-lg shadow-gray-900/5 overflow-hidden">
          <CardHeader className="pb-8 bg-gradient-to-r from-gray-50 to-white border-b border-gray-100">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className="p-3 bg-gradient-to-br from-gray-100 to-gray-200 rounded-2xl shadow-sm">
                  <Video className="h-6 w-6 text-gray-700" />
                </div>
                <div>
                  <CardTitle className="text-2xl text-gray-900 font-bold">Recent Videos</CardTitle>
                  <CardDescription className="text-gray-500 mt-1">Your latest learning content</CardDescription>
                </div>
              </div>
              <Button variant="outline" size="sm" className="border-gray-300 text-gray-600 hover:bg-gray-50 px-4 py-2 font-semibold">
                <ArrowRight className="h-4 w-4 mr-2" />
                View all
              </Button>
            </div>
          </CardHeader>
          <CardContent className="p-8">
            {learningPath?.videos && learningPath.videos.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                {learningPath.videos.slice(0, 6).map((video: any) => (
                  <Card key={video.id} className="group overflow-hidden border border-gray-200/60 hover:shadow-xl hover:shadow-gray-900/10 transition-all duration-500 hover:-translate-y-2 bg-white rounded-2xl">
                    <div className="aspect-video bg-gray-100 relative overflow-hidden">
                      {video.thumbnailUrl ? (
                        <img 
                          src={video.thumbnailUrl} 
                          alt={video.title}
                          className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                        />
                      ) : (
                        <div className="w-full h-full flex items-center justify-center bg-gradient-to-br from-gray-100 to-gray-200">
                          <Video className="h-16 w-16 text-gray-400" />
                        </div>
                      )}
                      <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                      <div className="absolute bottom-4 right-4">
                        <Badge className="bg-black/80 text-white border-0 px-3 py-1.5 font-semibold">
                          <Timer className="h-3 w-3 mr-2" />
                          {video.duration ? Math.floor(video.duration / 60) : 0}m
                        </Badge>
                      </div>
                      <div className="absolute top-4 left-4">
                        <div className="w-10 h-10 bg-white/95 rounded-full flex items-center justify-center backdrop-blur-sm shadow-lg group-hover:scale-110 transition-transform duration-300">
                          <Play className="h-5 w-5 text-gray-700 ml-0.5" />
                        </div>
                      </div>
                    </div>
                    <CardContent className="p-6">
                      <h3 className="font-bold text-gray-900 line-clamp-2 mb-4 group-hover:text-gray-700 transition-colors text-lg">
                        {video.title}
                      </h3>
                      <div className="space-y-4">
                        <div className="flex justify-between items-center">
                          <span className="text-sm font-semibold text-gray-600 uppercase tracking-wide">Progress</span>
                          <span className="text-lg font-bold text-gray-900">{Math.round(video.progress || 0)}%</span>
                        </div>
                        <div className="relative">
                          <div className="w-full bg-gray-200 rounded-full h-3 shadow-inner">
                            <div 
                              className="h-3 bg-gradient-to-r from-gray-700 to-gray-900 rounded-full transition-all duration-1000 ease-out shadow-sm"
                              style={{ width: `${video.progress || 0}%` }}
                            />
                          </div>
                        </div>
                        <div className="flex justify-between text-sm text-gray-500 font-medium">
                          <span className="flex items-center gap-2">
                            <Brain className="h-4 w-4" />
                            {video.conceptsLearned || 0} learned
                          </span>
                          <span>{video.totalConcepts || 0} total</span>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            ) : (
              <div className="text-center py-20">
                <div className="w-32 h-32 bg-gradient-to-br from-gray-100 to-gray-200 rounded-3xl flex items-center justify-center mx-auto mb-8 shadow-lg">
                  <Video className="h-16 w-16 text-gray-500" />
                </div>
                <h3 className="text-3xl font-bold text-gray-900 mb-4">No videos yet</h3>
                <p className="text-gray-500 mb-10 max-w-lg mx-auto text-lg leading-relaxed">
                  Start your learning journey by adding your first YouTube video and transform it into interactive learning content with AI-powered insights
                </p>
                <Button 
                  onClick={() => setShowVideoModal(true)} 
                  size="lg"
                  className="bg-gray-900 hover:bg-gray-800 px-10 py-4 text-xl font-bold shadow-xl hover:shadow-2xl transition-all duration-300 hover:-translate-y-1"
                >
                  <Plus className="mr-3 h-6 w-6" />
                  Add Your First Video
                </Button>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Recommendations */}
        {learningPath?.recommendations && learningPath.recommendations.length > 0 && (
          <Card className="bg-white border border-gray-200/60 rounded-2xl shadow-lg shadow-gray-900/5 overflow-hidden">
            <CardHeader className="pb-8 bg-gradient-to-r from-gray-50 to-white border-b border-gray-100">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="p-3 bg-gradient-to-br from-gray-100 to-gray-200 rounded-2xl shadow-sm">
                    <Users className="h-6 w-6 text-gray-700" />
                  </div>
                  <div>
                    <CardTitle className="text-2xl text-gray-900 font-bold">Recommended for You</CardTitle>
                    <CardDescription className="text-gray-500 mt-1">Based on your learning patterns</CardDescription>
                  </div>
                </div>
                <Badge variant="secondary" className="bg-gray-100 text-gray-700 px-3 py-1.5 font-semibold">
                  <Zap className="h-3 w-3 mr-2" />
                  AI Powered
                </Badge>
              </div>
            </CardHeader>
            <CardContent className="p-8">
              <div className="space-y-6">
                {learningPath.recommendations.map((rec: any, index: number) => (
                  <div key={index} className="group flex items-center justify-between p-8 bg-gradient-to-r from-gray-50 to-gray-100 rounded-3xl border border-gray-200/50 hover:shadow-xl hover:shadow-gray-900/10 transition-all duration-500 hover:-translate-y-1">
                    <div className="flex-1">
                      <div className="flex items-center gap-4 mb-3">
                        <div className="w-3 h-3 bg-gray-400 rounded-full group-hover:bg-gray-600 transition-colors duration-300"></div>
                        <h4 className="font-bold text-gray-900 text-xl group-hover:text-gray-700 transition-colors">{rec.title}</h4>
                      </div>
                      <p className="text-gray-600 text-lg leading-relaxed">{rec.reason}</p>
                    </div>
                    <div className="flex items-center gap-4">
                      <Badge 
                        className="bg-gray-100 text-gray-700 border-gray-200 px-4 py-2 font-semibold text-sm"
                      >
                        {rec.difficulty}
                      </Badge>
                      <Button size="lg" className="bg-gray-900 hover:bg-gray-800 text-white border-0 px-6 py-3 font-semibold shadow-lg hover:shadow-xl transition-all duration-300 hover:-translate-y-0.5">
                        <Play className="h-5 w-5 mr-3" />
                        Start
                      </Button>
                    </div>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        )}

        {/* Video Submit Modal */}
        {showVideoModal && (
          <VideoSubmitModal
            isOpen={showVideoModal}
            onClose={() => setShowVideoModal(false)}
          />
        )}
      </div>
    </div>
  );
}
