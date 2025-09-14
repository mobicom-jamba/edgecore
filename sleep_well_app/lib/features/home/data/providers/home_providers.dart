import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database.dart';
import '../../../onboarding/data/models/user_prefs.dart';
import '../../../morning_checkin/data/models/morning_checkin.dart';
import '../../domain/home_phase.dart';

// Home state provider
final homeProvider = FutureProvider<void>((ref) async {
  // This provider can be used to load any initial data needed for the home screen
  await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
});

// User preferences provider
final userPrefsProvider = FutureProvider<UserPrefs>((ref) async {
  final isar = DatabaseService.instance;
  final prefs = await isar.userPrefs.where().findFirst();
  
  if (prefs == null) {
    // Return default preferences if none exist
    return UserPrefs();
  }
  
  return prefs;
});

// Bedtime time provider
final bedtimeTimeProvider = Provider<TimeOfDay>((ref) {
  final prefsAsync = ref.watch(userPrefsProvider);
  
  return prefsAsync.when(
    data: (prefs) => TimeOfDay(
      hour: prefs.bedtimeHour,
      minute: prefs.bedtimeMinute,
    ),
    loading: () => const TimeOfDay(hour: 22, minute: 30),
    error: (_, __) => const TimeOfDay(hour: 22, minute: 30),
  );
});

// Wake time provider
final wakeTimeProvider = Provider<TimeOfDay>((ref) {
  final prefsAsync = ref.watch(userPrefsProvider);
  
  return prefsAsync.when(
    data: (prefs) => TimeOfDay(
      hour: prefs.wakeTimeHour,
      minute: prefs.wakeTimeMinute,
    ),
    loading: () => const TimeOfDay(hour: 7, minute: 0),
    error: (_, __) => const TimeOfDay(hour: 7, minute: 0),
  );
});

// Time until bedtime provider
final timeUntilBedtimeProvider = Provider<Duration>((ref) {
  final bedtimeTime = ref.watch(bedtimeTimeProvider);
  final now = DateTime.now();
  final bedtime = DateTime(
    now.year,
    now.month,
    now.day,
    bedtimeTime.hour,
    bedtimeTime.minute,
  );
  
  // If bedtime has passed today, calculate for tomorrow
  if (bedtime.isBefore(now)) {
    final tomorrowBedtime = bedtime.add(const Duration(days: 1));
    return tomorrowBedtime.difference(now);
  }
  
  return bedtime.difference(now);
});

// Streak days provider
final streakDaysProvider = FutureProvider<int>((ref) async {
  final isar = DatabaseService.instance;
  final checkins = await isar.morningCheckins
      .where()
      .sortByDateDesc()
      .findAll();
  
  var streak = 0;
  var currentDate = DateTime.now();
  
  for (final checkin in checkins) {
    final checkinDate = DateTime(
      checkin.date.year,
      checkin.date.month,
      checkin.date.day,
    );
    final expectedDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );
    
    if (checkinDate.isAtSameMomentAs(expectedDate) && checkin.inBedOnTime) {
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }
  
  return streak;
});

// Home phase data provider
final homePhaseProvider = Provider<HomePhaseData>((ref) {
  final bedtimeTime = ref.watch(bedtimeTimeProvider);
  final wakeTime = ref.watch(wakeTimeProvider);
  final now = DateTime.now();
  
  return getHomePhase(
    now: now,
    bedtime: bedtimeTime,
    wakeTime: wakeTime,
  );
});

// Should show sticky CTA provider (evening phase only)
final shouldShowStickyCTAProvider = Provider<bool>((ref) {
  final homePhase = ref.watch(homePhaseProvider);
  return homePhase.phase == HomePhase.evening;
});

// Should show past bedtime nudge provider
final shouldShowPastBedtimeNudgeProvider = Provider<bool>((ref) {
  final homePhase = ref.watch(homePhaseProvider);
  final prefsAsync = ref.watch(userPrefsProvider);
  
  return prefsAsync.when(
    data: (prefs) {
      // Show nudge if past bedtime and notifications are enabled
      return homePhase.isPastBedtime && prefs.notificationsEnabled;
    },
    loading: () => false,
    error: (_, __) => false,
  );
});

// Evening progress provider (0.0 to 1.0)
final eveningProgressProvider = Provider<double>((ref) {
  final homePhase = ref.watch(homePhaseProvider);
  return homePhase.eveningProgress;
});

// Should pulse countdown ring provider (T-5 minutes)
final shouldPulseCountdownProvider = Provider<bool>((ref) {
  final homePhase = ref.watch(homePhaseProvider);
  return homePhase.phase == HomePhase.evening && 
         homePhase.timeUntilBedtime.inMinutes <= 5;
});
