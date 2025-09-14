'use client';

import { Check, Star, Zap } from 'lucide-react';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { SubscriptionPlan, Subscription } from '@/types';
import { cn } from '@/lib/utils';

interface PlanCardProps {
  plan: SubscriptionPlan;
  currentPlan?: Subscription;
  onSelect: (plan: SubscriptionPlan) => void;
  isSelected?: boolean;
  isLoading?: boolean;
  billingCycle?: 'monthly' | 'yearly';
}

export function PlanCard({
  plan,
  currentPlan,
  onSelect,
  isSelected = false,
  isLoading = false,
  billingCycle = 'monthly',
}: PlanCardProps) {
  const isCurrentPlan = currentPlan?.planId === plan.id;
  const isPopular = plan.isPopular;
  const isFree = plan.type === 'free';
  
  const price = billingCycle === 'yearly' ? plan.price * 12 * 0.8 : plan.price; // 20% discount for yearly
  const originalPrice = billingCycle === 'yearly' ? plan.price * 12 : plan.price;
  const hasDiscount = billingCycle === 'yearly' && !isFree;

  const formatPrice = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const formatStorage = (bytes: number) => {
    const gb = bytes / (1024 * 1024 * 1024);
    return gb >= 1 ? `${gb.toFixed(0)}GB` : `${(bytes / (1024 * 1024)).toFixed(0)}MB`;
  };

  const getFeatureValue = (key: string) => {
    const value = plan.features[key];
    if (typeof value === 'number') {
      if (key.includes('storage')) return formatStorage(value);
      if (key.includes('files')) return value.toLocaleString();
      if (key.includes('requests')) return value.toLocaleString();
      if (key.includes('members')) return value.toString();
      return value.toString();
    }
    return value;
  };

  return (
    <Card
      className={cn(
        'relative transition-all duration-200 hover:shadow-lg',
        isSelected && 'ring-2 ring-blue-500 shadow-lg',
        isPopular && 'border-blue-500 shadow-md',
        isCurrentPlan && 'border-green-500 bg-green-50/50'
      )}
    >
      {isPopular && (
        <div className="absolute -top-3 left-1/2 transform -translate-x-1/2">
          <Badge className="bg-blue-500 text-white px-3 py-1">
            <Star className="w-3 h-3 mr-1" />
            Most Popular
          </Badge>
        </div>
      )}

      {isCurrentPlan && (
        <div className="absolute -top-3 right-4">
          <Badge className="bg-green-500 text-white px-3 py-1">
            Current Plan
          </Badge>
        </div>
      )}

      <CardHeader className="text-center pb-4">
        <CardTitle className="text-2xl font-bold">{plan.name}</CardTitle>
        <CardDescription className="text-gray-600">
          {plan.description}
        </CardDescription>
        
        <div className="mt-4">
          {isFree ? (
            <div className="text-4xl font-bold text-gray-900">Free</div>
          ) : (
            <div className="space-y-1">
              <div className="flex items-center justify-center gap-2">
                <span className="text-4xl font-bold text-gray-900">
                  {formatPrice(price)}
                </span>
                {hasDiscount && (
                  <span className="text-lg text-gray-500 line-through">
                    {formatPrice(originalPrice)}
                  </span>
                )}
              </div>
              <div className="text-sm text-gray-600">
                per {billingCycle === 'yearly' ? 'year' : 'month'}
                {hasDiscount && (
                  <span className="ml-2 text-green-600 font-medium">
                    Save 20%
                  </span>
                )}
              </div>
            </div>
          )}
        </div>
      </CardHeader>

      <CardContent className="space-y-4">
        <div className="space-y-3">
          {Object.entries(plan.features).map(([key, value]) => (
            <div key={key} className="flex items-center gap-3">
              <Check className="w-4 h-4 text-green-500 flex-shrink-0" />
              <span className="text-sm text-gray-700">
                <span className="font-medium">{getFeatureValue(key)}</span>
                <span className="text-gray-500 ml-1">
                  {key.replace(/([A-Z])/g, ' $1').toLowerCase()}
                </span>
              </span>
            </div>
          ))}
        </div>

        <div className="pt-4 border-t border-gray-200">
          <div className="grid grid-cols-2 gap-4 text-sm">
            <div>
              <div className="text-gray-500">Files</div>
              <div className="font-medium">
                {plan.limits.maxFiles === -1 ? 'Unlimited' : plan.limits.maxFiles.toLocaleString()}
              </div>
            </div>
            <div>
              <div className="text-gray-500">Storage</div>
              <div className="font-medium">
                {formatStorage(plan.limits.maxStorage)}
              </div>
            </div>
            <div>
              <div className="text-gray-500">API Requests</div>
              <div className="font-medium">
                {plan.limits.maxApiRequests === -1 ? 'Unlimited' : plan.limits.maxApiRequests.toLocaleString()}
              </div>
            </div>
            <div>
              <div className="text-gray-500">Team Members</div>
              <div className="font-medium">
                {plan.limits.maxTeamMembers === -1 ? 'Unlimited' : plan.limits.maxTeamMembers}
              </div>
            </div>
          </div>
        </div>
      </CardContent>

      <CardFooter>
        <Button
          onClick={() => onSelect(plan)}
          disabled={isLoading || isCurrentPlan}
          className={cn(
            'w-full',
            isCurrentPlan && 'bg-green-500 hover:bg-green-600',
            isPopular && !isCurrentPlan && 'bg-blue-500 hover:bg-blue-600'
          )}
        >
          {isLoading ? (
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
              Processing...
            </div>
          ) : isCurrentPlan ? (
            <div className="flex items-center gap-2">
              <Check className="w-4 h-4" />
              Current Plan
            </div>
          ) : isFree ? (
            'Get Started'
          ) : (
            <div className="flex items-center gap-2">
              <Zap className="w-4 h-4" />
              Choose Plan
            </div>
          )}
        </Button>
      </CardFooter>
    </Card>
  );
}
