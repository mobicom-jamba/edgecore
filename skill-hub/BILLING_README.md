# Billing Integration - Frontend Implementation

This document describes the billing integration implementation in the Skill Hub frontend.

## Overview

The billing system integrates with Paddle for payment processing and subscription management. The frontend provides a comprehensive billing interface with subscription management, usage tracking, and invoice management.

## Components

### 1. Types (`src/types/index.ts`)
- Complete TypeScript type definitions for billing data structures
- Includes subscription plans, invoices, usage stats, and Paddle integration types
- Form types for subscription management

### 2. Hooks (`src/hooks/useBilling.ts`)
- React Query hooks for billing data management
- `usePlans()` - Fetch available subscription plans
- `useSubscription()` - Get current user subscription
- `useInvoices()` - Fetch billing history
- `useUsage()` - Get usage statistics
- `useSubscribe()` - Subscribe to a plan
- `useUpdateSubscription()` - Modify subscription
- `useCancelSubscription()` - Cancel subscription

### 3. Components

#### Plan Card (`src/components/billing/plan-card.tsx`)
- Displays subscription plan details
- Shows pricing, features, and limits
- Handles plan selection and billing cycle toggle
- Visual indicators for popular plans and current plan

#### Usage Card (`src/components/billing/usage-card.tsx`)
- Displays usage statistics with progress bars
- Shows limits and usage percentages
- Color-coded warnings for approaching limits
- Responsive grid layout for multiple usage metrics

#### Subscription Status (`src/components/billing/subscription-status.tsx`)
- Shows current subscription details
- Displays billing information and next payment date
- Status indicators and management actions
- Handles subscription cancellation

#### Invoice Table (`src/components/billing/invoice-table.tsx`)
- Lists billing history and invoices
- Download and view invoice actions
- Status indicators for payment status
- Responsive table design

#### Paddle Checkout (`src/components/billing/paddle-checkout.tsx`)
- Integrates Paddle checkout overlay
- Handles checkout events and callbacks
- Custom hook for checkout state management

### 4. Pages

#### Billing Page (`src/app/billing/page.tsx`)
- Main billing dashboard with tabbed interface
- Overview, Plans, and Invoices tabs
- Quick actions and subscription management
- Responsive design with navigation

#### Dashboard Integration
- Added billing quick action card
- Navigation integration
- Billing link in main navigation

## Features

### Subscription Management
- View current subscription status
- Change subscription plans
- Cancel subscriptions
- Billing cycle management (monthly/yearly)

### Usage Tracking
- Real-time usage statistics
- Visual progress indicators
- Limit warnings and notifications
- Multiple metric tracking (files, storage, API requests, team members)

### Invoice Management
- View billing history
- Download invoices
- Payment status tracking
- Invoice details and management

### Paddle Integration
- Secure checkout process
- Webhook handling for payment events
- Subscription lifecycle management
- Multiple payment methods support

## API Integration

The frontend integrates with the following backend endpoints:

- `GET /api/v1/billing/plans` - Get subscription plans
- `POST /api/v1/billing/subscribe` - Subscribe to plan
- `GET /api/v1/billing/subscription` - Get current subscription
- `PUT /api/v1/billing/subscription` - Update subscription
- `DELETE /api/v1/billing/subscription` - Cancel subscription
- `GET /api/v1/billing/invoices` - Get billing history
- `GET /api/v1/billing/usage` - Get usage statistics
- `GET /api/v1/billing/limits` - Get plan limits

## Environment Configuration

Required environment variables:

```env
NEXT_PUBLIC_API_URL=http://localhost:3001/api/v1
NEXT_PUBLIC_PADDLE_VENDOR_ID=your-paddle-vendor-id
NEXT_PUBLIC_PADDLE_ENVIRONMENT=sandbox
```

## Usage

### Basic Setup
1. Configure environment variables
2. Ensure backend billing endpoints are available
3. Import and use billing components

### Example Usage
```tsx
import { useBillingData } from '@/hooks/useBilling';
import { PlanCard } from '@/components/billing/plan-card';

function BillingPage() {
  const { plans, subscription, usage, isLoading } = useBillingData();
  
  return (
    <div>
      {plans?.map(plan => (
        <PlanCard
          key={plan.id}
          plan={plan}
          currentPlan={subscription}
          onSelect={handlePlanSelect}
        />
      ))}
    </div>
  );
}
```

## Styling

The billing components use Tailwind CSS with a consistent design system:
- Card-based layouts with subtle shadows
- Color-coded status indicators
- Responsive grid layouts
- Hover effects and transitions
- Consistent spacing and typography

## Error Handling

- Comprehensive error states for all API calls
- Loading states and skeleton components
- User-friendly error messages
- Retry mechanisms for failed requests

## Security

- JWT token authentication for all API calls
- Secure Paddle checkout integration
- Input validation and sanitization
- CSRF protection through API tokens

## Testing

The billing system includes:
- Type safety with TypeScript
- Error boundary handling
- Loading state management
- Responsive design testing
- API integration testing

## Future Enhancements

- Payment method management
- Subscription analytics
- Usage alerts and notifications
- Bulk operations for enterprise users
- Advanced reporting and insights
