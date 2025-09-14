import 'package:isar/isar.dart';
import 'package:flutter/material.dart';

part 'user_prefs.g.dart';

@Collection()
class UserPrefs {
  Id id = Isar.autoIncrement;
  
  int bedtimeHour = 22; // 24-hour format
  int bedtimeMinute = 30;
  int wakeTimeHour = 7; // 24-hour format
  int wakeTimeMinute = 0;
  
  String? chronotype; // Store as string for new chronotype enum
  List<String> selectedRituals = []; // Store ritual type names
  String? buddyName;
  String? buddyPhone; // Changed from buddyContact to buddyPhone
  
  bool hasCompletedOnboarding = false;
  bool notificationsEnabled = true;
  bool reduceMotion = false;
  bool lofiSoundEnabled = true;
  bool highContrast = false;
  String timezone = 'UTC';
  
  DateTime updatedAt = DateTime.now();
  
  UserPrefs();
  
  // Helper getter for TimeOfDay
  @ignore
  TimeOfDay get bedtime => TimeOfDay(hour: bedtimeHour, minute: bedtimeMinute);
  
  @ignore
  TimeOfDay get wakeTime => TimeOfDay(hour: wakeTimeHour, minute: wakeTimeMinute);
  
  // Copy method for convenience
  UserPrefs copyWith({
    Id? id,
    int? bedtimeHour,
    int? bedtimeMinute,
    int? wakeTimeHour,
    int? wakeTimeMinute,
    String? chronotype,
    List<String>? selectedRituals,
    String? buddyName,
    String? buddyPhone,
    bool? hasCompletedOnboarding,
    bool? notificationsEnabled,
    bool? reduceMotion,
    bool? lofiSoundEnabled,
    bool? highContrast,
    String? timezone,
    DateTime? updatedAt,
  }) {
    final copy = UserPrefs();
    copy.id = id ?? this.id;
    copy.bedtimeHour = bedtimeHour ?? this.bedtimeHour;
    copy.bedtimeMinute = bedtimeMinute ?? this.bedtimeMinute;
    copy.wakeTimeHour = wakeTimeHour ?? this.wakeTimeHour;
    copy.wakeTimeMinute = wakeTimeMinute ?? this.wakeTimeMinute;
    copy.chronotype = chronotype ?? this.chronotype;
    copy.selectedRituals = selectedRituals ?? this.selectedRituals;
    copy.buddyName = buddyName ?? this.buddyName;
    copy.buddyPhone = buddyPhone ?? this.buddyPhone;
    copy.hasCompletedOnboarding = hasCompletedOnboarding ?? this.hasCompletedOnboarding;
    copy.notificationsEnabled = notificationsEnabled ?? this.notificationsEnabled;
    copy.reduceMotion = reduceMotion ?? this.reduceMotion;
    copy.lofiSoundEnabled = lofiSoundEnabled ?? this.lofiSoundEnabled;
    copy.highContrast = highContrast ?? this.highContrast;
    copy.timezone = timezone ?? this.timezone;
    copy.updatedAt = updatedAt ?? this.updatedAt;
    return copy;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bedtimeHour': bedtimeHour,
      'bedtimeMinute': bedtimeMinute,
      'wakeTimeHour': wakeTimeHour,
      'wakeTimeMinute': wakeTimeMinute,
      'chronotype': chronotype,
      'selectedRituals': selectedRituals,
      'buddyName': buddyName,
      'buddyPhone': buddyPhone,
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'notificationsEnabled': notificationsEnabled,
      'reduceMotion': reduceMotion,
      'lofiSoundEnabled': lofiSoundEnabled,
      'highContrast': highContrast,
      'timezone': timezone,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
