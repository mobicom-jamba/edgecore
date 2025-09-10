import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";
import { Providers } from "@/components/providers";
import { Toaster } from "react-hot-toast";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "Skill Hub - YouTube Learning Platform",
  description: "Transform YouTube videos into structured, interactive learning experiences with AI-powered content analysis and spaced repetition.",
  keywords: ["learning", "education", "youtube", "ai", "spaced repetition", "knowledge extraction"],
  authors: [{ name: "Skill Hub Team" }],
  openGraph: {
    title: "Skill Hub - YouTube Learning Platform",
    description: "Transform YouTube videos into structured, interactive learning experiences",
    type: "website",
    locale: "en_US",
  },
  twitter: {
    card: "summary_large_image",
    title: "Skill Hub - YouTube Learning Platform",
    description: "Transform YouTube videos into structured, interactive learning experiences",
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={inter.className}>
        <Providers>
          {children}
          <Toaster
            position="top-right"
            toastOptions={{
              duration: 4000,
              style: {
                background: '#363636',
                color: '#fff',
              },
              success: {
                duration: 3000,
                iconTheme: {
                  primary: '#22c55e',
                  secondary: '#fff',
                },
              },
              error: {
                duration: 5000,
                iconTheme: {
                  primary: '#ef4444',
                  secondary: '#fff',
                },
              },
            }}
          />
        </Providers>
      </body>
    </html>
  );
}