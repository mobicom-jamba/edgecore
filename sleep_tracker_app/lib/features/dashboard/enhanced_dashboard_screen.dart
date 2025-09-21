import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../shared/widgets/app_header.dart';
import '../../shared/models/enhanced_sleep_data.dart';
import '../../shared/widgets/enhanced_dashboard_widgets.dart';
import '../../shared/widgets/interactive_sleep_chart.dart';

class EnhancedDashboardScreen extends HookWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = useState('Week');
    final sleepData = useState<EnhancedSleepData>(_getSampleSleepData());
    final pageController = usePageController();

    return Scaffold(
      backgroundColor: SleepColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Sleep Dashboard',
              showBackButton: false,
              rightAction: HeaderActionButton(
                icon: Icons.more_vert,
                onPressed: () => _showMoreOptions(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildKeyMetrics(sleepData.value),
                    const SizedBox(height: 24),
                    _buildSleepChart(selectedPeriod, sleepData.value),
                    const SizedBox(height: 24),
                    _buildContextualQuickActions(context),
                    const SizedBox(height: 24),
                    _buildInsightsSection(context, pageController),
                    const SizedBox(height: 24),
                    _buildProgressIndicators(sleepData.value),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetrics(EnhancedSleepData data) {
    return Column(
      children: [
        // Top row: Sleep Goal Progress and Quality
        Row(
          children: [
            Expanded(
              child: SleepGoalProgress(
                totalSleep: data.totalSleep,
                sleepGoal: data.sleepGoal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SleepQualityIndicator(
                qualityScore: data.qualityScore,
                qualityLabel: data.qualityLabel,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Bottom row: Sleep Debt
        SleepDebtIndicator(
          sleepDebt: data.sleepDebt,
          recoveryNightsNeeded: data.recoveryNightsNeeded,
        ),
      ],
    );
  }

  Widget _buildSleepChart(ValueNotifier<String> selectedPeriod, EnhancedSleepData data) {
    return InteractiveSleepChart(
      sleepData: data,
      selectedPeriod: selectedPeriod.value,
      onPeriodChanged: (period) {
        HapticFeedback.selectionClick();
        selectedPeriod.value = period;
      },
      onTimePointTap: (time) {
        // Handle time point tap for detailed view
        HapticFeedback.lightImpact();
      },
    );
  }

  Widget _buildContextualQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Quick Actions',
          subtitle: _getContextualSubtitle(),
        ),
        const SizedBox(height: 16),
        QuickActionsGrid(
          actions: _getContextualActions(context),
        ),
      ],
    );
  }

  Widget _buildInsightsSection(BuildContext context, PageController pageController) {
    final insights = _getSampleInsights(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Sleep Insights',
          subtitle: 'Personalized recommendations',
          trailing: GestureDetector(
            onTap: () => _showAllInsights(context),
            child: Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: SleepColors.deepSleep,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 140,
          child: PageView.builder(
            controller: pageController,
            itemCount: insights.length,
            itemBuilder: (context, index) => InsightCard(
              insight: insights[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicators(EnhancedSleepData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Progress Tracking',
          subtitle: 'Your sleep journey',
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildWeeklyTrendCard(data),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildConsistencyStreakCard(data),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyTrendCard(EnhancedSleepData data) {
    final isPositive = data.weeklyTrendPercentage >= 0;
    final color = isPositive ? SleepColors.qualityGood : SleepColors.sleepDebtNegative;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SleepColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Weekly Trend',
                style: TextStyle(
                  fontSize: 12,
                  color: SleepColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${isPositive ? '+' : ''}${data.weeklyTrendPercentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isPositive ? 'Improving sleep quality' : 'Needs attention',
            style: TextStyle(
              fontSize: 12,
              color: SleepColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsistencyStreakCard(EnhancedSleepData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SleepColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: SleepColors.qualityFair,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Consistency Streak',
                style: TextStyle(
                  fontSize: 12,
                  color: SleepColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${data.consistencyStreak}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: SleepColors.qualityFair,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'nights in target range',
            style: TextStyle(
              fontSize: 12,
              color: SleepColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _getContextualSubtitle() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return 'Good morning! How did you sleep?';
    } else if (hour >= 19 || hour < 6) {
      return 'Evening routine for better sleep';
    } else {
      return 'Plan your sleep for tonight';
    }
  }

  List<QuickAction> _getContextualActions(BuildContext context) {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      // Morning actions
      return [
        QuickAction(
          icon: Icons.sentiment_satisfied,
          label: 'Rate Sleep',
          color: SleepColors.qualityGood,
          onTap: () => _rateLastNight(context),
        ),
        QuickAction(
          icon: Icons.psychology,
          label: 'Log Mood',
          color: SleepColors.qualityFair,
          onTap: () => _logMood(context),
        ),
        QuickAction(
          icon: Icons.insights,
          label: 'View Insights',
          color: SleepColors.deepSleep,
          onTap: () => _viewInsights(context),
        ),
      ];
    } else if (hour >= 19 || hour < 6) {
      // Evening actions  
      return [
        QuickAction(
          icon: Icons.self_improvement,
          label: 'Wind Down',
          color: SleepColors.remSleep,
          onTap: () => _startWindDown(context),
        ),
        QuickAction(
          icon: Icons.bedtime,
          label: 'Sleep Now',
          color: SleepColors.deepSleep,
          onTap: () => _logSleepNow(context),
        ),
        QuickAction(
          icon: Icons.alarm,
          label: 'Set Alarm',
          color: SleepColors.lightSleep,
          onTap: () => _setAlarm(context),
        ),
      ];
    } else {
      // Afternoon actions
      return [
        QuickAction(
          icon: Icons.nightlight,
          label: 'Plan Tonight',
          color: SleepColors.deepSleep,
          onTap: () => _planTonight(context),
        ),
        QuickAction(
          icon: Icons.trending_up,
          label: 'View Trends',
          color: SleepColors.qualityGood,
          onTap: () => _viewTrends(context),
        ),
        QuickAction(
          icon: Icons.schedule,
          label: 'Set Bedtime',
          color: SleepColors.lightSleep,
          onTap: () => _setBedtime(context),
        ),
      ];
    }
  }

  List<SleepInsight> _getSampleInsights(BuildContext context) {
    return [
      SleepInsight(
        title: 'Sleep Debt Recovery Plan',
        description: 'Go to bed 15 minutes earlier for the next 2 nights to recover your sleep debt.',
        icon: Icons.schedule,
        color: SleepColors.sleepDebtNegative,
        actionText: 'Set Reminder',
        onAction: () => _setRecoveryReminder(context),
      ),
      SleepInsight(
        title: 'Optimal Bedtime Tonight',
        description: 'Based on your sleep patterns, your best bedtime tonight is 10:15 PM.',
        icon: Icons.bedtime,
        color: SleepColors.deepSleep,
        actionText: 'Set Bedtime',
        onAction: () => _setOptimalBedtime(context),
      ),
      SleepInsight(
        title: 'Consistency Boost',
        description: 'You\'ve maintained consistent bedtimes for 5 nights! This improved your REM sleep by 15%.',
        icon: Icons.trending_up,
        color: SleepColors.qualityGood,
        actionText: 'View Progress',
        onAction: () => _viewProgress(context),
      ),
    ];
  }

  // Action handlers
  void _showMoreOptions(BuildContext context) {
    HapticFeedback.lightImpact();
    // Show more options menu
  }

  void _rateLastNight(BuildContext context) {
    HapticFeedback.selectionClick();
    // Show sleep rating dialog
    _showSnackBar(context, 'Rate your sleep quality');
  }

  void _logMood(BuildContext context) {
    HapticFeedback.selectionClick();
    // Show mood logging interface
    _showSnackBar(context, 'Log your morning mood');
  }

  void _viewInsights(BuildContext context) {
    HapticFeedback.selectionClick();
    // Navigate to detailed insights
    _showSnackBar(context, 'Viewing detailed insights');
  }

  void _startWindDown(BuildContext context) {
    HapticFeedback.selectionClick();
    // Start wind-down routine
    _showSnackBar(context, 'Starting wind-down routine');
  }

  void _logSleepNow(BuildContext context) {
    HapticFeedback.mediumImpact();
    // Log sleep start time
    _showSnackBar(context, 'Sleep tracking started');
  }

  void _setAlarm(BuildContext context) {
    HapticFeedback.selectionClick();
    // Set alarm interface
    _showSnackBar(context, 'Setting alarm');
  }

  void _planTonight(BuildContext context) {
    HapticFeedback.selectionClick();
    // Plan tonight's sleep
    _showSnackBar(context, 'Planning tonight\'s sleep');
  }

  void _viewTrends(BuildContext context) {
    HapticFeedback.selectionClick();
    // View sleep trends
    _showSnackBar(context, 'Viewing sleep trends');
  }

  void _setBedtime(BuildContext context) {
    HapticFeedback.selectionClick();
    // Set bedtime
    _showSnackBar(context, 'Setting bedtime');
  }

  void _showAllInsights(BuildContext context) {
    HapticFeedback.lightImpact();
    // Show all insights
    _showSnackBar(context, 'Viewing all insights');
  }

  void _setRecoveryReminder(BuildContext context) {
    HapticFeedback.lightImpact();
    _showSnackBar(context, 'Recovery reminder set');
  }

  void _setOptimalBedtime(BuildContext context) {
    HapticFeedback.lightImpact();
    _showSnackBar(context, 'Optimal bedtime set');
  }

  void _viewProgress(BuildContext context) {
    HapticFeedback.lightImpact();
    _showSnackBar(context, 'Viewing progress details');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: SleepColors.cardBackground,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  EnhancedSleepData _getSampleSleepData() {
    final now = DateTime.now();
    final bedtime = DateTime(now.year, now.month, now.day - 1, 22, 15);
    final wakeTime = DateTime(now.year, now.month, now.day, 6, 45);

    final stages = [
      SleepStage(
        type: SleepStageType.light,
        startTime: bedtime,
        endTime: bedtime.add(const Duration(minutes: 45)),
        duration: const Duration(minutes: 45),
      ),
      SleepStage(
        type: SleepStageType.deep,
        startTime: bedtime.add(const Duration(minutes: 45)),
        endTime: bedtime.add(const Duration(hours: 2, minutes: 30)),
        duration: const Duration(hours: 1, minutes: 45),
      ),
      SleepStage(
        type: SleepStageType.light,
        startTime: bedtime.add(const Duration(hours: 2, minutes: 30)),
        endTime: bedtime.add(const Duration(hours: 4)),
        duration: const Duration(hours: 1, minutes: 30),
      ),
      SleepStage(
        type: SleepStageType.rem,
        startTime: bedtime.add(const Duration(hours: 4)),
        endTime: bedtime.add(const Duration(hours: 5, minutes: 25)),
        duration: const Duration(hours: 1, minutes: 25),
      ),
      SleepStage(
        type: SleepStageType.light,
        startTime: bedtime.add(const Duration(hours: 5, minutes: 25)),
        endTime: bedtime.add(const Duration(hours: 7, minutes: 30)),
        duration: const Duration(hours: 2, minutes: 5),
      ),
      SleepStage(
        type: SleepStageType.awake,
        startTime: bedtime.add(const Duration(hours: 7, minutes: 30)),
        endTime: wakeTime,
        duration: const Duration(minutes: 12),
      ),
    ];

    final stageDurations = <SleepStageType, Duration>{
      SleepStageType.deep: const Duration(hours: 1, minutes: 45),
      SleepStageType.light: const Duration(hours: 4, minutes: 20), // Combined light sleep
      SleepStageType.rem: const Duration(hours: 1, minutes: 25),
      SleepStageType.awake: const Duration(minutes: 12),
    };

    final totalSleep = const Duration(hours: 7, minutes: 32);
    final stagePercentages = <SleepStageType, double>{
      SleepStageType.deep: (105 / totalSleep.inMinutes) * 100, // 23%
      SleepStageType.light: (260 / totalSleep.inMinutes) * 100, // 57%
      SleepStageType.rem: (85 / totalSleep.inMinutes) * 100, // 19%
      SleepStageType.awake: (12 / totalSleep.inMinutes) * 100, // 3%
    };

    return EnhancedSleepData(
      bedtime: bedtime,
      wakeTime: wakeTime,
      totalSleep: totalSleep,
      sleepGoal: const Duration(hours: 8),
      qualityScore: 85,
      qualityLabel: SleepColors.getQualityLabel(85),
      sleepDebt: const Duration(minutes: -28), // 28 minutes of debt
      stages: stages,
      stageDurations: stageDurations,
      stagePercentages: stagePercentages,
      topInsight: 'Your consistent bedtime this week boosted your REM sleep by 15%',
      nextAction: 'Go to bed 15 minutes earlier tonight',
      recoveryNightsNeeded: 2,
      consistencyStreak: 5,
      weeklyTrendPercentage: 12.5,
    );
  }
}
