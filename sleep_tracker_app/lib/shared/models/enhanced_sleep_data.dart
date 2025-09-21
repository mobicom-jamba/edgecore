import 'package:flutter/material.dart';

enum SleepStageType { deep, light, rem, awake }

class SleepStage {
  final SleepStageType type;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;

  SleepStage({
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });
}

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}

class SleepInsight {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String actionText;
  final VoidCallback? onAction;

  SleepInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.actionText,
    this.onAction,
  });
}

class EnhancedSleepData {
  final DateTime bedtime;
  final DateTime wakeTime;
  final Duration totalSleep;
  final Duration sleepGoal;
  final int qualityScore;
  final String qualityLabel;
  final Duration sleepDebt;
  final List<SleepStage> stages;
  final Map<SleepStageType, Duration> stageDurations;
  final Map<SleepStageType, double> stagePercentages;
  final String topInsight;
  final String nextAction;
  final int recoveryNightsNeeded;
  final int consistencyStreak;
  final double weeklyTrendPercentage;

  EnhancedSleepData({
    required this.bedtime,
    required this.wakeTime,
    required this.totalSleep,
    required this.sleepGoal,
    required this.qualityScore,
    required this.qualityLabel,
    required this.sleepDebt,
    required this.stages,
    required this.stageDurations,
    required this.stagePercentages,
    required this.topInsight,
    required this.nextAction,
    required this.recoveryNightsNeeded,
    required this.consistencyStreak,
    required this.weeklyTrendPercentage,
  });

  // Helper methods
  String get formattedTotalSleep => 
      '${totalSleep.inHours}h ${totalSleep.inMinutes.remainder(60)}m';
  
  String get formattedSleepGoal => 
      '${sleepGoal.inHours}h ${sleepGoal.inMinutes.remainder(60)}m';
  
  String get formattedSleepDebt {
    final hours = sleepDebt.abs().inHours;
    final minutes = sleepDebt.abs().inMinutes.remainder(60);
    final sign = sleepDebt.isNegative ? '-' : '+';
    if (hours > 0) {
      return '$sign${hours}h ${minutes}m';
    }
    return '$sign${minutes}m';
  }

  double get sleepGoalProgress => totalSleep.inMinutes / sleepGoal.inMinutes;

  String get recoveryText {
    if (sleepDebt.isNegative && recoveryNightsNeeded > 0) {
      return 'Need $recoveryNightsNeeded nights to recover';
    } else if (sleepDebt.inMinutes > 0) {
      return 'Sleep surplus - great job!';
    }
    return 'On track with sleep goals';
  }
}

class SleepColors {
  // Sleep stages with high contrast
  static const Color deepSleep = Color(0xFF1919E6);      // Primary blue
  static const Color lightSleep = Color(0xFF4A90E2);     // Medium blue  
  static const Color remSleep = Color(0xFF7B68EE);       // Purple
  static const Color awake = Color(0xFFFF6B6B);          // Red
  
  // Status colors
  static const Color sleepDebtNegative = Color(0xFFFF6B6B);
  static const Color sleepDebtPositive = Color(0xFF00D4AA);
  static const Color qualityGood = Color(0xFF00D4AA);
  static const Color qualityFair = Color(0xFFFFB800);
  static const Color qualityPoor = Color(0xFFFF6B6B);
  
  // Background colors
  static const Color background = Color(0xFF111121);
  static const Color cardBackground = Color(0xFF1A1A2E);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8CC);
  static const Color textTertiary = Color(0xFF8E8EA0);

  static Color getStageColor(SleepStageType type) {
    switch (type) {
      case SleepStageType.deep:
        return deepSleep;
      case SleepStageType.light:
        return lightSleep;
      case SleepStageType.rem:
        return remSleep;
      case SleepStageType.awake:
        return awake;
    }
  }

  static Color getQualityColor(int score) {
    if (score >= 80) return qualityGood;
    if (score >= 60) return qualityFair;
    return qualityPoor;
  }

  static String getQualityLabel(int score) {
    if (score >= 80) return 'Good';
    if (score >= 60) return 'Fair';
    return 'Poor';
  }
}
