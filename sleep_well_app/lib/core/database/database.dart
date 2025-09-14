import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/morning_checkin/data/models/morning_checkin.dart';
import '../../features/notifications/data/models/nudge_event.dart';
import '../../features/onboarding/data/models/user_prefs.dart';
import '../../features/onboarding/data/models/chronotype.dart';
import '../../features/onboarding/data/models/ritual.dart';
import '../../features/wind_down/data/models/ritual_log.dart';

class DatabaseService {
  static late Isar _isar;
  
  static Isar get instance => _isar;
  
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [
        UserPrefsSchema,
        MorningCheckinSchema,
        RitualLogSchema,
        NudgeEventSchema,
      ],
      directory: dir.path,
      name: 'sleep_well_db',
    );
  }
  
  // User preferences methods
  static Future<void> saveUserPrefs({
    required TimeOfDay bedtime,
    required TimeOfDay wakeTime,
  }) async {
    final userPrefs = UserPrefs()
      ..bedtimeHour = bedtime.hour
      ..bedtimeMinute = bedtime.minute
      ..wakeTimeHour = wakeTime.hour
      ..wakeTimeMinute = wakeTime.minute
      ..updatedAt = DateTime.now();
    
    await _isar.writeTxn(() async {
      await _isar.userPrefs.put(userPrefs);
    });
  }
  
  static Future<UserPrefs?> getUserPrefs() async {
    return await _isar.userPrefs.where().findFirst();
  }
  
  // Chronotype methods
  static Future<void> saveChronotype(Chronotype chronotype) async {
    final userPrefs = await getUserPrefs() ?? UserPrefs();
    userPrefs.chronotype = chronotype.name;
    userPrefs.updatedAt = DateTime.now();
    
    await _isar.writeTxn(() async {
      await _isar.userPrefs.put(userPrefs);
    });
  }
  
  // Rituals methods
  static Future<void> saveRituals(List<Ritual> rituals) async {
    final userPrefs = await getUserPrefs() ?? UserPrefs();
    userPrefs.selectedRituals = rituals.map((r) => r.type.name).toList();
    userPrefs.updatedAt = DateTime.now();
    
    await _isar.writeTxn(() async {
      await _isar.userPrefs.put(userPrefs);
    });
  }
  
  // Sleep buddy methods
  static Future<void> saveSleepBuddy(SleepBuddy buddy) async {
    final userPrefs = await getUserPrefs() ?? UserPrefs();
    userPrefs.buddyName = buddy.name;
    userPrefs.buddyPhone = buddy.phoneNumber;
    userPrefs.updatedAt = DateTime.now();
    
    await _isar.writeTxn(() async {
      await _isar.userPrefs.put(userPrefs);
    });
  }
  
  static Future<void> close() async {
    await _isar.close();
  }
  
  static Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }
  
  static Future<Map<String, dynamic>> exportData() async {
    final userPrefs = await _isar.userPrefs.where().findAll();
    final checkins = await _isar.morningCheckins.where().findAll();
    final ritualLogs = await _isar.ritualLogs.where().findAll();
    final nudgeEvents = await _isar.nudgeEvents.where().findAll();
    
    return {
      'userPrefs': userPrefs.map((e) => e.toJson()).toList(),
      'morningCheckins': checkins.map((e) => e.toJson()).toList(),
      'ritualLogs': ritualLogs.map((e) => e.toJson()).toList(),
      'nudgeEvents': nudgeEvents.map((e) => e.toJson()).toList(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }
}

// Database provider for Riverpod
final databaseProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});
