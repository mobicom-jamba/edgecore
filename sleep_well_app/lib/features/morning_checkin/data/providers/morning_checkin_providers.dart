import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database.dart';
import '../models/morning_checkin.dart';

// Check-in form state providers
final inBedOnTimeProvider = StateProvider<bool?>((ref) => null);
final energyLevelProvider = StateProvider<int>((ref) => 0);
final moodLevelProvider = StateProvider<int>((ref) => 0);
final checkinCompletedProvider = StateProvider<bool>((ref) => false);

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

// Recent check-ins provider
final recentCheckinsProvider = FutureProvider<List<MorningCheckin>>((ref) async {
  final isar = DatabaseService.instance;
  return await isar.morningCheckins
      .where()
      .sortByDateDesc()
      .limit(7)
      .findAll();
});

// Today's check-in provider
final todaysCheckinProvider = FutureProvider<MorningCheckin?>((ref) async {
  final isar = DatabaseService.instance;
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  
  final checkins = await isar.morningCheckins
      .where()
      .findAll();
  
  // Filter by date range
  for (final checkin in checkins) {
    if (checkin.date.isAfter(startOfDay) && checkin.date.isBefore(endOfDay)) {
      return checkin;
    }
  }
  
  return null;
});
