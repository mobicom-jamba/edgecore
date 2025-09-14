import 'package:isar/isar.dart';

part 'morning_checkin.g.dart';

@Collection()
class MorningCheckin {
  Id id = Isar.autoIncrement;
  
  late DateTime date;
  late bool inBedOnTime;
  late int energy; // 1-5 scale
  late int mood; // 1-5 scale
  String? notes;
  int streakDays = 0;
  
  MorningCheckin();
  
  MorningCheckin.create({
    this.id = Isar.autoIncrement,
    required this.date,
    required this.inBedOnTime,
    required this.energy,
    required this.mood,
    this.notes,
    this.streakDays = 0,
  });
  
  // Copy method for convenience
  MorningCheckin copyWith({
    Id? id,
    DateTime? date,
    bool? inBedOnTime,
    int? energy,
    int? mood,
    String? notes,
    int? streakDays,
  }) {
    final copy = MorningCheckin();
    copy.id = id ?? this.id;
    copy.date = date ?? this.date;
    copy.inBedOnTime = inBedOnTime ?? this.inBedOnTime;
    copy.energy = energy ?? this.energy;
    copy.mood = mood ?? this.mood;
    copy.notes = notes ?? this.notes;
    copy.streakDays = streakDays ?? this.streakDays;
    return copy;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'inBedOnTime': inBedOnTime,
      'energy': energy,
      'energyLevel': EnergyLevel.values[energy - 1].name,
      'mood': mood,
      'moodLevel': MoodLevel.values[mood - 1].name,
      'notes': notes,
      'streakDays': streakDays,
    };
  }
}

enum EnergyLevel { veryLow, low, medium, high, veryHigh }

enum MoodLevel { veryPoor, poor, neutral, good, veryGood }

extension EnergyLevelExtension on EnergyLevel {
  static EnergyLevel fromInt(int value) {
    switch (value) {
      case 1: return EnergyLevel.veryLow;
      case 2: return EnergyLevel.low;
      case 3: return EnergyLevel.medium;
      case 4: return EnergyLevel.high;
      case 5: return EnergyLevel.veryHigh;
      default: return EnergyLevel.medium;
    }
  }
  
  int get value {
    switch (this) {
      case EnergyLevel.veryLow: return 1;
      case EnergyLevel.low: return 2;
      case EnergyLevel.medium: return 3;
      case EnergyLevel.high: return 4;
      case EnergyLevel.veryHigh: return 5;
    }
  }
  
  String get displayName {
    switch (this) {
      case EnergyLevel.veryLow: return 'Very Low';
      case EnergyLevel.low: return 'Low';
      case EnergyLevel.medium: return 'Medium';
      case EnergyLevel.high: return 'High';
      case EnergyLevel.veryHigh: return 'Very High';
    }
  }
}

extension MoodLevelExtension on MoodLevel {
  static MoodLevel fromInt(int value) {
    switch (value) {
      case 1: return MoodLevel.veryPoor;
      case 2: return MoodLevel.poor;
      case 3: return MoodLevel.neutral;
      case 4: return MoodLevel.good;
      case 5: return MoodLevel.veryGood;
      default: return MoodLevel.neutral;
    }
  }
  
  int get value {
    switch (this) {
      case MoodLevel.veryPoor: return 1;
      case MoodLevel.poor: return 2;
      case MoodLevel.neutral: return 3;
      case MoodLevel.good: return 4;
      case MoodLevel.veryGood: return 5;
    }
  }
  
  String get displayName {
    switch (this) {
      case MoodLevel.veryPoor: return 'Very Poor';
      case MoodLevel.poor: return 'Poor';
      case MoodLevel.neutral: return 'Neutral';
      case MoodLevel.good: return 'Good';
      case MoodLevel.veryGood: return 'Very Good';
    }
  }
}
