import 'package:isar/isar.dart';

part 'nudge_event.g.dart';

@Collection()
class NudgeEvent {
  Id id = Isar.autoIncrement;
  
  late DateTime timestamp;
  
  @Enumerated(EnumType.ordinal)
  late int nudgeKindIndex;
  
  bool ritualCompleted = false;
  String? notes;
  
  NudgeEvent();
  
  NudgeEvent.create({
    this.id = Isar.autoIncrement,
    required this.timestamp,
    required NudgeKind nudgeKind,
    this.ritualCompleted = false,
    this.notes,
  }) {
    nudgeKindIndex = nudgeKind.index;
  }
  
  // Helper getter for nudge kind
  @ignore
  NudgeKind get nudgeKind => NudgeKind.values[nudgeKindIndex];
  
  // Helper setter for nudge kind
  set nudgeKind(NudgeKind value) => nudgeKindIndex = value.index;
  
  // Copy method for convenience
  NudgeEvent copyWith({
    Id? id,
    DateTime? timestamp,
    NudgeKind? nudgeKind,
    bool? ritualCompleted,
    String? notes,
  }) {
    final copy = NudgeEvent();
    copy.id = id ?? this.id;
    copy.timestamp = timestamp ?? this.timestamp;
    copy.nudgeKind = nudgeKind ?? this.nudgeKind;
    copy.ritualCompleted = ritualCompleted ?? this.ritualCompleted;
    copy.notes = notes ?? this.notes;
    return copy;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'nudgeKindIndex': nudgeKindIndex,
      'nudgeKind': nudgeKind.name,
      'ritualCompleted': ritualCompleted,
      'notes': notes,
    };
  }
}

enum NudgeKind { bedtimeReminder, pastBedtimeNudge, buddyCheck }

extension NudgeKindExtension on NudgeKind {
  String get displayName {
    switch (this) {
      case NudgeKind.bedtimeReminder:
        return 'Bedtime Reminder';
      case NudgeKind.pastBedtimeNudge:
        return 'Past Bedtime Nudge';
      case NudgeKind.buddyCheck:
        return 'Buddy Check';
    }
  }
  
  String get description {
    switch (this) {
      case NudgeKind.bedtimeReminder:
        return 'Gentle reminder to start wind-down routine';
      case NudgeKind.pastBedtimeNudge:
        return 'Nudge when past bedtime without wind-down';
      case NudgeKind.buddyCheck:
        return 'Check-in with your sleep buddy';
    }
  }
}
