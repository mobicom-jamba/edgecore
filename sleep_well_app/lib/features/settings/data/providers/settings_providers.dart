import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/database/database.dart';
import '../../../onboarding/data/models/user_prefs.dart';

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

// App version provider
final appVersionProvider = Provider<String>((ref) => '1.0.0');

// Data export provider
final dataExportProvider = FutureProvider<Map<String, dynamic>>((ref) async => await DatabaseService.exportData());
