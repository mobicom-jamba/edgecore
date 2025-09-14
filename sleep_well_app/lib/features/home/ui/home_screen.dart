import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/progress_ring.dart';
import '../../../core/ui/icon_card.dart';
import '../../../core/ui/modals.dart';
import '../data/providers/home_providers.dart';
import '../domain/home_phase.dart';

class QuickActionData {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const QuickActionData({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final homePhase = ref.watch(homePhaseProvider);
    final bedtimeTime = ref.watch(bedtimeTimeProvider);
    final wakeTime = ref.watch(wakeTimeProvider);
    final streakDays = ref.watch(streakDaysProvider);
    final shouldShowStickyCTA = ref.watch(shouldShowStickyCTAProvider);
    final shouldPulseCountdown = ref.watch(shouldPulseCountdownProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Well Sleep'),
        actions: [
          // Bedtime mode toggle
          Semantics(
            label: 'Toggle bedtime mode',
            child: IconButton(
              icon: Icon(
                homePhase.phase == HomePhase.evening 
                    ? Icons.bedtime 
                    : Icons.bedtime_outlined,
              ),
              onPressed: () {
                HapticFeedback.selectionClick();
                _toggleBedtimeMode(context, ref);
              },
            ),
          ),
          // Settings
          Semantics(
            label: 'Settings',
            child: IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                HapticFeedback.selectionClick();
                context.push('/settings');
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: homeState.when(
          data: (data) => _buildContent(
            context,
            ref,
            homePhase,
            bedtimeTime,
            wakeTime,
            streakDays.value ?? 0,
            shouldPulseCountdown,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.error,
                ),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  'Something went wrong',
                  style: AppTheme.h2,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Please try again later',
                  style: AppTheme.body,
                ),
                const SizedBox(height: AppTheme.spacing24),
                PrimaryButton(
                  text: 'Retry',
                  onPressed: () => ref.invalidate(homeProvider),
                ),
              ],
            ),
          ),
        ),
      ),
      // Sticky bottom CTA (evening phase only)
      bottomNavigationBar: shouldShowStickyCTA
          ? _buildStickyCTA(context, homePhase)
          : null,
    );
  }
  
  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    HomePhaseData homePhase,
    TimeOfDay bedtimeTime,
    TimeOfDay wakeTime,
    int streakDays,
    bool shouldPulseCountdown,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        HapticFeedback.lightImpact();
        ref.invalidate(homeProvider);
        ref.invalidate(homePhaseProvider);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      color: AppTheme.accentPrimary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Schedule Card with countdown
            _buildScheduleCard(
              context,
              homePhase,
              bedtimeTime,
              wakeTime,
              shouldPulseCountdown,
            ),
            
            const SizedBox(height: AppTheme.spacing24),
            
            // Phase-specific primary action
            _buildPrimaryAction(context, ref, homePhase),
            
            const SizedBox(height: AppTheme.spacing24),
            
            // Streak Card
            _buildStreakCard(context, ref, streakDays),
            
            const SizedBox(height: AppTheme.spacing24),
            
            // Quick Actions (collapsed in evening phase)
            if (homePhase.phase != HomePhase.evening) ...[
              _buildQuickActions(context, homePhase),
              const SizedBox(height: AppTheme.spacing24),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildScheduleCard(
    BuildContext context,
    HomePhaseData homePhase,
    TimeOfDay bedtimeTime,
    TimeOfDay wakeTime,
    bool shouldPulseCountdown,
  ) {
    final countdownText = _getCountdownText(homePhase);
    final countdownColor = _getCountdownColor(homePhase);
    final plannedSleep = _calculatePlannedSleep(bedtimeTime, wakeTime);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing20),
        child: Column(
          children: [
            // Title
            Text(
              'Your Sleep Schedule',
              style: AppTheme.title,
            ),
            const SizedBox(height: AppTheme.spacing20),
            
            // Countdown with animation and progress
            Center(
              child: Column(
                children: [
                  // Animated countdown text
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                          CurvedAnimation(parent: animation, curve: Curves.easeOut),
                        ),
                        child: child,
                      ),
                    ),
                    child: Text(
                      countdownText,
                      key: ValueKey(countdownText),
                      style: AppTheme.h1.copyWith(
                        color: countdownColor,
                        shadows: [
                          Shadow(
                            color: countdownColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  
                  // Progress bar
                  Container(
                    width: 200,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.divider,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: homePhase.eveningProgress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: countdownColor,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacing12),
                  
                  // Smart contextual messaging
                  Text(
                    _getSmartMessage(homePhase),
                    style: AppTheme.body,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing20),
            
            // Tonight's goal with breathing animation
            Container(
              padding: const EdgeInsets.all(AppTheme.spacing12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentPrimary.withOpacity(0.1),
                    AppTheme.accentPrimary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentPrimary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Breathing moon icon
                  TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 2),
                    tween: Tween(begin: 0.8, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: const Icon(
                          Icons.bedtime,
                          color: AppTheme.accentPrimary,
                          size: 20,
                        ),
                      );
                    },
                    onEnd: () {
                      // Restart animation
                    },
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: Text(
                      'Tonight\'s goal: $plannedSleep of sleep planned',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.accentPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacing20),
            
            // Time range display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTimeDisplay('Bedtime', bedtimeTime),
                const Icon(
                  Icons.arrow_forward,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                _buildTimeDisplay('Wake up', wakeTime),
              ],
            ),
            
            // const SizedBox(height: AppTheme.spacing16),
            
            // // Edit schedule link
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //     onPressed: () => context.push('/settings'),
            //     child: Text(
            //       'Edit schedule',
            //       style: AppTheme.caption.copyWith(
            //         color: AppTheme.accentPrimary,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTimeDisplay(String label, TimeOfDay time) {
    final timeString = formatTime(time);
    
    return Column(
      children: [
        Text(
          timeString,
          style: AppTheme.timeDisplay,
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          label,
          style: AppTheme.caption,
        ),
      ],
    );
  }
  
  Widget _buildPrimaryAction(
    BuildContext context,
    WidgetRef ref,
    HomePhaseData homePhase,
  ) {
    final actionText = getPrimaryActionText(homePhase.phase, isPastBedtime: homePhase.isPastBedtime);
    VoidCallback? onPressed;
    IconData? icon;
    
    switch (homePhase.phase) {
      case HomePhase.morning:
        onPressed = () => context.push('/morning-checkin');
        icon = Icons.wb_sunny_outlined;
        break;
      case HomePhase.daytime:
        onPressed = () => context.push('/settings');
        icon = Icons.schedule_outlined;
        break;
      case HomePhase.evening:
        onPressed = () => context.push('/wind-down');
        icon = Icons.nightlight_round_outlined;
        break;
    }
    
    return SizedBox(
      width: double.infinity,
      child: PrimaryButton(
        text: actionText,
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
  
  Widget _buildStreakCard(BuildContext context, WidgetRef ref, int streakDays) {
    return StreakCard(
      streakDays: streakDays,
      onTap: () => _showStreakDetails(context, streakDays),
    );
  }
  
  Widget _buildQuickActions(BuildContext context, HomePhaseData homePhase) {
    final actions = _getAdaptiveQuickActions(context, homePhase);
    
    return CardSection(
      title: 'Quick Actions',
      body: Column(
        children: actions.map((action) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
          child: IconCard(
            label: action.label,
            subtitle: action.subtitle,
            icon: action.icon,
            onTap: action.onTap,
          ),
        )).toList(),
      ),
    );
  }
  
  List<QuickActionData> _getAdaptiveQuickActions(BuildContext context, HomePhaseData homePhase) {
    final minutesUntilBed = homePhase.timeUntilBedtime.inMinutes;
    
    if (homePhase.phase == HomePhase.morning) {
      return [
        QuickActionData(
          label: 'Morning Check-in',
          subtitle: 'How did your night go?',
          icon: Icons.wb_sunny_outlined,
          onTap: () => context.push('/morning-checkin'),
        ),
        QuickActionData(
          label: 'Plan Tomorrow',
          subtitle: 'Set your intentions for the day',
          icon: Icons.calendar_today_outlined,
          onTap: () => _showPlanningModal(context),
        ),
        QuickActionData(
          label: 'Sleep Buddy',
          subtitle: 'Add a friend to keep you accountable',
          icon: Icons.people_outline,
          onTap: () => _showBuddyModal(context),
        ),
      ];
    } else if (minutesUntilBed > 120) {
      // 2+ hours before bedtime
      return [
        QuickActionData(
          label: 'Plan Tomorrow',
          subtitle: 'Set your intentions for the day',
          icon: Icons.calendar_today_outlined,
          onTap: () => _showPlanningModal(context),
        ),
        QuickActionData(
          label: 'Set Environment',
          subtitle: 'Prepare your sleep space',
          icon: Icons.home_outlined,
          onTap: () => _showEnvironmentModal(context),
        ),
        QuickActionData(
          label: 'Sleep Buddy',
          subtitle: 'Add a friend to keep you accountable',
          icon: Icons.people_outline,
          onTap: () => _showBuddyModal(context),
        ),
      ];
    } else if (minutesUntilBed > 60) {
      // 1-2 hours before bedtime
      return [
        QuickActionData(
          label: 'Start Wind-down',
          subtitle: 'Begin your bedtime routine',
          icon: Icons.nightlight_round_outlined,
          onTap: () => context.push('/wind-down'),
        ),
        QuickActionData(
          label: 'Dim Lights',
          subtitle: 'Prepare your environment',
          icon: Icons.lightbulb_outline,
          onTap: () => _showEnvironmentModal(context),
        ),
        QuickActionData(
          label: 'Sleep Buddy',
          subtitle: 'Add a friend to keep you accountable',
          icon: Icons.people_outline,
          onTap: () => _showBuddyModal(context),
        ),
      ];
    } else {
      // Close to or at bedtime
      return [
        QuickActionData(
          label: 'Going to Bed Now',
          subtitle: 'Start your sleep routine',
          icon: Icons.bedtime,
          onTap: () => context.push('/wind-down'),
        ),
        QuickActionData(
          label: 'Sleep Mode',
          subtitle: 'Enable do not disturb',
          icon: Icons.do_not_disturb,
          onTap: () => _enableSleepMode(context),
        ),
      ];
    }
  }
  
  Widget _buildStickyCTA(BuildContext context, HomePhaseData homePhase) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(
            color: AppTheme.divider,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Start wind-down',
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/wind-down');
            },
            icon: Icons.nightlight_round_outlined,
          ),
        ),
      ),
    );
  }
  
  String _getCountdownText(HomePhaseData homePhase) {
    if (homePhase.isPastBedtime) {
      return 'Past bedtime';
    } else if (homePhase.isWindDownTime) {
      return 'Wind-down time!';
    } else {
      return '${formatDuration(homePhase.timeUntilBedtime)} until bedtime';
    }
  }
  
  Color _getCountdownColor(HomePhaseData homePhase) {
    if (homePhase.isPastBedtime) {
      return AppTheme.warning;
    } else if (homePhase.isWindDownTime) {
      return AppTheme.accentPrimary;
    } else {
      return AppTheme.textPrimary;
    }
  }
  
  String _calculatePlannedSleep(TimeOfDay bedtime, TimeOfDay wakeTime) {
    // Calculate sleep duration considering bedtime might be next day
    final bedtimeDateTime = DateTime(2024, 1, 1, bedtime.hour, bedtime.minute);
    final wakeDateTime = DateTime(2024, 1, 1, wakeTime.hour, wakeTime.minute);
    
    Duration sleepDuration;
    if (wakeDateTime.isAfter(bedtimeDateTime)) {
      // Same day
      sleepDuration = wakeDateTime.difference(bedtimeDateTime);
    } else {
      // Next day
      sleepDuration = wakeDateTime.add(const Duration(days: 1)).difference(bedtimeDateTime);
    }
    
    final hours = sleepDuration.inHours;
    final minutes = sleepDuration.inMinutes % 60;
    
    if (minutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h ${minutes}m';
    }
  }
  
  String _getSmartMessage(HomePhaseData homePhase) {
    if (homePhase.isPastBedtime) {
      return 'Time to start your bedtime routine';
    }
    
    final minutesUntilBed = homePhase.timeUntilBedtime.inMinutes;
    
    if (minutesUntilBed <= 30) {
      return 'Wind-down time approaching';
    } else if (minutesUntilBed <= 60) {
      return 'Perfect timing for your routine';
    } else if (minutesUntilBed <= 120) {
      return 'Ready for a great night\'s sleep';
    } else {
      return 'Your sleep schedule is looking good';
    }
  }
  
  void _showStreakDetails(BuildContext context, int streakDays) {
    BottomSheetModal.show(
      context: context,
      title: 'Sleep Streak',
      content: Column(
        children: [
          Icon(
            streakDays == 0 ? Icons.nightlight_round : Icons.local_fire_department,
            size: 64,
            color: streakDays == 0 ? AppTheme.accentPrimary : AppTheme.success,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            streakDays == 0 ? 'Day 1 starts tonight' : '$streakDays day streak',
            style: AppTheme.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            streakDays == 0
                ? 'Tiny steps, real sleep. Every night counts.'
                : 'Keep building healthy sleep habits!',
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        SecondaryButton(
          text: 'Close',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
  
  void _showBuddyModal(BuildContext context) {
    HapticFeedback.selectionClick();
    BottomSheetModal.show(
      context: context,
      title: 'Sleep Buddy',
      content: Column(
        children: [
          const Icon(
            Icons.people_outline,
            size: 64,
            color: AppTheme.accentPrimary,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Add a sleep buddy to stay accountable',
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            "Add a Sleep Buddy for a gentle nudge if you slip.",
            style: AppTheme.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        SecondaryButton(
          text: 'Not now',
          onPressed: () => Navigator.pop(context),
        ),
        PrimaryButton(
          text: 'Add Buddy',
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
            // TODO: Navigate to buddy setup
          },
        ),
      ],
    );
  }
  
  void _showPlanningModal(BuildContext context) {
    HapticFeedback.selectionClick();
    BottomSheetModal.show(
      context: context,
      title: 'Plan Tomorrow',
      content: Column(
        children: [
          const Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: AppTheme.accentPrimary,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Set your intentions for tomorrow',
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            "Planning your day helps reduce stress and improves sleep quality.",
            style: AppTheme.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        PrimaryButton(
          text: 'Got it',
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
  
  void _showEnvironmentModal(BuildContext context) {
    HapticFeedback.selectionClick();
    BottomSheetModal.show(
      context: context,
      title: 'Sleep Environment',
      content: Column(
        children: [
          const Icon(
            Icons.home_outlined,
            size: 64,
            color: AppTheme.accentPrimary,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Prepare your sleep space',
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            "Dim the lights, adjust temperature, and create a calming atmosphere.",
            style: AppTheme.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        PrimaryButton(
          text: 'Got it',
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
  
  void _enableSleepMode(BuildContext context) {
    HapticFeedback.lightImpact();
    Toast.show(
      context: context,
      message: 'Sleep mode enabled - notifications silenced',
      type: ToastType.success,
    );
  }
  
  void _toggleBedtimeMode(BuildContext context, WidgetRef ref) {
    HapticFeedback.lightImpact();
    Toast.show(
      context: context,
      message: 'Bedtime mode toggled - interface dimmed',
      type: ToastType.info,
    );
    // TODO: Implement actual bedtime mode with dimmed interface
  }
}