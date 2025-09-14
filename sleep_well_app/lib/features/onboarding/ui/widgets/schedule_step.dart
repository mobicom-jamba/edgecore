import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/buttons.dart';
import '../../data/providers/onboarding_providers.dart';

class ScheduleStep extends HookConsumerWidget {
  const ScheduleStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bedtime = ref.watch(bedtimeProvider);
    final wakeTime = ref.watch(wakeTimeProvider);
    final canProceed = ref.watch(canProceedProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'When do you sleep?',
            style: AppTheme.h1,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'Set your ideal bedtime and wake time',
            style: AppTheme.body,
          ),

          const SizedBox(height: AppTheme.spacing32),

          // Preset buttons
          Text(
            'Quick presets',
            style: AppTheme.title,
          ),
          const SizedBox(height: AppTheme.spacing16),

          Wrap(
            spacing: AppTheme.spacing12,
            runSpacing: AppTheme.spacing12,
            children: [
              _buildPresetButton(
                context,
                ref,
                'Early Bird',
                const TimeOfDay(hour: 21, minute: 30),
                const TimeOfDay(hour: 6, minute: 0),
              ),
              _buildPresetButton(
                context,
                ref,
                'Balanced',
                const TimeOfDay(hour: 22, minute: 30),
                const TimeOfDay(hour: 7, minute: 0),
              ),
              _buildPresetButton(
                context,
                ref,
                'Night Owl',
                const TimeOfDay(hour: 23, minute: 30),
                const TimeOfDay(hour: 8, minute: 0),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing32),

          // Custom time pickers
          Text(
            'Or set custom times',
            style: AppTheme.title,
          ),
          const SizedBox(height: AppTheme.spacing16),

          Row(
            children: [
              Expanded(
                child: _buildTimePicker(
                  context,
                  ref,
                  'Bedtime',
                  bedtime ?? const TimeOfDay(hour: 22, minute: 30),
                  (time) => _updateSchedule(ref, time, wakeTime),
                ),
              ),
              const SizedBox(width: AppTheme.spacing16),
              const Icon(
                Icons.arrow_forward,
                color: AppTheme.textSecondary,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: _buildTimePicker(
                  context,
                  ref,
                  'Wake up',
                  wakeTime ?? const TimeOfDay(hour: 7, minute: 0),
                  (time) => _updateSchedule(ref, bedtime, time),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.spacing32),

          // Sleep duration display
          if (bedtime != null && wakeTime != null) ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing16),
              decoration: BoxDecoration(
                color: AppTheme.accentPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.bedtime,
                    color: AppTheme.accentPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Text(
                    '${_calculateSleepDuration(bedtime, wakeTime)} of sleep planned',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.accentPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Add spacing instead of Spacer
          const SizedBox(height: 48),

          // Continue button
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Continue',
              onPressed: canProceed
                  ? () => ref.read(onboardingStateProvider.notifier).nextStep()
                  : null,
            ),
          ),

          // Add bottom padding for better UX
          const SizedBox(height: AppTheme.spacing20),
        ],
      ),
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    WidgetRef ref,
    String label,
    TimeOfDay bedtime,
    TimeOfDay wakeTime,
  ) {
    return OutlinedButton(
      onPressed: () => _updateSchedule(ref, bedtime, wakeTime),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing12,
        ),
        side: const BorderSide(color: AppTheme.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppTheme.spacing4),
          Text(
            '${_formatTime(bedtime)} - ${_formatTime(wakeTime)}',
            style: AppTheme.caption.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(
    BuildContext context,
    WidgetRef ref,
    String label,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeChanged,
  ) {
    return GestureDetector(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: initialTime,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  backgroundColor: AppTheme.surface,
                  hourMinuteTextColor: AppTheme.textPrimary,
                  dayPeriodTextColor: AppTheme.textSecondary,
                  dialHandColor: AppTheme.accentPrimary,
                  dialBackgroundColor: AppTheme.background,
                  entryModeIconColor: AppTheme.accentPrimary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (time != null) {
          onTimeChanged(time);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.divider),
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        ),
        child: Column(
          children: [
            Text(
              _formatTime(initialTime),
              style: AppTheme.h2.copyWith(
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              label,
              style: AppTheme.caption,
            ),
          ],
        ),
      ),
    );
  }

  void _updateSchedule(WidgetRef ref, TimeOfDay? bedtime, TimeOfDay? wakeTime) {
    if (bedtime != null && wakeTime != null) {
      ref.read(onboardingStateProvider.notifier).setSchedule(bedtime, wakeTime);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour =
        time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _calculateSleepDuration(TimeOfDay bedtime, TimeOfDay wakeTime) {
    final bedtimeDateTime = DateTime(2024, 1, 1, bedtime.hour, bedtime.minute);
    final wakeDateTime = DateTime(2024, 1, 1, wakeTime.hour, wakeTime.minute);

    Duration sleepDuration;
    if (wakeDateTime.isAfter(bedtimeDateTime)) {
      sleepDuration = wakeDateTime.difference(bedtimeDateTime);
    } else {
      sleepDuration =
          wakeDateTime.add(const Duration(days: 1)).difference(bedtimeDateTime);
    }

    final hours = sleepDuration.inHours;
    final minutes = sleepDuration.inMinutes % 60;

    if (minutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h ${minutes}m';
    }
  }
}
