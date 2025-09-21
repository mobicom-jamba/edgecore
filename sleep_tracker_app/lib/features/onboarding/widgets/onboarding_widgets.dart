import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import 'sleep_timeline_painter.dart';
import 'onboarding_common_widgets.dart';

// Step 1: Sleep Goal Selection
class OnboardingSleepGoalStep extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function(String, dynamic) onDataChanged;

  const OnboardingSleepGoalStep({
    super.key,
    required this.userData,
    required this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingCommonWidgets.buildStepHeader(
            icon: Icons.flag_outlined,
            gradientColors: [AppTheme.primaryBlue, AppTheme.sleepRem],
            title: 'What\'s your sleep goal?',
            subtitle: 'We\'ll help you achieve consistent, quality sleep based on your target.',
          ),
          _buildSleepGoalSlider(),
          const SizedBox(height: OnboardingStyles.itemSpacing),
          _buildRecommendationCard(),
          const SizedBox(height: OnboardingStyles.sectionSpacing),
        ],
      ),
    );
  }

  Widget _buildSleepGoalSlider() {
    double currentValue = userData['sleepGoal'] ?? 8.0;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OnboardingCommonWidgets.buildSectionTitle('Sleep Duration'),
            OnboardingCommonWidgets.buildValueBadge(
              value: '${currentValue.toStringAsFixed(1)} hours',
            ),
          ],
        ),
        const SizedBox(height: OnboardingStyles.itemSpacing),
        _buildCustomSlider(currentValue),
        const SizedBox(height: OnboardingStyles.smallSpacing),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('6h', style: TextStyle(color: AppTheme.textTertiary)),
            Text('10h', style: TextStyle(color: AppTheme.textTertiary)),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomSlider(double currentValue) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: AppTheme.primaryBlue,
        inactiveTrackColor: AppTheme.cardBackground,
        thumbColor: AppTheme.primaryBlue,
        overlayColor: AppTheme.primaryBlue.withOpacity(0.2),
        trackHeight: 6,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
      ),
      child: Slider(
        value: currentValue,
        min: 6.0,
        max: 10.0,
        divisions: 8,
        onChanged: (value) {
          HapticFeedback.selectionClick();
          onDataChanged('sleepGoal', value);
        },
      ),
    );
  }

  Widget _buildRecommendationCard() {
    double sleepGoal = userData['sleepGoal'] ?? 8.0;
    String recommendation = _getRecommendationText(sleepGoal);

    return OnboardingCommonWidgets.buildInfoCard(
      message: recommendation,
      icon: Icons.lightbulb_outline,
    );
  }

  String _getRecommendationText(double sleepGoal) {
    if (sleepGoal < 7) {
      return 'Consider aiming for at least 7-9 hours for optimal health.';
    } else if (sleepGoal > 9) {
      return 'Great! You\'re targeting the ideal sleep duration.';
    } else {
      return 'Perfect! This aligns with expert recommendations.';
    }
  }
}

// Step 2: Current Sleep Habits
class OnboardingSleepHabitsStep extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function(String, dynamic) onDataChanged;

  const OnboardingSleepHabitsStep({
    super.key,
    required this.userData,
    required this.onDataChanged,
  });

  static const List<String> _sleepChallenges = [
    'Trouble falling asleep',
    'Waking up frequently',
    'Waking up too early',
    'Feeling tired after sleep',
    'Snoring',
    'Stress/Anxiety',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingCommonWidgets.buildStepHeader(
            icon: Icons.psychology_outlined,
            gradientColors: [AppTheme.sleepRem, AppTheme.sleepDeep],
            title: 'How do you sleep?',
            subtitle: 'Tell us about your current sleep quality and challenges.',
          ),
          _buildSleepQualitySection(),
          const SizedBox(height: OnboardingStyles.itemSpacing),
          _buildSleepChallengesSection(),
          const SizedBox(height: OnboardingStyles.sectionSpacing),
        ],
      ),
    );
  }

  Widget _buildSleepQualitySection() {
    int currentQuality = userData['sleepQuality'] ?? 3;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingCommonWidgets.buildSectionTitle(
          'How would you rate your current sleep quality?'
        ),
        const SizedBox(height: 20),
        _buildStarRating(currentQuality),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Poor', style: TextStyle(color: AppTheme.textTertiary, fontSize: 12)),
            Text('Excellent', style: TextStyle(color: AppTheme.textTertiary, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildStarRating(int currentQuality) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        bool isSelected = index < currentQuality;
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onDataChanged('sleepQuality', index + 1);
          },
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(OnboardingStyles.smallBorderRadius),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.borderColor,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.star,
              color: isSelected ? Colors.white : AppTheme.textTertiary,
              size: 24,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSleepChallengesSection() {
    List<String> currentChallenges = List<String>.from(userData['sleepChallenges'] ?? []);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OnboardingCommonWidgets.buildSectionTitle(
          'What sleep challenges do you face? (Select all that apply)'
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _sleepChallenges.map((challenge) {
            bool isSelected = currentChallenges.contains(challenge);
            return OnboardingCommonWidgets.buildSelectableChip(
              label: challenge,
              isSelected: isSelected,
              onTap: () => _toggleChallenge(challenge, currentChallenges),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _toggleChallenge(String challenge, List<String> currentChallenges) {
    HapticFeedback.selectionClick();
    List<String> updatedChallenges = List<String>.from(currentChallenges);
    
    if (updatedChallenges.contains(challenge)) {
      updatedChallenges.remove(challenge);
    } else {
      updatedChallenges.add(challenge);
    }
    
    onDataChanged('sleepChallenges', updatedChallenges);
  }
}

// Step 3: Sleep Schedule Setup
class OnboardingSleepScheduleStep extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function(String, dynamic) onDataChanged;

  const OnboardingSleepScheduleStep({
    super.key,
    required this.userData,
    required this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingCommonWidgets.buildStepHeader(
            icon: Icons.schedule,
            gradientColors: [AppTheme.sleepDeep, AppTheme.sleepLight],
            title: 'Set your schedule',
            subtitle: 'When do you usually go to bed and wake up?',
          ),
          _buildTimeSelector(context, 'Bedtime', 'currentBedtime', Icons.bedtime),
          const SizedBox(height: OnboardingStyles.itemSpacing),
          _buildTimeSelector(context, 'Wake Time', 'currentWakeTime', Icons.wb_sunny),
          const SizedBox(height: OnboardingStyles.itemSpacing),
          _buildSleepDurationCard(),
          const SizedBox(height: OnboardingStyles.sectionSpacing),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context, String title, String key, IconData icon) {
    TimeOfDay currentTime = userData[key] ?? TimeOfDay(hour: key == 'currentBedtime' ? 23 : 7, minute: 0);
    
    return OnboardingCommonWidgets.buildCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(OnboardingStyles.smallBorderRadius),
            ),
            child: Icon(icon, color: AppTheme.primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentTime.format(context),
                  style: const TextStyle(
                    fontSize: OnboardingStyles.subtitleFontSize,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildChangeButton(context, key),
        ],
      ),
    );
  }

  Widget _buildChangeButton(BuildContext context, String key) {
    return GestureDetector(
      onTap: () => _selectTime(context, key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue,
          borderRadius: BorderRadius.circular(OnboardingStyles.tinyBorderRadius),
        ),
        child: const Text(
          'Change',
          style: TextStyle(
            fontSize: OnboardingStyles.subtitleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSleepDurationCard() {
    TimeOfDay bedtime = userData['currentBedtime'] ?? TimeOfDay(hour: 23, minute: 0);
    TimeOfDay wakeTime = userData['currentWakeTime'] ?? TimeOfDay(hour: 7, minute: 0);
    
    double duration = TimeUtils.calculateSleepDuration(bedtime, wakeTime);
    Color durationColor = SleepDurationValidator.getDurationColor(duration);
    
    return OnboardingCommonWidgets.buildCard(
      gradient: LinearGradient(
        colors: [
          durationColor.withOpacity(0.1),
          durationColor.withOpacity(0.05),
        ],
      ),
      borderColor: durationColor.withOpacity(0.3),
      child: Column(
        children: [
          _buildSleepTimeline(bedtime, wakeTime),
          const SizedBox(height: 20),
          _buildDurationDisplay(duration, durationColor),
          const SizedBox(height: 12),
          _buildSleepQualityFeedback(duration),
        ],
      ),
    );
  }

  Widget _buildSleepTimeline(TimeOfDay bedtime, TimeOfDay wakeTime) {
    return SizedBox(
      height: 60,
      child: CustomPaint(
        painter: SleepTimelinePainter(
          bedtime: bedtime,
          wakeTime: wakeTime,
          primaryColor: AppTheme.primaryBlue,
          sleepColor: AppTheme.sleepDeep,
        ),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildDurationDisplay(double duration, Color durationColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          SleepDurationValidator.getDurationIcon(duration),
          color: durationColor,
          size: 24,
        ),
        const SizedBox(width: OnboardingStyles.smallSpacing),
        Text(
          'Sleep window: ${TimeUtils.formatDuration(duration)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: durationColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepQualityFeedback(double duration) {
    return OnboardingCommonWidgets.buildFeedbackMessage(
      message: SleepDurationValidator.getDurationMessage(duration),
      color: SleepDurationValidator.getDurationColor(duration),
      icon: SleepDurationValidator.getMessageIcon(duration),
    );
  }

  Future<void> _selectTime(BuildContext context, String key) async {
    TimeOfDay currentTime = userData[key] ?? TimeOfDay(hour: 23, minute: 0);
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primaryBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      HapticFeedback.selectionClick();
      onDataChanged(key, picked);
    }
  }
}

// Step 4: Notifications & Permissions
class OnboardingPermissionsStep extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Function(String, dynamic) onDataChanged;

  const OnboardingPermissionsStep({
    super.key,
    required this.userData,
    required this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingCommonWidgets.buildStepHeader(
            icon: Icons.notifications_active,
            gradientColors: [AppTheme.successGreen, AppTheme.primaryBlue],
            title: 'Stay consistent',
            subtitle: 'Consistency is key to better sleep. Let us help you stick to your schedule.',
          ),
          _buildNotificationExplanation(),
          const SizedBox(height: OnboardingStyles.sectionSpacing),
          _buildNotificationToggle(),
          const SizedBox(height: OnboardingStyles.sectionSpacing),
          _buildSetupCompleteCard(),
          const SizedBox(height: OnboardingStyles.sectionSpacing),
        ],
      ),
    );
  }

  Widget _buildNotificationExplanation() {
    return OnboardingCommonWidgets.buildCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppTheme.primaryBlue.withOpacity(0.1),
          AppTheme.sleepRem.withOpacity(0.05),
        ],
      ),
      borderColor: AppTheme.primaryBlue.withOpacity(0.2),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          OnboardingCommonWidgets.buildIconContainer(
            icon: Icons.bedtime_outlined,
            gradientColors: [AppTheme.primaryBlue.withOpacity(0.15), AppTheme.primaryBlue.withOpacity(0.15)],
          ),
          const SizedBox(height: 20),
          const Text(
            'Never Miss Your Sleep Schedule',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Get gentle reminders 30 minutes before bedtime and smart wake-up alerts during your lightest sleep phase.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: OnboardingStyles.subtitleFontSize,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle() {
    bool isEnabled = userData['notificationsEnabled'] ?? true;
    
    return OnboardingCommonWidgets.buildCard(
      borderColor: isEnabled ? AppTheme.primaryBlue : AppTheme.borderColor,
      borderWidth: isEnabled ? 2 : 1,
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.notifications_active,
                      color: isEnabled ? AppTheme.primaryBlue : AppTheme.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Flexible(
                      child: Text(
                        'Enable Sleep Notifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: OnboardingStyles.smallSpacing),
                Text(
                  isEnabled 
                      ? 'Perfect! You\'ll get helpful sleep reminders.'
                      : 'You can always enable this later in settings.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isEnabled ? AppTheme.primaryBlue : AppTheme.textSecondary,
                    fontWeight: isEnabled ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildNotificationSwitch(isEnabled),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch(bool isEnabled) {
    return Transform.scale(
      scale: 1.2,
      child: Switch(
        value: isEnabled,
        onChanged: (value) {
          HapticFeedback.lightImpact();
          onDataChanged('notificationsEnabled', value);
        },
        activeColor: AppTheme.primaryBlue,
        activeTrackColor: AppTheme.primaryBlue.withOpacity(0.3),
        inactiveThumbColor: AppTheme.textTertiary,
        inactiveTrackColor: AppTheme.cardBackground,
      ),
    );
  }

  Widget _buildSetupCompleteCard() {
    return OnboardingCommonWidgets.buildCard(
      gradient: LinearGradient(
        colors: [
          AppTheme.successGreen.withOpacity(0.1),
          AppTheme.primaryBlue.withOpacity(0.05),
        ],
      ),
      borderColor: AppTheme.successGreen.withOpacity(0.2),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          OnboardingCommonWidgets.buildIconContainer(
            icon: Icons.check,
            gradientColors: [AppTheme.successGreen.withOpacity(0.2), AppTheme.successGreen.withOpacity(0.2)],
          ),
          const SizedBox(height: 16),
          const Text(
            'You\'re all set!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: OnboardingStyles.smallSpacing),
          const Text(
            'Your sleep profile is ready. Let\'s unlock your best sleep with premium features.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: OnboardingStyles.subtitleFontSize,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}