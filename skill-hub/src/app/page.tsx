'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { 
  Brain, 
  Target, 
  Sparkles,
  Video,
  Plus
} from 'lucide-react';

export default function HomePage() {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);

  const handleGetStarted = () => {
    setIsLoading(true);
    router.push('/login');
  };

  const features = [
    {
      icon: Brain,
      title: "AI Analysis",
      description: "Transform YouTube videos into structured learning content"
    },
    {
      icon: Target,
      title: "Spaced Repetition",
      description: "Optimize learning with scientifically-proven algorithms"
    },
    {
      icon: Video,
      title: "Interactive Cards",
      description: "Learn through flashcards generated from your videos"
    }
  ];

  const steps = [
    {
      title: "Add Video",
      description: "Paste a YouTube URL"
    },
    {
      title: "AI Processing", 
      description: "Extract key concepts and create cards"
    },
    {
      title: "Start Learning",
      description: "Review and track your progress"
    }
  ];

  return (
    <div className="min-h-screen bg-white">
      {/* Navigation */}
      <nav className="fixed top-0 w-full bg-white/95 backdrop-blur-sm border-b border-gray-100 z-50">
        <div className="w-full px-8 py-6">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 bg-gray-900 rounded-2xl flex items-center justify-center">
                <Sparkles className="h-5 w-5 text-white" />
              </div>
              <span className="text-2xl font-black text-gray-900 tracking-tight">Skill Hub</span>
            </div>
            <Button 
              onClick={handleGetStarted}
              disabled={isLoading}
              className="bg-gray-900 hover:bg-gray-800 text-white px-6 py-2 rounded-xl font-medium"
            >
              {isLoading ? "Loading..." : "Get Started"}
            </Button>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="pt-40 pb-24 px-8">
        <div className="w-full max-w-none">
          <div className="text-center space-y-12">
            <div className="space-y-8">
              <div className="inline-flex items-center gap-2 px-4 py-2 bg-gray-50 rounded-full text-sm font-medium text-gray-600">
                <div className="w-2 h-2 bg-gray-400 rounded-full animate-pulse"></div>
                AI-Powered Learning Platform
              </div>
              
              <h1 className="text-4xl md:text-6xl font-black text-gray-900 tracking-tight leading-[0.9]">
                Transform YouTube
                <span className="block text-gray-500 font-light">into Learning</span>
              </h1>
              
              <p className="text-xl text-gray-600 max-w-3xl mx-auto leading-relaxed font-medium">
                Turn any YouTube video into interactive learning content with AI-powered analysis, 
                spaced repetition, and personalized progress tracking.
              </p>
            </div>
            
            <div className="flex flex-col sm:flex-row items-center justify-center gap-6">
              <Button 
                onClick={handleGetStarted}
                disabled={isLoading}
                size="lg"
                className="bg-gray-900 hover:bg-gray-800 text-white px-10 py-4 text-lg font-semibold rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300"
              >
                <Plus className="mr-3 h-5 w-5" />
                Start Learning Free
              </Button>
              <div className="text-sm text-gray-400">
                No credit card required
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-32 px-8 bg-gray-50">
        <div className="w-full max-w-none">
          <div className="text-center space-y-6 mb-20">
            <h2 className="text-3xl md:text-4xl font-black text-gray-900 tracking-tight">
              How It Works
            </h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto font-medium">
              Three simple steps to transform your learning experience
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-16">
            {features.map((feature, index) => (
              <div key={index} className="relative">
                <div className="text-center space-y-8">
                  <div className="relative">
                    <div className="w-20 h-20 bg-white rounded-3xl flex items-center justify-center mx-auto shadow-lg border border-gray-100">
                      <feature.icon className="h-10 w-10 text-gray-700" />
                    </div>
                    <div className="absolute -top-2 -right-2 w-8 h-8 bg-gray-900 text-white rounded-full flex items-center justify-center text-sm font-bold">
                      {index + 1}
                    </div>
                  </div>
                  
                  <div className="space-y-4">
                    <h3 className="text-2xl font-black text-gray-900 tracking-tight">
                      {feature.title}
                    </h3>
                    <p className="text-gray-600 text-lg leading-relaxed font-medium">
                      {feature.description}
                    </p>
                  </div>
                </div>
                
                {index < features.length - 1 && (
                  <div className="hidden md:block absolute top-10 left-full w-16 h-0.5 bg-gray-200 transform translate-x-8"></div>
                )}
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-32 px-8 bg-gray-900 relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900"></div>
        <div className="relative w-full max-w-none">
          <div className="text-center space-y-12">
            <div className="space-y-8">
              <h2 className="text-3xl md:text-4xl font-black text-white tracking-tight">
                Ready to Start Learning?
              </h2>
              <p className="text-xl text-gray-200 max-w-2xl mx-auto leading-relaxed font-medium">
                Join thousands of learners who are already transforming their YouTube videos 
                into structured learning experiences.
              </p>
            </div>
            
            <div className="flex flex-col sm:flex-row items-center justify-center gap-8">
              <Button 
                onClick={handleGetStarted}
                disabled={isLoading}
                size="lg"
                className="bg-white text-gray-900 hover:bg-gray-100 px-12 py-5 text-xl font-semibold rounded-2xl shadow-2xl hover:shadow-3xl transition-all duration-300 transform hover:-translate-y-1"
              >
                <Plus className="mr-3 h-6 w-6" />
                Get Started Free
              </Button>
              <div className="text-gray-400 text-lg">
                No credit card required • Start in seconds
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-white border-t border-gray-100 py-16 px-8">
        <div className="w-full max-w-none">
          <div className="text-center space-y-8">
            <div className="flex items-center justify-center gap-4">
              <div className="w-12 h-12 bg-gray-900 rounded-2xl flex items-center justify-center">
                <Sparkles className="h-6 w-6 text-white" />
              </div>
              <span className="text-3xl font-black text-gray-900 tracking-tight">Skill Hub</span>
            </div>
            
            <div className="space-y-4">
              <p className="text-gray-600 text-lg max-w-2xl mx-auto font-medium">
                Transform YouTube videos into structured learning experiences with AI-powered analysis.
              </p>
              <p className="text-gray-400 text-sm">
                © 2024 Skill Hub. All rights reserved.
              </p>
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
