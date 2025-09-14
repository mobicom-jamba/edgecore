import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { apiService } from '@/lib/api';
import {
  SubscriptionPlan,
  Subscription,
  Invoice,
  UsageStats,
  PaddleCheckoutData,
  SubscribeFormData,
  UpdateSubscriptionFormData,
  ApiResponse,
  PaginatedResponse,
} from '@/types';

// Query Keys
export const billingKeys = {
  all: ['billing'] as const,
  plans: () => [...billingKeys.all, 'plans'] as const,
  subscription: () => [...billingKeys.all, 'subscription'] as const,
  invoices: (params?: any) => [...billingKeys.all, 'invoices', params] as const,
  usage: (period?: string) => [...billingKeys.all, 'usage', period] as const,
  limits: () => [...billingKeys.all, 'limits'] as const,
  paymentMethods: () => [...billingKeys.all, 'payment-methods'] as const,
};

// Hooks for fetching data
export const usePlans = () => {
  return useQuery({
    queryKey: billingKeys.plans(),
    queryFn: async (): Promise<SubscriptionPlan[]> => {
      const response = await apiService.getPlans();
      return response.data;
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

export const useSubscription = () => {
  return useQuery({
    queryKey: billingKeys.subscription(),
    queryFn: async (): Promise<Subscription | null> => {
      try {
        const response = await apiService.getSubscription();
        return response.data;
      } catch (error: any) {
        if (error.response?.status === 404) {
          return null; // No active subscription
        }
        throw error;
      }
    },
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useInvoices = (params?: { page?: number; limit?: number; status?: string }) => {
  return useQuery({
    queryKey: billingKeys.invoices(params),
    queryFn: async (): Promise<PaginatedResponse<Invoice>> => {
      const response = await apiService.getInvoices(params);
      return response.data;
    },
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useUsage = (period?: string) => {
  return useQuery({
    queryKey: billingKeys.usage(period),
    queryFn: async (): Promise<UsageStats> => {
      const response = await apiService.getUsage(period);
      return response.data;
    },
    staleTime: 1 * 60 * 1000, // 1 minute
  });
};

export const useLimits = () => {
  return useQuery({
    queryKey: billingKeys.limits(),
    queryFn: async (): Promise<SubscriptionPlan['limits']> => {
      const response = await apiService.getLimits();
      return response.data;
    },
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

// Mutation hooks
export const useSubscribe = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (data: SubscribeFormData): Promise<PaddleCheckoutData> => {
      const response = await apiService.subscribe(data);
      return response.data;
    },
    onSuccess: () => {
      // Invalidate subscription-related queries
      queryClient.invalidateQueries({ queryKey: billingKeys.subscription() });
      queryClient.invalidateQueries({ queryKey: billingKeys.usage() });
    },
  });
};

export const useUpdateSubscription = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (data: UpdateSubscriptionFormData): Promise<Subscription> => {
      const response = await apiService.updateSubscription(data);
      return response.data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: billingKeys.subscription() });
      queryClient.invalidateQueries({ queryKey: billingKeys.usage() });
    },
  });
};

export const useCancelSubscription = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (data: { reason?: string }): Promise<Subscription> => {
      const response = await apiService.cancelSubscription(data);
      return response.data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: billingKeys.subscription() });
      queryClient.invalidateQueries({ queryKey: billingKeys.usage() });
    },
  });
};

// Utility hooks
export const useBillingData = () => {
  const plans = usePlans();
  const subscription = useSubscription();
  const usage = useUsage();
  const limits = useLimits();

  return {
    plans,
    subscription,
    usage,
    limits,
    isLoading: plans.isLoading || subscription.isLoading || usage.isLoading || limits.isLoading,
    error: plans.error || subscription.error || usage.error || limits.error,
  };
};

export const useCurrentPlan = () => {
  const { data: subscription, ...rest } = useSubscription();
  
  return {
    currentPlan: subscription?.plan,
    subscription,
    ...rest,
  };
};

export const usePlanComparison = () => {
  const { data: plans, ...rest } = usePlans();
  const { data: currentPlan } = useCurrentPlan();

  const sortedPlans = plans?.sort((a, b) => a.sortOrder - b.sortOrder) || [];
  const freePlan = sortedPlans.find(plan => plan.type === 'free');
  const paidPlans = sortedPlans.filter(plan => plan.type !== 'free');

  return {
    plans: sortedPlans,
    freePlan,
    paidPlans,
    currentPlan,
    ...rest,
  };
};
