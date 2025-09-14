'use client';

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Progress } from '@/components/ui/progress';
import { UsageStats } from '@/types';
import { cn } from '@/lib/utils';

interface UsageCardProps {
  title: string;
  current: number;
  limit: number;
  unit: string;
  percentage: number;
  color?: 'blue' | 'green' | 'yellow' | 'red';
}

export function UsageCard({
  title,
  current,
  limit,
  unit,
  percentage,
  color = 'blue',
}: UsageCardProps) {
  const colorClasses = {
    blue: 'text-blue-600 bg-blue-50',
    green: 'text-green-600 bg-green-50',
    yellow: 'text-yellow-600 bg-yellow-50',
    red: 'text-red-600 bg-red-50',
  };

  const progressColor = {
    blue: 'bg-blue-500',
    green: 'bg-green-500',
    yellow: 'bg-yellow-500',
    red: 'bg-red-500',
  };

  const formatValue = (value: number, unit: string) => {
    if (unit === 'bytes') {
      const gb = value / (1024 * 1024 * 1024);
      if (gb >= 1) return `${gb.toFixed(1)} GB`;
      const mb = value / (1024 * 1024);
      return `${mb.toFixed(1)} MB`;
    }
    if (unit === 'files' || unit === 'requests' || unit === 'members') {
      return value.toLocaleString();
    }
    return `${value} ${unit}`;
  };

  const isNearLimit = percentage >= 80;
  const isOverLimit = percentage >= 100;

  return (
    <Card className="w-full">
      <CardHeader className="pb-3">
        <CardTitle className="text-lg font-medium">{title}</CardTitle>
        <CardDescription>
          {formatValue(current, unit)} of {limit === -1 ? 'Unlimited' : formatValue(limit, unit)}
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-3">
        <div className="space-y-2">
          <div className="flex justify-between text-sm">
            <span className="text-gray-600">Usage</span>
            <span className={cn(
              'font-medium',
              isOverLimit && 'text-red-600',
              isNearLimit && !isOverLimit && 'text-yellow-600',
              !isNearLimit && 'text-gray-900'
            )}>
              {percentage.toFixed(1)}%
            </span>
          </div>
          <Progress
            value={Math.min(percentage, 100)}
            className="h-2"
            style={{
              '--progress-background': progressColor[color],
            } as React.CSSProperties}
          />
        </div>
        
        {isOverLimit && (
          <div className="text-sm text-red-600 bg-red-50 p-2 rounded-md">
            ⚠️ You've exceeded your limit. Consider upgrading your plan.
          </div>
        )}
        
        {isNearLimit && !isOverLimit && (
          <div className="text-sm text-yellow-600 bg-yellow-50 p-2 rounded-md">
            ⚠️ You're approaching your limit ({percentage.toFixed(1)}% used).
          </div>
        )}
      </CardContent>
    </Card>
  );
}

interface UsageOverviewProps {
  usage: UsageStats;
  isLoading?: boolean;
}

export function UsageOverview({ usage, isLoading = false }: UsageOverviewProps) {
  if (isLoading) {
    return (
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {[...Array(4)].map((_, i) => (
          <Card key={i} className="w-full">
            <CardHeader className="pb-3">
              <div className="h-4 bg-gray-200 rounded animate-pulse" />
              <div className="h-3 bg-gray-200 rounded animate-pulse w-2/3" />
            </CardHeader>
            <CardContent className="space-y-3">
              <div className="h-2 bg-gray-200 rounded animate-pulse" />
            </CardContent>
          </Card>
        ))}
      </div>
    );
  }

  const usageCards = [
    {
      title: 'Files Uploaded',
      current: usage.filesUploaded,
      limit: usage.limits.maxFiles,
      unit: 'files',
      percentage: usage.usagePercentages.files,
      color: 'blue' as const,
    },
    {
      title: 'Storage Used',
      current: usage.storageUsed,
      limit: usage.limits.maxStorage,
      unit: 'bytes',
      percentage: usage.usagePercentages.storage,
      color: 'green' as const,
    },
    {
      title: 'API Requests',
      current: usage.apiRequests,
      limit: usage.limits.maxApiRequests,
      unit: 'requests',
      percentage: usage.usagePercentages.apiRequests,
      color: 'yellow' as const,
    },
    {
      title: 'Team Members',
      current: usage.teamMembers,
      limit: usage.limits.maxTeamMembers,
      unit: 'members',
      percentage: usage.usagePercentages.teamMembers,
      color: 'red' as const,
    },
  ];

  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
      {usageCards.map((card) => (
        <UsageCard key={card.title} {...card} />
      ))}
    </div>
  );
}
