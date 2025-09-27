import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/enhanced_sleep_data.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const SectionHeader({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: SleepColors.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: SleepColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class SleepDebtIndicator extends StatelessWidget {
  final Duration sleepDebt;
  final int recoveryNightsNeeded;

  const SleepDebtIndicator({
    Key? key,
    required this.sleepDebt,
    required this.recoveryNightsNeeded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDebt = sleepDebt.isNegative;
    final color =
        isDebt ? SleepColors.sleepDebtNegative : SleepColors.sleepDebtPositive;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDebt ? Icons.warning : Icons.check_circle,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isDebt ? "Sleep Debt" : "Sleep Surplus",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "${sleepDebt.abs().inHours}h ${sleepDebt.abs().inMinutes % 60}m ${isDebt ? 'debt' : 'surplus'}",
            style: TextStyle(
              color: SleepColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isDebt && recoveryNightsNeeded > 0) ...[
            const SizedBox(height: 4),
            Text(
              "Need $recoveryNightsNeeded nights to recover",
              style: TextStyle(
                color: SleepColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SleepQualityIndicator extends StatelessWidget {
  final int qualityScore;
  final String qualityLabel;

  const SleepQualityIndicator({
    Key? key,
    required this.qualityScore,
    required this.qualityLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = SleepColors.getQualityColor(qualityScore);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SleepColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Quality',
            style: TextStyle(
              fontSize: 12,
              color: SleepColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$qualityScore',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '- $qualityLabel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: SleepColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                label: 'Sleep quality information',
                hint: 'Double tap for detailed explanation',
                button: true,
                child: GestureDetector(
                  onTap: () => _showQualityTooltip(context),
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: SleepColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _getQualityDescription(qualityScore),
            style: TextStyle(
              fontSize: 12,
              color: SleepColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showQualityTooltip(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getDetailedQualityDescription(qualityScore)),
        duration: const Duration(seconds: 3),
        backgroundColor: SleepColors.cardBackground,
      ),
    );
  }

  String _getQualityDescription(int score) {
    if (score >= 85) return "Excellent deep sleep, great REM";
    if (score >= 75) return "Good deep sleep, average REM";
    if (score >= 65) return "Fair sleep, room for improvement";
    return "Poor sleep quality detected";
  }

  String _getDetailedQualityDescription(int score) {
    if (score >= 85)
      return "Excellent sleep quality! You had optimal deep sleep phases and good REM cycles.";
    if (score >= 75)
      return "Good sleep quality with solid deep sleep, but REM could be improved.";
    if (score >= 65)
      return "Fair sleep quality. Consider improving sleep hygiene for better rest.";
    return "Poor sleep quality. Multiple wake-ups detected. Consider consulting a sleep specialist.";
  }
}

class SleepGoalProgress extends StatelessWidget {
  final Duration totalSleep;
  final Duration sleepGoal;

  const SleepGoalProgress({
    Key? key,
    required this.totalSleep,
    required this.sleepGoal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress =
        (totalSleep.inMinutes / sleepGoal.inMinutes).clamp(0.0, 1.0);
    final formattedTotal =
        '${totalSleep.inHours}h ${totalSleep.inMinutes.remainder(60)}m';
    final formattedGoal =
        '${sleepGoal.inHours}h ${sleepGoal.inMinutes.remainder(60)}m';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SleepColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sleep Goal',
            style: TextStyle(
              fontSize: 12,
              color: SleepColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$formattedTotal of $formattedGoal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: SleepColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: SleepColors.textTertiary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [SleepColors.deepSleep, SleepColors.remSleep],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).round()}% of goal achieved',
            style: TextStyle(
              fontSize: 12,
              color: SleepColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;

  const QuickActionsGrid({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Semantics(
          label: '${action.label} button',
          hint: 'Double tap to ${action.label.toLowerCase()}',
          button: true,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              action.onTap();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: SleepColors.cardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: action.color?.withOpacity(0.3) ?? Colors.transparent,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    action.icon,
                    size: 24,
                    color: action.color ?? SleepColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: SleepColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class InsightCard extends StatelessWidget {
  final SleepInsight insight;

  const InsightCard({
    Key? key,
    required this.insight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      width: 280,
      decoration: BoxDecoration(
        color: SleepColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: insight.color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: insight.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  insight.icon,
                  color: insight.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  insight.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: SleepColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight.description,
            style: TextStyle(
              fontSize: 14,
              color: SleepColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          if (insight.onAction != null)
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                insight.onAction!();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: insight.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  insight.actionText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: insight.color,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SleepStageBreakdown extends StatelessWidget {
  final EnhancedSleepData data;

  const SleepStageBreakdown({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStageItem(SleepStageType.deep)),
            Expanded(child: _buildStageItem(SleepStageType.light)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStageItem(SleepStageType.rem)),
            Expanded(child: _buildStageItem(SleepStageType.awake)),
          ],
        ),
      ],
    );
  }

  Widget _buildStageItem(SleepStageType type) {
    final duration = data.stageDurations[type] ?? Duration.zero;
    final percentage = data.stagePercentages[type] ?? 0.0;
    final color = SleepColors.getStageColor(type);
    final label = _getStageLabel(type);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final formattedDuration =
        hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: SleepColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${percentage.round()}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            formattedDuration,
            style: TextStyle(
              fontSize: 12,
              color: SleepColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getStageLabel(SleepStageType type) {
    switch (type) {
      case SleepStageType.deep:
        return 'Deep';
      case SleepStageType.light:
        return 'Light';
      case SleepStageType.rem:
        return 'REM';
      case SleepStageType.awake:
        return 'Awake';
    }
  }
}

class PeriodSelector extends StatelessWidget {
  final List<String> periods;
  final String selected;
  final Function(String) onChanged;

  const PeriodSelector({
    Key? key,
    required this.periods,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: SleepColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: periods.map((period) {
          final isSelected = period == selected;
          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onChanged(period);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? SleepColors.deepSleep.withOpacity(0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    period,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? SleepColors.textPrimary
                          : SleepColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getPeriodDescription(period),
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected
                          ? SleepColors.textSecondary
                          : SleepColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getPeriodDescription(String period) {
    switch (period.toLowerCase()) {
      case 'day':
        return 'Sleep stages';
      case 'week':
        return 'Trends';
      case 'month':
        return 'Patterns';
      default:
        return '';
    }
  }
}
