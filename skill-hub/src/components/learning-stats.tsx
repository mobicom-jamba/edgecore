"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { TrendingUp, Clock, Target, Award } from "lucide-react";

interface LearningStatsProps {
  stats?: {
    totalVideos?: number;
    totalExtracts?: number;
    totalCards?: number;
    cardsReviewed?: number;
    cardsMastered?: number;
    averageAccuracy?: number;
    studyStreak?: number;
    timeSpent?: number;
  };
}

export function LearningStats({ stats }: LearningStatsProps) {
  const statItems = [
    {
      label: "Cards Reviewed",
      value: stats?.cardsReviewed || 0,
      icon: Target,
      color: "text-blue-600",
      bgColor: "bg-blue-100",
    },
    {
      label: "Cards Mastered",
      value: stats?.cardsMastered || 0,
      icon: Award,
      color: "text-green-600",
      bgColor: "bg-green-100",
    },
    {
      label: "Average Accuracy",
      value: `${stats?.averageAccuracy || 0}%`,
      icon: TrendingUp,
      color: "text-purple-600",
      bgColor: "bg-purple-100",
    },
    {
      label: "Time Spent",
      value: `${Math.floor((stats?.timeSpent || 0) / 3600)}h`,
      icon: Clock,
      color: "text-orange-600",
      bgColor: "bg-orange-100",
    },
  ];

  return (
    <div className="space-y-4">
      {statItems.map((item, index) => (
        <div key={index} className="flex items-center justify-between p-3 bg-muted rounded-lg">
          <div className="flex items-center gap-3">
            <div className={`p-2 rounded-lg ${item.bgColor}`}>
              <item.icon className={`h-4 w-4 ${item.color}`} />
            </div>
            <span className="text-sm font-medium">{item.label}</span>
          </div>
          <span className="text-lg font-bold">{item.value}</span>
        </div>
      ))}
      
      {stats?.studyStreak && stats.studyStreak > 0 && (
        <div className="mt-4 p-3 bg-gradient-to-r from-primary-50 to-secondary-50 rounded-lg border">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <TrendingUp className="h-5 w-5 text-primary-600" />
              <span className="font-medium">Study Streak</span>
            </div>
            <Badge variant="default" className="text-sm">
              {stats.studyStreak} days
            </Badge>
          </div>
        </div>
      )}
    </div>
  );
}

