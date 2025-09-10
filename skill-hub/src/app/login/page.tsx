"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import {
  Eye,
  EyeOff,
  Loader2,
  Sparkles,
  BookOpen,
  Brain,
  Target,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
} from "@/components/ui/card";
import { useAuth } from "@/contexts/auth-context";
import Link from "next/link";

const loginSchema = z.object({
  email: z.string().email("Invalid email address"),
  password: z.string().min(6, "Password must be at least 6 characters"),
});

type LoginForm = z.infer<typeof loginSchema>;

export default function LoginPage() {
  const [showPassword, setShowPassword] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const { login } = useAuth();
  const router = useRouter();

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginForm>({
    resolver: zodResolver(loginSchema),
  });

  const onSubmit = async (data: LoginForm) => {
    setIsLoading(true);
    try {
      await login(data.email, data.password);
      router.push("/dashboard");
    } catch {
      // Error is handled in the auth context
    } finally {
      setIsLoading(false);
    }
  };

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
            <Link
              href="/"
              className="text-gray-600 hover:text-gray-900 font-medium"
            >
              Back to Home
            </Link>
          </div>
        </div>
      </nav>

      <div className="w-full px-8 pt-32 pb-16">
        <div className="w-full max-w-none">
          <div className="grid lg:grid-cols-2 gap-16 items-center min-h-[calc(100vh-8rem)]">
            {/* Left side - Branding */}
            <div className="hidden lg:block space-y-12">
              <div className="space-y-8">
                <div className="space-y-6">
                  <h1 className="text-4xl md:text-5xl font-black text-gray-900 tracking-tight leading-[0.9]">
                    Welcome Back to
                    <span className="block text-gray-500 font-light">Skill Hub</span>
                  </h1>
                  <p className="text-xl text-gray-600 leading-relaxed font-medium">
                    Continue your learning journey with AI-powered analysis and 
                    structured content from your favorite YouTube videos.
                  </p>
                </div>

                <div className="space-y-8">
                  <div className="flex items-center gap-6">
                    <div className="w-16 h-16 bg-white rounded-3xl flex items-center justify-center shadow-lg border border-gray-100">
                      <BookOpen className="h-8 w-8 text-gray-700" />
                    </div>
                    <div>
                      <h3 className="text-xl font-black text-gray-900 tracking-tight">AI-Powered Learning</h3>
                      <p className="text-gray-600 font-medium">
                        Extract key concepts and insights automatically
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-6">
                    <div className="w-16 h-16 bg-white rounded-3xl flex items-center justify-center shadow-lg border border-gray-100">
                      <Brain className="h-8 w-8 text-gray-700" />
                    </div>
                    <div>
                      <h3 className="text-xl font-black text-gray-900 tracking-tight">Spaced Repetition</h3>
                      <p className="text-gray-600 font-medium">
                        Optimize retention with proven learning algorithms
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-6">
                    <div className="w-16 h-16 bg-white rounded-3xl flex items-center justify-center shadow-lg border border-gray-100">
                      <Target className="h-8 w-8 text-gray-700" />
                    </div>
                    <div>
                      <h3 className="text-xl font-black text-gray-900 tracking-tight">Progress Tracking</h3>
                      <p className="text-gray-600 font-medium">
                        Monitor your learning journey with detailed analytics
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            {/* Right side - Login Form */}
            <div className="w-full max-w-md mx-auto lg:max-w-lg">
              <Card className="shadow-xl border border-gray-100 rounded-3xl">
                <CardHeader className="space-y-6 p-8">
                  <div className="text-center space-y-4">
                    <div className="w-16 h-16 bg-gray-900 rounded-2xl flex items-center justify-center mx-auto">
                      <Sparkles className="h-8 w-8 text-white" />
                    </div>
                    <div className="space-y-2">
                      <h2 className="text-3xl font-black text-gray-900 tracking-tight">Welcome Back</h2>
                      <p className="text-gray-600 font-medium">
                        Sign in to your Skill Hub account to continue learning
                      </p>
                    </div>
                  </div>
                </CardHeader>
                <CardContent className="p-8 pt-0">
                  <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                    <div className="space-y-3">
                      <label htmlFor="email" className="text-sm font-black text-gray-900">
                        Email
                      </label>
                      <Input
                        id="email"
                        type="email"
                        placeholder="Enter your email"
                        className="h-12 rounded-xl border-gray-200 focus:border-gray-400 focus:ring-0"
                        {...register("email")}
                      />
                      {errors.email && (
                        <p className="text-sm text-red-600">
                          {errors.email.message}
                        </p>
                      )}
                    </div>

                    <div className="space-y-3">
                      <label htmlFor="password" className="text-sm font-black text-gray-900">
                        Password
                      </label>
                      <div className="relative">
                        <Input
                          id="password"
                          type={showPassword ? "text" : "password"}
                          placeholder="Enter your password"
                          className="h-12 rounded-xl border-gray-200 focus:border-gray-400 focus:ring-0 pr-12"
                          {...register("password")}
                        />
                        <Button
                          type="button"
                          variant="ghost"
                          size="icon"
                          className="absolute right-0 top-0 h-12 px-3 py-2 hover:bg-transparent"
                          onClick={() => setShowPassword(!showPassword)}
                        >
                          {showPassword ? (
                            <EyeOff className="h-5 w-5 text-gray-400" />
                          ) : (
                            <Eye className="h-5 w-5 text-gray-400" />
                          )}
                        </Button>
                      </div>
                      {errors.password && (
                        <p className="text-sm text-red-600">
                          {errors.password.message}
                        </p>
                      )}
                    </div>

                    <div className="flex items-center justify-between">
                      <div className="flex items-center space-x-2">
                        <input
                          id="remember"
                          type="checkbox"
                          className="h-4 w-4 rounded border-gray-300 text-gray-900 focus:ring-gray-400"
                        />
                        <label htmlFor="remember" className="text-sm text-gray-600">
                          Remember me
                        </label>
                      </div>
                      <Link
                        href="#"
                        className="text-sm text-gray-600 hover:text-gray-900 font-medium"
                      >
                        Forgot password?
                      </Link>
                    </div>

                    <Button
                      type="submit"
                      className="w-full h-12 bg-gray-900 hover:bg-gray-800 text-white rounded-xl font-black text-lg"
                      disabled={isLoading}
                    >
                      {isLoading ? (
                        <>
                          <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                          Signing in...
                        </>
                      ) : (
                        "Sign In"
                      )}
                    </Button>

                    <div className="text-center">
                      <p className="text-sm text-gray-600">
                        Don&apos;t have an account?{" "}
                        <Link
                          href="/register"
                          className="text-gray-900 hover:text-gray-700 font-black"
                        >
                          Sign up
                        </Link>
                      </p>
                    </div>
                  </form>

                  {/* Demo credentials */}
                  <div className="mt-8 p-6 bg-gray-50 rounded-2xl border border-gray-100">
                    <h3 className="text-sm font-black text-gray-900 mb-3">
                      Demo Credentials
                    </h3>
                    <div className="text-sm text-gray-600 space-y-2">
                      <p>
                        <strong className="text-gray-900">Email:</strong> admin@example.com
                      </p>
                      <p>
                        <strong className="text-gray-900">Password:</strong> password123
                      </p>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
