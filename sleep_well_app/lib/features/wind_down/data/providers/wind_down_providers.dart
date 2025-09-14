import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database.dart';
import '../../../onboarding/data/models/user_prefs.dart';
import '../models/ritual_log.dart';

// Selected rituals provider (from user preferences)
final selectedRitualsProvider = FutureProvider<List<RitualType>>((ref) async {
  final isar = DatabaseService.instance;
  final prefs = await isar.userPrefs.where().findFirst();
  
  if (prefs == null) {
    return [];
  }
  
  // For now, return all ritual types as selected
  // In a real app, this would be stored in user preferences
  return RitualType.values;
});

// Current ritual index provider
final currentRitualIndexProvider = StateProvider<int>((ref) => 0);

// Ritual duration provider (in seconds)
final ritualDurationProvider = StateProvider<int>((ref) => 0);

// Ritual timer running provider
final ritualTimerRunningProvider = StateProvider<bool>((ref) => false);

// Wind-down completed provider
final windDownCompletedProvider = StateProvider<bool>((ref) => false);

// Audio playing provider
final audioPlayingProvider = StateProvider<bool>((ref) => false);

// DND enabled provider
final dndEnabledProvider = StateProvider<bool>((ref) => false);

// Ritual timer provider (manages the countdown)
final ritualTimerProvider = StateNotifierProvider<RitualTimerNotifier, int>((ref) => RitualTimerNotifier());

class RitualTimerNotifier extends StateNotifier<int> {
  RitualTimerNotifier() : super(0);
  
  void startTimer() {
    // TODO: Implement timer logic
  }
  
  void pauseTimer() {
    // TODO: Implement pause logic
  }
  
  void resetTimer() {
    state = 0;
  }
}
