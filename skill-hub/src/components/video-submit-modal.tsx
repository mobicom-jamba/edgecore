"use client";

import { useState } from 'react';
import { X, Youtube, Loader2, BookOpen } from 'lucide-react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { apiService } from '@/lib/api';
import { extractYouTubeVideoId } from '@/lib/utils';
import toast from 'react-hot-toast';

const videoSubmitSchema = z.object({
  youtubeUrl: z.string().url('Invalid URL').refine(
    (url) => extractYouTubeVideoId(url) !== null,
    'Please enter a valid YouTube URL'
  ),
  learningObjectives: z.string().optional(),
});

type VideoSubmitForm = z.infer<typeof videoSubmitSchema>;

interface VideoSubmitModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export function VideoSubmitModal({ isOpen, onClose }: VideoSubmitModalProps) {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { register, handleSubmit, reset, formState: { errors } } = useForm<VideoSubmitForm>({
    resolver: zodResolver(videoSubmitSchema),
  });

  const onSubmit = async (data: VideoSubmitForm) => {
    setIsSubmitting(true);
    try {
      const objectives = data.learningObjectives
        ? data.learningObjectives.split('\n').filter(obj => obj.trim())
        : [];

      await apiService.createVideo({
        youtubeUrl: data.youtubeUrl,
        learningObjectives: objectives,
      });

      toast.success('Video submitted for processing!');
      reset();
      onClose();
    } catch (error: any) {
      const message = error.response?.data?.message || 'Failed to submit video';
      toast.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="flex min-h-screen items-center justify-center p-4">
        <div className="fixed inset-0 bg-black/50" onClick={onClose} />
        
        <Card className="relative w-full max-w-md shadow-xl">
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-4">
            <div className="flex items-center gap-3">
              <div className="p-2 bg-red-100 rounded-lg">
                <Youtube className="h-6 w-6 text-red-600" />
              </div>
              <div>
                <CardTitle>Add YouTube Video</CardTitle>
                <CardDescription>Transform videos into learning content</CardDescription>
              </div>
            </div>
            <Button
              variant="ghost"
              size="icon"
              onClick={onClose}
              className="h-8 w-8"
            >
              <X className="h-4 w-4" />
            </Button>
          </CardHeader>

          <CardContent>
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
              <div className="space-y-2">
                <label htmlFor="youtubeUrl" className="text-sm font-medium">
                  YouTube URL *
                </label>
                <Input
                  id="youtubeUrl"
                  type="url"
                  placeholder="https://www.youtube.com/watch?v=..."
                  {...register('youtubeUrl')}
                />
                {errors.youtubeUrl && (
                  <p className="text-sm text-destructive">{errors.youtubeUrl.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <label htmlFor="learningObjectives" className="text-sm font-medium">
                  Learning Objectives (Optional)
                </label>
                <textarea
                  id="learningObjectives"
                  placeholder="What do you want to learn from this video?&#10;Enter one objective per line"
                  rows={4}
                  className="flex w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 resize-none"
                  {...register('learningObjectives')}
                />
                <p className="text-xs text-muted-foreground">
                  Enter your learning goals to help personalize the content extraction
                </p>
              </div>

              <div className="flex gap-3 pt-4">
                <Button
                  type="button"
                  variant="outline"
                  className="flex-1"
                  onClick={onClose}
                  disabled={isSubmitting}
                >
                  Cancel
                </Button>
                <Button
                  type="submit"
                  className="flex-1"
                  disabled={isSubmitting}
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Processing...
                    </>
                  ) : (
                    <>
                      <BookOpen className="mr-2 h-4 w-4" />
                      Add Video
                    </>
                  )}
                </Button>
              </div>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
