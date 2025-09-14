'use client';

import { useEffect, useRef } from 'react';
import { PaddleCheckoutData } from '@/types';

interface PaddleCheckoutProps {
  checkoutData: PaddleCheckoutData;
  onSuccess?: (data: any) => void;
  onError?: (error: any) => void;
  onClose?: () => void;
}

declare global {
  interface Window {
    Paddle: any;
  }
}

export function PaddleCheckout({ checkoutData, onSuccess, onError, onClose }: PaddleCheckoutProps) {
  const checkoutRef = useRef<HTMLDivElement>(null);
  const isInitialized = useRef(false);

  useEffect(() => {
    if (!checkoutData?.url || isInitialized.current) return;

    const initializePaddle = async () => {
      try {
        // Load Paddle SDK if not already loaded
        if (!window.Paddle) {
          const script = document.createElement('script');
          script.src = 'https://cdn.paddle.com/paddle/paddle.js';
          script.async = true;
          document.head.appendChild(script);

          await new Promise((resolve, reject) => {
            script.onload = resolve;
            script.onerror = reject;
          });
        }

        // Initialize Paddle
        if (window.Paddle) {
          window.Paddle.Setup({
            vendor: process.env.NEXT_PUBLIC_PADDLE_VENDOR_ID,
            environment: process.env.NEXT_PUBLIC_PADDLE_ENVIRONMENT || 'sandbox',
          });

          // Open checkout overlay
          window.Paddle.Checkout.open({
            override: checkoutData.url,
            eventCallback: (data: any) => {
              console.log('Paddle checkout event:', data);
              
              switch (data.name) {
                case 'checkout.completed':
                  onSuccess?.(data);
                  break;
                case 'checkout.closed':
                  onClose?.();
                  break;
                case 'checkout.error':
                  onError?.(data);
                  break;
              }
            },
          });

          isInitialized.current = true;
        }
      } catch (error) {
        console.error('Failed to initialize Paddle checkout:', error);
        onError?.(error);
      }
    };

    initializePaddle();

    // Cleanup function
    return () => {
      if (window.Paddle && window.Paddle.Checkout) {
        window.Paddle.Checkout.close();
      }
    };
  }, [checkoutData, onSuccess, onError, onClose]);

  return (
    <div ref={checkoutRef} className="paddle-checkout-container">
      {/* Paddle checkout will be rendered here */}
    </div>
  );
}

// Hook for managing Paddle checkout state
export function usePaddleCheckout() {
  const [isOpen, setIsOpen] = useState(false);
  const [checkoutData, setCheckoutData] = useState<PaddleCheckoutData | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const openCheckout = async (planId: string, billingCycle: 'monthly' | 'yearly') => {
    setIsLoading(true);
    try {
      // This would typically call your API to create a Paddle checkout
      const response = await fetch('/api/v1/billing/subscribe', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${localStorage.getItem('token')}`,
        },
        body: JSON.stringify({
          planId,
          billingCycle,
        }),
      });

      if (!response.ok) {
        throw new Error('Failed to create checkout');
      }

      const data = await response.json();
      setCheckoutData(data);
      setIsOpen(true);
    } catch (error) {
      console.error('Failed to open checkout:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const closeCheckout = () => {
    setIsOpen(false);
    setCheckoutData(null);
  };

  const handleSuccess = (data: any) => {
    console.log('Checkout completed:', data);
    closeCheckout();
    // Refresh the page or update state as needed
    window.location.reload();
  };

  const handleError = (error: any) => {
    console.error('Checkout error:', error);
    // Handle error (show notification, etc.)
  };

  return {
    isOpen,
    checkoutData,
    isLoading,
    openCheckout,
    closeCheckout,
    handleSuccess,
    handleError,
  };
}

// Import useState for the hook
import { useState } from 'react';
