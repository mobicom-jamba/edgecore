import axios from 'axios';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || '/api/v1';

export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    if (typeof window !== 'undefined') {
      const token = localStorage.getItem('token');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401 && typeof window !== 'undefined') {
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// API endpoints
export const endpoints = {
  // Auth
  auth: {
    login: '/auth/login',
    register: '/auth/register',
    profile: '/auth/profile',
    refresh: '/auth/refresh',
    logout: '/auth/logout',
  },
  
  // Videos
  videos: {
    list: '/videos',
    create: '/videos',
    get: (id: string) => `/videos/${id}`,
    status: (id: string) => `/videos/${id}/status`,
    delete: (id: string) => `/videos/${id}`,
    dashboard: '/videos/dashboard',
  },
  
  // Learning
  learning: {
    reviewSession: '/videos/review/session',
    submitReview: '/videos/review/submit',
    completeReview: '/videos/review/complete',
  },
  
  // Admin
  admin: {
    users: '/admin/users',
    user: (id: string) => `/admin/users/${id}`,
    stats: '/admin/stats',
    analytics: '/admin/analytics/users',
    bulkUsers: '/admin/users/bulk',
  },
  
  // Billing
  billing: {
    plans: '/billing/plans',
    subscribe: '/billing/subscribe',
    subscription: '/billing/subscription',
    invoices: '/billing/invoices',
    invoice: (id: string) => `/billing/invoices/${id}`,
    usage: '/billing/usage',
    limits: '/billing/limits',
    paymentMethods: '/billing/payment-methods',
  },
};

// API service functions
export const apiService = {
  // Auth
  login: (email: string, password: string) =>
    api.post(endpoints.auth.login, { email, password }),
  
  register: (data: any) =>
    api.post(endpoints.auth.register, data),
  
  getProfile: () =>
    api.get(endpoints.auth.profile),
  
  logout: () =>
    api.post(endpoints.auth.logout),
  
  // Videos
  getVideos: (params?: any) =>
    api.get(endpoints.videos.list, { params }),
  
  createVideo: (data: any) =>
    api.post(endpoints.videos.create, data),
  
  getVideo: (id: string) =>
    api.get(endpoints.videos.get(id)),
  
  getVideoStatus: (id: string) =>
    api.get(endpoints.videos.status(id)),
  
  deleteVideo: (id: string) =>
    api.delete(endpoints.videos.delete(id)),
  
  getDashboard: () =>
    api.get(endpoints.videos.dashboard),
  
  // Learning
  getReviewSession: (limit?: number) =>
    api.get(endpoints.learning.reviewSession, { params: { limit } }),
  
  submitCardReview: (data: any) =>
    api.post(endpoints.learning.submitReview, data),
  
  completeReviewSession: (sessionId: string) =>
    api.post(endpoints.learning.completeReview, { sessionId }),
  
  // Admin
  getUsers: (params?: any) =>
    api.get(endpoints.admin.users, { params }),
  
  updateUser: (id: string, data: any) =>
    api.put(endpoints.admin.user(id), data),
  
  getAdminStats: () =>
    api.get(endpoints.admin.stats),
  
  getUserAnalytics: (params?: any) =>
    api.get(endpoints.admin.analytics, { params }),
  
  bulkUserOperation: (data: any) =>
    api.post(endpoints.admin.bulkUsers, data),
  
  // Billing
  getPlans: () =>
    api.get(endpoints.billing.plans),
  
  subscribe: (data: any) =>
    api.post(endpoints.billing.subscribe, data),
  
  getSubscription: () =>
    api.get(endpoints.billing.subscription),
  
  updateSubscription: (data: any) =>
    api.put(endpoints.billing.subscription, data),
  
  cancelSubscription: (data: any) =>
    api.delete(endpoints.billing.subscription, { data }),
  
  getInvoices: (params?: any) =>
    api.get(endpoints.billing.invoices, { params }),
  
  getInvoice: (id: string) =>
    api.get(endpoints.billing.invoice(id)),
  
  getUsage: (period?: string) =>
    api.get(endpoints.billing.usage, { params: { period } }),
  
  getLimits: () =>
    api.get(endpoints.billing.limits),
  
  getPaymentMethods: () =>
    api.get(endpoints.billing.paymentMethods),
  
  createPaymentMethod: (data: any) =>
    api.post(endpoints.billing.paymentMethods, data),
  
  deletePaymentMethod: (id: string) =>
    api.delete(`${endpoints.billing.paymentMethods}/${id}`),
};
