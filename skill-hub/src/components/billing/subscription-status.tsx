'use client';

import { Calendar, CreditCard, Settings, AlertCircle, CheckCircle, Pause, XCircle } from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Subscription } from '@/types';
import { cn } from '@/lib/utils';

interface SubscriptionStatusProps {
  subscription: Subscription;
  onManage: () => void;
  onCancel: () => void;
  isLoading?: boolean;
}

export function SubscriptionStatus({
  subscription,
  onManage,
  onCancel,
  isLoading = false,
}: SubscriptionStatusProps) {
  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'active':
        return <CheckCircle className="w-5 h-5 text-green-500" />;
      case 'trialing':
        return <Calendar className="w-5 h-5 text-blue-500" />;
      case 'past_due':
        return <AlertCircle className="w-5 h-5 text-red-500" />;
      case 'paused':
        return <Pause className="w-5 h-5 text-yellow-500" />;
      case 'canceled':
        return <XCircle className="w-5 h-5 text-gray-500" />;
      default:
        return <AlertCircle className="w-5 h-5 text-gray-500" />;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active':
        return 'bg-green-100 text-green-800 border-green-200';
      case 'trialing':
        return 'bg-blue-100 text-blue-800 border-blue-200';
      case 'past_due':
        return 'bg-red-100 text-red-800 border-red-200';
      case 'paused':
        return 'bg-yellow-100 text-yellow-800 border-yellow-200';
      case 'canceled':
        return 'bg-gray-100 text-gray-800 border-gray-200';
      default:
        return 'bg-gray-100 text-gray-800 border-gray-200';
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  };

  const formatPrice = (amount: number) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
    }).format(amount);
  };

  const isActive = subscription.status === 'active' || subscription.status === 'trialing';
  const isCanceled = subscription.status === 'canceled';
  const isPastDue = subscription.status === 'past_due';

  return (
    <Card className="w-full">
      <CardHeader>
        <div className="flex items-center justify-between">
          <div>
            <CardTitle className="text-xl font-semibold">
              {subscription.plan.name} Plan
            </CardTitle>
            <CardDescription className="mt-1">
              {subscription.plan.description}
            </CardDescription>
          </div>
          <Badge className={cn('px-3 py-1', getStatusColor(subscription.status))}>
            <div className="flex items-center gap-1">
              {getStatusIcon(subscription.status)}
              <span className="capitalize">{subscription.status.replace('_', ' ')}</span>
            </div>
          </Badge>
        </div>
      </CardHeader>

      <CardContent className="space-y-6">
        {/* Pricing Information */}
        <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
          <div>
            <div className="text-2xl font-bold text-gray-900">
              {formatPrice(subscription.plan.price)}
            </div>
            <div className="text-sm text-gray-600">
              per {subscription.plan.billingCycle}
            </div>
          </div>
          <div className="text-right">
            <div className="text-sm text-gray-600">Next billing</div>
            <div className="font-medium">
              {formatDate(subscription.currentPeriodEnd)}
            </div>
          </div>
        </div>

        {/* Subscription Details */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="space-y-2">
            <div className="text-sm font-medium text-gray-700">Current Period</div>
            <div className="text-sm text-gray-600">
              {formatDate(subscription.currentPeriodStart)} - {formatDate(subscription.currentPeriodEnd)}
            </div>
          </div>
          
          <div className="space-y-2">
            <div className="text-sm font-medium text-gray-700">Plan Type</div>
            <div className="text-sm text-gray-600 capitalize">
              {subscription.plan.type}
            </div>
          </div>

          {subscription.trialStart && subscription.trialEnd && (
            <>
              <div className="space-y-2">
                <div className="text-sm font-medium text-gray-700">Trial Period</div>
                <div className="text-sm text-gray-600">
                  {formatDate(subscription.trialStart)} - {formatDate(subscription.trialEnd)}
                </div>
              </div>
            </>
          )}

          {subscription.canceledAt && (
            <div className="space-y-2">
              <div className="text-sm font-medium text-gray-700">Canceled On</div>
              <div className="text-sm text-gray-600">
                {formatDate(subscription.canceledAt)}
              </div>
            </div>
          )}
        </div>

        {/* Status Messages */}
        {isPastDue && (
          <div className="p-4 bg-red-50 border border-red-200 rounded-lg">
            <div className="flex items-center gap-2 text-red-800">
              <AlertCircle className="w-5 h-5" />
              <span className="font-medium">Payment Required</span>
            </div>
            <p className="text-sm text-red-700 mt-1">
              Your subscription is past due. Please update your payment method to continue using the service.
            </p>
          </div>
        )}

        {subscription.cancelAtPeriodEnd && !isCanceled && (
          <div className="p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
            <div className="flex items-center gap-2 text-yellow-800">
              <AlertCircle className="w-5 h-5" />
              <span className="font-medium">Scheduled for Cancellation</span>
            </div>
            <p className="text-sm text-yellow-700 mt-1">
              Your subscription will be canceled on {formatDate(subscription.currentPeriodEnd)}.
            </p>
          </div>
        )}

        {/* Action Buttons */}
        <div className="flex flex-col sm:flex-row gap-3 pt-4 border-t border-gray-200">
          <Button
            onClick={onManage}
            disabled={isLoading}
            className="flex-1"
            variant="outline"
          >
            <Settings className="w-4 h-4 mr-2" />
            Manage Subscription
          </Button>
          
          {isActive && !subscription.cancelAtPeriodEnd && (
            <Button
              onClick={onCancel}
              disabled={isLoading}
              variant="destructive"
              className="flex-1"
            >
              <XCircle className="w-4 h-4 mr-2" />
              Cancel Subscription
            </Button>
          )}
        </div>
      </CardContent>
    </Card>
  );
}
