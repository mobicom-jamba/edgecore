import 'package:flutter/material.dart';

enum RitualType {
  meditation('Meditation', '5-10 minutes of mindfulness', Icons.self_improvement_outlined),
  reading('Reading', 'Relax with a good book', Icons.menu_book_outlined),
  journaling('Journaling', 'Reflect on your day', Icons.edit_note_outlined),
  stretching('Gentle Stretching', 'Release tension from the day', Icons.fitness_center_outlined),
  breathing('Breathing Exercises', 'Calm your nervous system', Icons.air_outlined),
  music('Calm Music', 'Listen to soothing sounds', Icons.music_note_outlined),
  tea('Herbal Tea', 'Warm, caffeine-free relaxation', Icons.local_drink_outlined),
  gratitude('Gratitude Practice', 'Focus on positive moments', Icons.favorite_outline);

  const RitualType(this.displayName, this.description, this.icon);
  
  final String displayName;
  final String description;
  final IconData icon;
}

class Ritual {
  final RitualType type;
  final int durationMinutes;
  final bool isEnabled;
  
  const Ritual({
    required this.type,
    required this.durationMinutes,
    this.isEnabled = true,
  });
  
  Ritual copyWith({
    RitualType? type,
    int? durationMinutes,
    bool? isEnabled,
  }) {
    return Ritual(
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class SleepBuddy {
  final String name;
  final String phoneNumber;
  final bool isEnabled;
  
  const SleepBuddy({
    required this.name,
    required this.phoneNumber,
    this.isEnabled = true,
  });
  
  SleepBuddy copyWith({
    String? name,
    String? phoneNumber,
    bool? isEnabled,
  }) {
    return SleepBuddy(
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class OnboardingRituals {
  final List<Ritual> selectedRituals;
  final SleepBuddy? buddy;
  
  const OnboardingRituals({
    required this.selectedRituals,
    this.buddy,
  });
  
  OnboardingRituals copyWith({
    List<Ritual>? selectedRituals,
    SleepBuddy? buddy,
  }) {
    return OnboardingRituals(
      selectedRituals: selectedRituals ?? this.selectedRituals,
      buddy: buddy ?? this.buddy,
    );
  }
  
  static const List<Ritual> defaultRituals = [
    Ritual(type: RitualType.meditation, durationMinutes: 5),
    Ritual(type: RitualType.reading, durationMinutes: 10),
    Ritual(type: RitualType.breathing, durationMinutes: 3),
  ];
}
