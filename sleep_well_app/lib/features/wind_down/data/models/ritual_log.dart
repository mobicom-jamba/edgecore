import 'package:isar/isar.dart';

part 'ritual_log.g.dart';

@Collection()
class RitualLog {
  Id id = Isar.autoIncrement;
  
  late DateTime date;
  
  @Enumerated(EnumType.ordinal)
  late int ritualTypeIndex;
  
  late int durationSec;
  bool completed = false;
  String? notes;
  
  RitualLog();
  
  RitualLog.create({
    this.id = Isar.autoIncrement,
    required this.date,
    required RitualType ritualType,
    required this.durationSec,
    this.completed = false,
    this.notes,
  }) {
    ritualTypeIndex = ritualType.index;
  }
  
  // Helper getter for ritual type
  @ignore
  RitualType get ritualType => RitualType.values[ritualTypeIndex];
  
  // Helper setter for ritual type
  set ritualType(RitualType value) => ritualTypeIndex = value.index;
  
  // Copy method for convenience
  RitualLog copyWith({
    Id? id,
    DateTime? date,
    RitualType? ritualType,
    int? durationSec,
    bool? completed,
    String? notes,
  }) {
    final copy = RitualLog();
    copy.id = id ?? this.id;
    copy.date = date ?? this.date;
    copy.ritualType = ritualType ?? this.ritualType;
    copy.durationSec = durationSec ?? this.durationSec;
    copy.completed = completed ?? this.completed;
    copy.notes = notes ?? this.notes;
    return copy;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'ritualTypeIndex': ritualTypeIndex,
      'ritualType': ritualType.name,
      'durationSec': durationSec,
      'completed': completed,
      'notes': notes,
    };
  }
}

enum RitualType { plantAndPlan, gratitudeAndGround, progressAndPromise }

extension RitualTypeExtension on RitualType {
  String get displayName {
    switch (this) {
      case RitualType.plantAndPlan:
        return 'Plant & Plan';
      case RitualType.gratitudeAndGround:
        return 'Gratitude & Ground';
      case RitualType.progressAndPromise:
        return 'Progress & Promise';
    }
  }
  
  String get description {
    switch (this) {
      case RitualType.plantAndPlan:
        return 'Tend to a plant and plan tomorrow\'s top 3 tasks';
      case RitualType.gratitudeAndGround:
        return 'Write 3 things you\'re grateful for and ground yourself';
      case RitualType.progressAndPromise:
        return 'Reflect on today\'s progress and make a promise to tomorrow';
    }
  }
  
  String get instructions {
    switch (this) {
      case RitualType.plantAndPlan:
        return 'Water a plant, then write down your top 3 tasks for tomorrow. Take deep breaths as you plan.';
      case RitualType.gratitudeAndGround:
        return 'Write 3 things you\'re grateful for today. Feel your feet on the ground and breathe deeply.';
      case RitualType.progressAndPromise:
        return 'Think of one thing you did well today. Make a small promise to yourself for tomorrow.';
    }
  }
  
  Duration get suggestedDuration {
    switch (this) {
      case RitualType.plantAndPlan:
        return const Duration(minutes: 2);
      case RitualType.gratitudeAndGround:
        return const Duration(minutes: 1);
      case RitualType.progressAndPromise:
        return const Duration(minutes: 1);
    }
  }
  
  String get icon {
    switch (this) {
      case RitualType.plantAndPlan:
        return '🌱';
      case RitualType.gratitudeAndGround:
        return '🙏';
      case RitualType.progressAndPromise:
        return '⭐';
    }
  }
}
