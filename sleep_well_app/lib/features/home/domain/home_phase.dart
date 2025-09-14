import 'package:flutter/material.dart';

/// Home phase enum representing the current time-based state
enum HomePhase {
  morning,
  daytime,
  evening,
}

/// Home phase data containing the current phase and related information
class HomePhaseData {
  final HomePhase phase;
  final Duration timeUntilBedtime;
  final Duration timeUntilWake;
  final double eveningProgress;
  final bool isPastBedtime;
  final bool isWindDownTime;

  const HomePhaseData({
    required this.phase,
    required this.timeUntilBedtime,
    required this.timeUntilWake,
    required this.eveningProgress,
    required this.isPastBedtime,
    required this.isWindDownTime,
  });
}

/// Pure function to determine the current home phase based on time and preferences
HomePhaseData getHomePhase({
  required DateTime now,
  required TimeOfDay bedtime,
  required TimeOfDay wakeTime,
}) {
  // Calculate bedtime and wake times for today
  final todayBedtime = DateTime(
    now.year,
    now.month,
    now.day,
    bedtime.hour,
    bedtime.minute,
  );
  
  final todayWakeTime = DateTime(
    now.year,
    now.month,
    now.day,
    wakeTime.hour,
    wakeTime.minute,
  );
  
  // Calculate tomorrow's bedtime and wake time
  final tomorrowBedtime = todayBedtime.add(const Duration(days: 1));
  final tomorrowWakeTime = todayWakeTime.add(const Duration(days: 1));
  
  // Determine if we're past bedtime today
  final isPastBedtime = now.isAfter(todayBedtime);
  
  // Calculate time until next bedtime
  final timeUntilBedtime = isPastBedtime 
      ? tomorrowBedtime.difference(now)
      : todayBedtime.difference(now);
  
  // Calculate time until next wake time
  final timeUntilWake = now.isBefore(todayWakeTime)
      ? todayWakeTime.difference(now)
      : tomorrowWakeTime.difference(now);
  
  // Determine if we're in wind-down time (30 minutes before bedtime)
  final isWindDownTime = timeUntilBedtime.inMinutes <= 30 && !isPastBedtime;
  
  // Calculate evening progress (0.0 to 1.0)
  final eveningProgress = _calculateEveningProgress(
    timeUntilBedtime,
    isPastBedtime,
  );
  
  // Determine the current phase
  final phase = _determinePhase(
    now,
    todayWakeTime,
    todayBedtime,
    isWindDownTime,
    isPastBedtime,
  );
  
  return HomePhaseData(
    phase: phase,
    timeUntilBedtime: timeUntilBedtime,
    timeUntilWake: timeUntilWake,
    eveningProgress: eveningProgress,
    isPastBedtime: isPastBedtime,
    isWindDownTime: isWindDownTime,
  );
}

/// Calculate evening progress as a value between 0.0 and 1.0
/// Progress starts 30 minutes before bedtime and reaches 1.0 at bedtime
double _calculateEveningProgress(Duration timeUntilBedtime, bool isPastBedtime) {
  if (isPastBedtime) {
    return 1.0; // Past bedtime, progress is complete
  }
  
  final minutesUntilBed = timeUntilBedtime.inMinutes;
  
  if (minutesUntilBed > 30) {
    return 0.0; // Not yet in wind-down time
  }
  
  // Calculate progress from 0.0 to 1.0 over 30 minutes
  final progress = (30 - minutesUntilBed) / 30;
  return progress.clamp(0.0, 1.0);
}

/// Determine the current home phase based on time of day
HomePhase _determinePhase(
  DateTime now,
  DateTime todayWakeTime,
  DateTime todayBedtime,
  bool isWindDownTime,
  bool isPastBedtime,
) {
  // Morning phase: from wake time to 2 hours after wake time
  final morningEnd = todayWakeTime.add(const Duration(hours: 2));
  if (now.isAfter(todayWakeTime) && now.isBefore(morningEnd)) {
    return HomePhase.morning;
  }
  
  // Evening phase: 30 minutes before bedtime or past bedtime
  if (isWindDownTime || isPastBedtime) {
    return HomePhase.evening;
  }
  
  // Daytime phase: everything else
  return HomePhase.daytime;
}

/// Format duration for display with proper pluralization
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  
  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes}m';
  }
}

/// Format time with tabular numerals for consistent layout
String formatTime(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}

/// Get phase-specific microcopy
String getPhaseMicrocopy(HomePhase phase, {bool isPastBedtime = false}) {
  switch (phase) {
    case HomePhase.morning:
      return 'Good morning! How did you sleep?';
    case HomePhase.daytime:
      return 'Ready for a great night\'s sleep.';
    case HomePhase.evening:
      if (isPastBedtime) {
        return 'Still up? One minute to calm your mind.';
      } else {
        return 'Let\'s wind down — 60 seconds to set tomorrow up.';
      }
  }
}

/// Get primary action text for the current phase
String getPrimaryActionText(HomePhase phase, {bool isPastBedtime = false}) {
  switch (phase) {
    case HomePhase.morning:
      return 'Morning Check-in';
    case HomePhase.daytime:
      return 'Edit schedule';
    case HomePhase.evening:
      return 'Start wind-down';
  }
}
