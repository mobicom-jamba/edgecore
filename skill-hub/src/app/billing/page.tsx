"use client";

import { useState } from "react";
import { CreditCard, FileText, BarChart3, Settings } from "lucide-react";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { PlanCard } from "@/components/billing/plan-card";
import { UsageOverview } from "@/components/billing/usage-card";
import { SubscriptionStatus } from "@/components/billing/subscription-status";
import { InvoiceTable } from "@/components/billing/invoice-table";
import { Navigation } from "@/components/navigation";
import {
  useBillingData,
  useSubscribe,
  useCancelSubscription,
} from "@/hooks/useBilling";
import { SubscriptionPlan, Invoice } from "@/types";

export default function BillingPage() {
  const [selectedPlan, setSelectedPlan] = useState<SubscriptionPlan | null>(
    null
  );
  const [billingCycle, setBillingCycle] = useState<"monthly" | "yearly">(
    "monthly"
  );
  const [activeTab, setActiveTab] = useState<"overview" | "plans" | "invoices">(
    "overview"
  );

  const { plans, subscription, usage, limits, isLoading, error } =
    useBillingData();
  const subscriptionData = subscription?.data;
  const usageData = usage?.data;
  const subscribeMutation = useSubscribe();
  const cancelMutation = useCancelSubscription();

  const handlePlanSelect = async (plan: SubscriptionPlan) => {
    setSelectedPlan(plan);

    try {
      const checkoutData = await subscribeMutation.mutateAsync({
        planId: plan.id,
        billingCycle,
      });

      // Redirect to Paddle checkout
      if (checkoutData.url) {
        window.location.href = checkoutData.url;
      }
    } catch (error) {
      console.error("Failed to subscribe:", error);
    }
  };

  const handleManageSubscription = () => {
    // TODO: Implement subscription management
    console.log("Manage subscription");
  };

  const handleCancelSubscription = async () => {
    if (confirm("Are you sure you want to cancel your subscription?")) {
      try {
        await cancelMutation.mutateAsync({
          reason: "User requested cancellation",
        });
      } catch (error) {
        console.error("Failed to cancel subscription:", error);
      }
    }
  };

  const handleViewInvoice = (invoice: Invoice) => {
    // TODO: Implement invoice viewing
    console.log("View invoice:", invoice);
  };

  if (error) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">
            Billing Error
          </h1>
          <p className="text-gray-600 mb-4">
            There was an error loading your billing information.
          </p>
          <Button onClick={() => window.location.reload()}>Try Again</Button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-gray-100">
      <Navigation />
      <div className="container mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Billing & Subscription
          </h1>
          <p className="text-gray-600">
            Manage your subscription, view usage, and access billing
            information.
          </p>
        </div>

        {/* Tab Navigation */}
        <div className="mb-8">
          <div className="border-b border-gray-200">
            <nav className="-mb-px flex space-x-8">
              {[
                { id: "overview", label: "Overview", icon: BarChart3 },
                { id: "plans", label: "Plans", icon: CreditCard },
                { id: "invoices", label: "Invoices", icon: FileText },
              ].map((tab) => {
                const Icon = tab.icon;
                return (
                  <button
                    key={tab.id}
                    onClick={() => setActiveTab(tab.id as any)}
                    className={`
                    flex items-center gap-2 py-2 px-1 border-b-2 font-medium text-sm
                    ${
                      activeTab === tab.id
                        ? "border-blue-500 text-blue-600"
                        : "border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300"
                    }
                  `}
                  >
                    <Icon className="w-4 h-4" />
                    {tab.label}
                  </button>
                );
              })}
            </nav>
          </div>
        </div>

        {/* Overview Tab */}
        {activeTab === "overview" && (
          <div className="space-y-8">
            {/* Current Subscription */}
            {subscriptionData && (
              <SubscriptionStatus
                subscription={subscriptionData}
                onManage={handleManageSubscription}
                onCancel={handleCancelSubscription}
                isLoading={cancelMutation.isPending}
              />
            )}

            {/* Usage Overview */}
            {usageData && (
              <div>
                <h2 className="text-xl font-semibold text-gray-900 mb-4">
                  Usage Overview
                </h2>
                <UsageOverview usage={usageData} isLoading={isLoading} />
              </div>
            )}

            {/* Quick Actions */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Settings className="w-5 h-5" />
                  Quick Actions
                </CardTitle>
                <CardDescription>
                  Manage your subscription and billing preferences
                </CardDescription>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                  <Button
                    variant="outline"
                    className="h-20 flex flex-col items-center justify-center gap-2"
                    onClick={() => setActiveTab("plans")}
                  >
                    <CreditCard className="w-6 h-6" />
                    <span>Change Plan</span>
                  </Button>
                  <Button
                    variant="outline"
                    className="h-20 flex flex-col items-center justify-center gap-2"
                    onClick={() => setActiveTab("invoices")}
                  >
                    <FileText className="w-6 h-6" />
                    <span>View Invoices</span>
                  </Button>
                  <Button
                    variant="outline"
                    className="h-20 flex flex-col items-center justify-center gap-2"
                    onClick={handleManageSubscription}
                  >
                    <Settings className="w-6 h-6" />
                    <span>Manage Subscription</span>
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>
        )}

        {/* Plans Tab */}
        {activeTab === "plans" && (
          <div className="space-y-8">
            {/* Billing Cycle Toggle */}
            <div className="flex items-center justify-center">
              <div className="bg-gray-100 p-1 rounded-lg">
                <button
                  onClick={() => setBillingCycle("monthly")}
                  className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                    billingCycle === "monthly"
                      ? "bg-white text-gray-900 shadow-sm"
                      : "text-gray-500 hover:text-gray-700"
                  }`}
                >
                  Monthly
                </button>
                <button
                  onClick={() => setBillingCycle("yearly")}
                  className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                    billingCycle === "yearly"
                      ? "bg-white text-gray-900 shadow-sm"
                      : "text-gray-500 hover:text-gray-700"
                  }`}
                >
                  Yearly
                  <Badge className="ml-2 bg-green-500 text-white text-xs">
                    Save 20%
                  </Badge>
                </button>
              </div>
            </div>

            {/* Plans Grid */}
            {plans?.data && (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                {plans.data.map((plan: SubscriptionPlan) => (
                  <PlanCard
                    key={plan.id}
                    plan={plan}
                    currentPlan={subscriptionData ?? undefined}
                    onSelect={handlePlanSelect}
                    isSelected={selectedPlan?.id === plan.id}
                    isLoading={subscribeMutation.isPending}
                    billingCycle={billingCycle}
                  />
                ))}
              </div>
            )}
          </div>
        )}

        {/* Invoices Tab */}
        {activeTab === "invoices" && (
          <InvoiceTable
            invoices={[]} // TODO: Get invoices from API
            isLoading={isLoading}
            onViewInvoice={handleViewInvoice}
          />
        )}
      </div>
    </div>
  );
}
