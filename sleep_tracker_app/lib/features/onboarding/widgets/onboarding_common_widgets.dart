import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Common styling constants for onboarding widgets
class OnboardingStyles {
  static const double iconSize = 32.0;
  static const double iconContainerSize = 64.0;
  static const double titleFontSize = 24.0;
  static const double subtitleFontSize = 14.0;
  static const double cardPadding = 20.0;
  static const double sectionSpacing = 32.0;
  static const double itemSpacing = 24.0;
  static const double smallSpacing = 8.0;
  static const double borderRadius = 16.0;
  static const double smallBorderRadius = 12.0;
  static const double tinyBorderRadius = 8.0;
}

/// Common reusable widgets for onboarding steps
class OnboardingCommonWidgets {
  /// Creates a gradient icon container
  static Widget buildIconContainer({
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      width: OnboardingStyles.iconContainerSize,
      height: OnboardingStyles.iconContainerSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(OnboardingStyles.borderRadius),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: OnboardingStyles.iconSize,
      ),
    );
  }

  /// Creates a step header with icon, title and subtitle
  static Widget buildStepHeader({
    required IconData icon,
    required List<Color> gradientColors,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        buildIconContainer(icon: icon, gradientColors: gradientColors),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: OnboardingStyles.titleFontSize,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: OnboardingStyles.smallSpacing),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: OnboardingStyles.subtitleFontSize,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: OnboardingStyles.sectionSpacing),
      ],
    );
  }

  /// Creates a card container with consistent styling
  static Widget buildCard({
    required Widget child,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
    Gradient? gradient,
    EdgeInsets? padding,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(OnboardingStyles.cardPadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.cardBackground,
        gradient: gradient,
        borderRadius: BorderRadius.circular(OnboardingStyles.borderRadius),
        border: Border.all(
          color: borderColor ?? AppTheme.borderColor,
          width: borderWidth ?? 1,
        ),
      ),
      child: child,
    );
  }

  /// Creates a recommendation/info card
  static Widget buildInfoCard({
    required String message,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? borderColor,
  }) {
    return buildCard(
      backgroundColor: backgroundColor,
      borderColor: borderColor ?? AppTheme.primaryBlue.withOpacity(0.2),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(OnboardingStyles.smallSpacing),
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.primaryBlue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(OnboardingStyles.tinyBorderRadius),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppTheme.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: OnboardingStyles.subtitleFontSize,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a section title
  static Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
    );
  }

  /// Creates a selectable chip
  static Widget buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryBlue.withOpacity(0.1) 
              : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(OnboardingStyles.smallBorderRadius),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryBlue 
                : AppTheme.borderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: OnboardingStyles.subtitleFontSize,
            fontWeight: FontWeight.w500,
            color: isSelected 
                ? AppTheme.primaryBlue 
                : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  /// Creates a value display badge
  static Widget buildValueBadge({
    required String value,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(OnboardingStyles.smallBorderRadius),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor ?? AppTheme.primaryBlue,
        ),
      ),
    );
  }

  /// Creates a feedback message with icon and color coding
  static Widget buildFeedbackMessage({
    required String message,
    required Color color,
    required IconData icon,
    double fontSize = 12,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(OnboardingStyles.tinyBorderRadius),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: OnboardingStyles.smallSpacing),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: fontSize,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sleep duration validation logic
class SleepDurationValidator {
  static const double minOptimalHours = 7.0;
  static const double maxOptimalHours = 9.0;
  static const double criticalShortHours = 6.0;
  static const double criticalLongHours = 10.0;

  static bool isOptimal(double duration) {
    return duration >= minOptimalHours && duration <= maxOptimalHours;
  }

  static Color getDurationColor(double duration) {
    if (isOptimal(duration)) return AppTheme.successGreen;
    if (duration < minOptimalHours) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }

  static IconData getDurationIcon(double duration) {
    if (isOptimal(duration)) return Icons.check_circle;
    if (duration < minOptimalHours) return Icons.schedule;
    return Icons.access_time_filled;
  }

  static String getDurationMessage(double duration) {
    if (duration < criticalShortHours) {
      return 'Too short - aim for 7-9 hours for optimal health';
    } else if (duration < minOptimalHours) {
      return 'A bit short - consider going to bed 30-60 minutes earlier';
    } else if (duration <= maxOptimalHours) {
      return 'Perfect! This aligns with sleep expert recommendations';
    } else if (duration <= criticalLongHours) {
      return 'Slightly long - you might feel groggy from oversleeping';
    } else {
      return 'Too long - consider adjusting your schedule';
    }
  }

  static IconData getMessageIcon(double duration) {
    if (duration < criticalShortHours || duration > criticalLongHours) {
      return Icons.warning_rounded;
    } else if (duration < minOptimalHours || duration > maxOptimalHours) {
      return Icons.info_outline;
    } else {
      return Icons.check_circle_outline;
    }
  }
}

/// Time utilities
class TimeUtils {
  static double calculateSleepDuration(TimeOfDay bedtime, TimeOfDay wakeTime) {
    double bedtimeHours = bedtime.hour + bedtime.minute / 60.0;
    double wakeTimeHours = wakeTime.hour + wakeTime.minute / 60.0;
    
    double duration = wakeTimeHours - bedtimeHours;
    if (duration <= 0) duration += 24; // Handle overnight sleep
    
    return duration;
  }

  static String formatDuration(double duration) {
    int hours = duration.floor();
    int minutes = ((duration - hours) * 60).round();
    
    if (minutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h ${minutes}m';
    }
  }
}
