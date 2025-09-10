"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";

interface ProgressChartProps {
  data?: Record<string, number>;
}

export function ProgressChart({ data }: ProgressChartProps) {
  if (!data || Object.keys(data).length === 0) {
    return (
      <div className="text-center py-8">
        <div className="text-muted-foreground mb-2">No progress data available</div>
        <p className="text-sm text-muted-foreground">
          Start learning to see your progress here
        </p>
      </div>
    );
  }

  const entries = Object.entries(data).sort(([, a], [, b]) => b - a);

  return (
    <div className="space-y-4">
      {entries.map(([subject, progress]) => (
        <div key={subject} className="space-y-2">
          <div className="flex justify-between text-sm">
            <span className="font-medium capitalize">{subject}</span>
            <span className="text-muted-foreground">{progress}%</span>
          </div>
          <Progress value={progress} className="h-2" />
        </div>
      ))}
      
      {entries.length > 0 && (
        <div className="mt-4 pt-4 border-t">
          <div className="flex justify-between text-sm">
            <span className="font-medium">Overall Progress</span>
            <span className="text-muted-foreground">
              {Math.round(entries.reduce((sum, [, progress]) => sum + progress, 0) / entries.length)}%
            </span>
          </div>
          <Progress 
            value={Math.round(entries.reduce((sum, [, progress]) => sum + progress, 0) / entries.length)} 
            className="h-2 mt-2" 
          />
        </div>
      )}
    </div>
  );
}

