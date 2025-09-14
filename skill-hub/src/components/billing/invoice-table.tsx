'use client';

import { Download, ExternalLink, Eye } from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Invoice } from '@/types';
import { cn } from '@/lib/utils';

interface InvoiceTableProps {
  invoices: Invoice[];
  isLoading?: boolean;
  onViewInvoice: (invoice: Invoice) => void;
}

export function InvoiceTable({ invoices, isLoading = false, onViewInvoice }: InvoiceTableProps) {
  const getStatusColor = (status: string) => {
    switch (status) {
      case 'paid':
        return 'bg-green-100 text-green-800 border-green-200';
      case 'open':
        return 'bg-yellow-100 text-yellow-800 border-yellow-200';
      case 'draft':
        return 'bg-gray-100 text-gray-800 border-gray-200';
      case 'void':
        return 'bg-red-100 text-red-800 border-red-200';
      case 'uncollectible':
        return 'bg-red-100 text-red-800 border-red-200';
      default:
        return 'bg-gray-100 text-gray-800 border-gray-200';
    }
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  const formatPrice = (amount: number, currency: string) => {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: currency.toUpperCase(),
    }).format(amount / 100); // Assuming amount is in cents
  };

  if (isLoading) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Invoices</CardTitle>
          <CardDescription>Your billing history</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {[...Array(5)].map((_, i) => (
              <div key={i} className="flex items-center justify-between p-4 border rounded-lg">
                <div className="space-y-2">
                  <div className="h-4 bg-gray-200 rounded animate-pulse w-32" />
                  <div className="h-3 bg-gray-200 rounded animate-pulse w-24" />
                </div>
                <div className="space-y-2">
                  <div className="h-4 bg-gray-200 rounded animate-pulse w-20" />
                  <div className="h-3 bg-gray-200 rounded animate-pulse w-16" />
                </div>
                <div className="h-8 bg-gray-200 rounded animate-pulse w-20" />
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    );
  }

  if (invoices.length === 0) {
    return (
      <Card>
        <CardHeader>
          <CardTitle>Invoices</CardTitle>
          <CardDescription>Your billing history</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="text-center py-8">
            <div className="text-gray-500 mb-2">No invoices found</div>
            <div className="text-sm text-gray-400">
              Your invoices will appear here once you have an active subscription.
            </div>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>Invoices</CardTitle>
        <CardDescription>Your billing history and payment records</CardDescription>
      </CardHeader>
      <CardContent>
        <div className="space-y-4">
          {invoices.map((invoice) => (
            <div
              key={invoice.id}
              className="flex items-center justify-between p-4 border rounded-lg hover:bg-gray-50 transition-colors"
            >
              <div className="flex-1">
                <div className="flex items-center gap-3">
                  <div>
                    <div className="font-medium text-gray-900">
                      {invoice.subscription.plan.name} Plan
                    </div>
                    <div className="text-sm text-gray-500">
                      {formatDate(invoice.createdAt)}
                    </div>
                  </div>
                  <Badge className={cn('px-2 py-1 text-xs', getStatusColor(invoice.status))}>
                    {invoice.status.toUpperCase()}
                  </Badge>
                </div>
              </div>

              <div className="flex items-center gap-4">
                <div className="text-right">
                  <div className="font-medium text-gray-900">
                    {formatPrice(invoice.amount, invoice.currency)}
                  </div>
                  <div className="text-sm text-gray-500">
                    Due {formatDate(invoice.dueDate)}
                  </div>
                </div>

                <div className="flex items-center gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => onViewInvoice(invoice)}
                  >
                    <Eye className="w-4 h-4 mr-1" />
                    View
                  </Button>

                  {invoice.invoiceUrl && (
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => window.open(invoice.invoiceUrl, '_blank')}
                    >
                      <ExternalLink className="w-4 h-4 mr-1" />
                      Open
                    </Button>
                  )}

                  {invoice.hostedInvoiceUrl && (
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => window.open(invoice.hostedInvoiceUrl, '_blank')}
                    >
                      <Download className="w-4 h-4 mr-1" />
                      Download
                    </Button>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}
