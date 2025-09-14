import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/modals.dart';
import '../../../core/database/database.dart';
import '../data/providers/wind_down_providers.dart';
import '../data/models/ritual_log.dart';

class WindDownScreen extends HookConsumerWidget {
  const WindDownScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rituals = ref.watch(selectedRitualsProvider);
    final currentRitualIndex = ref.watch(currentRitualIndexProvider);
    final isCompleted = ref.watch(windDownCompletedProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wind Down'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: isCompleted
            ? _buildCompletedView(context, ref)
            : _buildRitualView(context, ref, rituals.value ?? [], currentRitualIndex),
      ),
    );
  }
  
  Widget _buildRitualView(
    BuildContext context,
    WidgetRef ref,
    List<RitualType> rituals,
    int currentIndex,
  ) {
    if (rituals.isEmpty) {
      return _buildEmptyState(context);
    }
    
    final currentRitual = rituals[currentIndex];
    final progress = (currentIndex + 1) / rituals.length;
    
    return Column(
      children: [
        // Progress indicator
        _buildProgressIndicator(progress, currentIndex + 1, rituals.length),
        
        // Ritual content
        Expanded(
          child: _buildRitualContent(context, ref, currentRitual, currentIndex),
        ),
        
        // Navigation
        _buildNavigation(context, ref, currentIndex, rituals.length),
      ],
    );
  }
  
  Widget _buildProgressIndicator(double progress, int current, int total) => Padding(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        children: [
          ProgressRing(
            progress: progress,
            size: 60,
            strokeWidth: 4,
            child: Text(
              '$current/$total',
              style: AppTheme.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing12),
          Text(
            'Ritual $current of $total',
            style: AppTheme.title,
          ),
        ],
      ),
    );
  
  Widget _buildRitualContent(
    BuildContext context,
    WidgetRef ref,
    RitualType ritual,
    int index,
  ) => Padding(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        children: [
          // Ritual icon and title
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.accentPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Text(
                ritual.icon,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          
          const SizedBox(height: AppTheme.spacing24),
          
          Text(
            ritual.displayName,
            style: AppTheme.h1,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacing16),
          
          Text(
            ritual.instructions,
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: AppTheme.spacing32),
          
          // Timer or meditation space
          _buildRitualTimer(context, ref, ritual),
          
          const Spacer(),
          
          // DND toggle and audio player
          _buildControls(context, ref),
        ],
      ),
    );
  
  Widget _buildRitualTimer(
    BuildContext context,
    WidgetRef ref,
    RitualType ritual,
  ) {
    final duration = ref.watch(ritualDurationProvider);
    final isRunning = ref.watch(ritualTimerRunningProvider);
    final progress = duration / ritual.suggestedDuration.inSeconds;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          children: [
            Text(
              '60 seconds to focus',
              style: AppTheme.title,
            ),
            const SizedBox(height: AppTheme.spacing16),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(ritualTimerRunningProvider.notifier).state = !isRunning;
              },
              child: ProgressRing(
                progress: progress.clamp(0.0, 1.0),
                size: 120,
                strokeWidth: 8,
                color: AppTheme.accentPrimary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatDuration(Duration(seconds: duration)),
                      style: AppTheme.timeDisplayLarge,
                    ),
                    Text(
                      'of 60s',
                      style: AppTheme.caption,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),
            if (isRunning)
              Text(
                'Focus on your breathing...',
                style: AppTheme.caption,
                textAlign: TextAlign.center,
              )
            else
              Text(
                "Tap the ring to start when you're ready",
                style: AppTheme.caption,
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildControls(BuildContext context, WidgetRef ref) {
    final isAudioPlaying = ref.watch(audioPlayingProvider);
    final isDndEnabled = ref.watch(dndEnabledProvider);
    
    return Column(
      children: [
        // Audio player
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              children: [
                const Icon(Icons.music_note, color: AppTheme.accentPrimary),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lo-fi Sleep Sounds',
                        style: AppTheme.title,
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        'Gentle sounds to help you relax',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isAudioPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppTheme.accentPrimary,
                  ),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(audioPlayingProvider.notifier).state = !isAudioPlaying;
                  },
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacing12),
        
        // DND toggle
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              children: [
                const Icon(Icons.do_not_disturb, color: AppTheme.warning),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Do Not Disturb',
                        style: AppTheme.title,
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        'Block notifications while winding down',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isDndEnabled,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    ref.read(dndEnabledProvider.notifier).state = value;
                    _toggleDND(context, value);
                  },
                  activeColor: AppTheme.accentPrimary,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: AppTheme.spacing12),
        
        // Platform-specific guidance
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing16),
            child: Row(
              children: [
                Icon(
                  Platform.isIOS ? Icons.phone_iphone : Icons.android,
                  color: AppTheme.info,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Platform.isIOS ? 'iOS Shortcuts' : 'Android DND',
                        style: AppTheme.title,
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        Platform.isIOS 
                            ? 'Set up automatic DND with Shortcuts app'
                            : 'Enable Do Not Disturb in system settings',
                        style: AppTheme.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline, color: AppTheme.info),
                  onPressed: () => _showPlatformGuide(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNavigation(
    BuildContext context,
    WidgetRef ref,
    int currentIndex,
    int totalRituals,
  ) {
    final isLastRitual = currentIndex == totalRituals - 1;
    
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Row(
        children: [
          if (currentIndex > 0)
            Expanded(
              child: SecondaryButton(
                text: 'Previous',
                onPressed: () {
                  HapticFeedback.selectionClick();
                  ref.read(currentRitualIndexProvider.notifier).state = currentIndex - 1;
                },
              ),
            ),
          if (currentIndex > 0) const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: PrimaryButton(
              text: isLastRitual ? 'Complete' : 'Next',
              onPressed: () {
                HapticFeedback.lightImpact();
                if (isLastRitual) {
                  _completeWindDown(context, ref);
                } else {
                  ref.read(currentRitualIndexProvider.notifier).state = currentIndex + 1;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompletedView(BuildContext context, WidgetRef ref) => Padding(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.success,
            size: 80,
          ),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            'Wind-down complete!',
            style: AppTheme.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'You\'ve taken time to prepare for a restful night. Sweet dreams!',
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing32),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Good night',
              onPressed: () {
                HapticFeedback.lightImpact();
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  
  Widget _buildEmptyState(BuildContext context) => Padding(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.nightlight_round,
            color: AppTheme.textSecondary,
            size: 80,
          ),
          const SizedBox(height: AppTheme.spacing24),
          Text(
            'No rituals selected',
            style: AppTheme.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Set up your wind-down rituals in settings to get started.',
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing32),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: 'Go to Settings',
              onPressed: () {
                context.pop();
                context.push('/settings');
              },
            ),
          ),
        ],
      ),
    );
  
  Future<void> _completeWindDown(BuildContext context, WidgetRef ref) async {
    // Mark wind-down as completed
    ref.read(windDownCompletedProvider.notifier).state = true;
    
    // Log ritual completion
    final rituals = ref.read(selectedRitualsProvider);
    final isar = DatabaseService.instance;
    
    await isar.writeTxn(() async {
      for (final ritual in rituals.value ?? []) {
        final log = RitualLog()
          ..date = DateTime.now()
          ..ritualType = ritual
          ..durationSec = ref.read(ritualDurationProvider)
          ..completed = true;
        await isar.ritualLogs.put(log);
      }
    });
    
    HapticFeedback.lightImpact();
  }
  
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  void _toggleDND(BuildContext context, bool enabled) {
    if (enabled) {
      Toast.show(
        context: context,
        message: Platform.isIOS 
            ? 'Enable DND in Control Center or Settings'
            : 'Enable Do Not Disturb in system settings',
        type: ToastType.info,
      );
    }
  }
  
  void _showPlatformGuide(BuildContext context) {
    BottomSheetModal.show(
      context: context,
      title: Platform.isIOS ? 'iOS Shortcuts Setup' : 'Android DND Setup',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Platform.isIOS) ...[
            Text(
              'Set up automatic Do Not Disturb with iOS Shortcuts:',
              style: AppTheme.body,
            ),
            const SizedBox(height: AppTheme.spacing16),
            _buildGuideStep('1', 'Open the Shortcuts app'),
            _buildGuideStep('2', 'Tap "Automation" at the bottom'),
            _buildGuideStep('3', 'Tap "+" to create a new automation'),
            _buildGuideStep('4', 'Choose "App" and select "SleepShield Lite"'),
            _buildGuideStep('5', 'Add "Set Do Not Disturb" action'),
            _buildGuideStep('6', 'Set to "Turn On" and tap "Done"'),
          ] else ...[
            Text(
              'Enable Do Not Disturb on Android:',
              style: AppTheme.body,
            ),
            const SizedBox(height: AppTheme.spacing16),
            _buildGuideStep('1', 'Open Settings app'),
            _buildGuideStep('2', 'Go to "Sound & vibration"'),
            _buildGuideStep('3', 'Tap "Do Not Disturb"'),
            _buildGuideStep('4', 'Toggle "Turn on now" or set a schedule'),
            _buildGuideStep('5', 'Customize which notifications to allow'),
          ],
        ],
      ),
      actions: [
        PrimaryButton(
          text: 'Got it',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
  
  Widget _buildGuideStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.accentPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: AppTheme.caption.copyWith(
                  color: AppTheme.background,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Text(
              text,
              style: AppTheme.body,
            ),
          ),
        ],
      ),
    );
  }
}
