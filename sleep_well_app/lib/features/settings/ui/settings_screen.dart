import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/database/database.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/modals.dart';
import '../../onboarding/data/models/user_prefs.dart';
import '../../onboarding/data/models/chronotype.dart';
import '../data/providers/settings_providers.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPrefs = ref.watch(userPrefsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: userPrefs.when(
          data: (prefs) => _buildContent(context, ref, prefs),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppTheme.error),
                const SizedBox(height: AppTheme.spacing16),
                Text('Failed to load settings', style: AppTheme.h2),
                const SizedBox(height: AppTheme.spacing8),
                Text('Please try again', style: AppTheme.body),
                const SizedBox(height: AppTheme.spacing24),
                PrimaryButton(
                  text: 'Retry',
                  onPressed: () => ref.invalidate(userPrefsProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    UserPrefs prefs,
  ) => SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sleep Schedule
          _buildSleepScheduleSection(context, ref, prefs),
          
          const SizedBox(height: AppTheme.spacing24),
          
          // Wind-down Rituals
          _buildRitualsSection(context, ref),
          
          const SizedBox(height: AppTheme.spacing24),
          
          // Sleep Buddy
          _buildBuddySection(context, ref, prefs),
          
          const SizedBox(height: AppTheme.spacing24),
          
          // Notifications
          _buildNotificationsSection(context, ref, prefs),
          
          const SizedBox(height: AppTheme.spacing24),
          
          // Quick Toggles
          _buildQuickTogglesSection(context, ref, prefs),
          
          const SizedBox(height: AppTheme.spacing24),
          
          // Accessibility
          _buildAccessibilitySection(context, ref, prefs),
          
          const SizedBox(height: AppTheme.spacing24),
          
          // Privacy
          _buildPrivacySection(context, ref),
        ],
      ),
    );
  
  Widget _buildSleepScheduleSection(
    BuildContext context,
    WidgetRef ref,
    UserPrefs prefs,
  ) {
    final bedtime = TimeOfDay(hour: prefs.bedtimeHour, minute: prefs.bedtimeMinute);
    final wakeTime = TimeOfDay(hour: prefs.wakeTimeHour, minute: prefs.wakeTimeMinute);
    
    return CardSection(
      title: 'Sleep Schedule',
      body: Column(
        children: [
          SettingRow(
            label: 'Bedtime',
            subtitle: bedtime.format(context),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showTimePicker(
              context,
              'Bedtime',
              bedtime,
              (time) => _updateBedtime(ref, time),
            ),
          ),
          SettingRow(
            label: 'Wake up',
            subtitle: wakeTime.format(context),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showTimePicker(
              context,
              'Wake up',
              wakeTime,
              (time) => _updateWakeTime(ref, time),
            ),
          ),
          SettingRow(
            label: 'Chronotype',
            subtitle: prefs.chronotype != null ? Chronotype.values.firstWhere((c) => c.name == prefs.chronotype).displayName : 'Not set',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showChronotypePicker(context, ref, prefs.chronotype != null ? Chronotype.values.firstWhere((c) => c.name == prefs.chronotype) : Chronotype.balanced),
          ),
          // Chronotype explainer
          Padding(
            padding: const EdgeInsets.only(
              left: AppTheme.spacing16,
              right: AppTheme.spacing16,
              top: AppTheme.spacing8,
            ),
            child: Text(
              _getChronotypeExplainer(prefs.chronotype != null ? Chronotype.values.firstWhere((c) => c.name == prefs.chronotype) : Chronotype.balanced),
              style: AppTheme.caption.copyWith(
                color: AppTheme.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          // Learn more link
          Padding(
            padding: const EdgeInsets.only(
              left: AppTheme.spacing16,
              right: AppTheme.spacing16,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _showChronotypeInfo(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Learn more',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.accentPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRitualsSection(BuildContext context, WidgetRef ref) {
    // TODO: Get actual rituals count and duration from providers
    final ritualsCount = 3; // Placeholder
    final estimatedDuration = '~3 min'; // Placeholder
    
    return CardSection(
      title: 'Wind-down Rituals',
      body: Column(
        children: [
          SettingRow(
            label: 'Manage Rituals',
            subtitle: '$ritualsCount steps • $estimatedDuration',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showRitualsManager(context, ref),
            showDivider: false,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBuddySection(
    BuildContext context,
    WidgetRef ref,
    UserPrefs prefs,
  ) {
    final hasBuddy = prefs.buddyName != null && prefs.buddyName!.isNotEmpty;
    
    if (!hasBuddy) {
      // Collapsed state - show compact preview
      return CardSection(
        title: 'Sleep Buddy',
        body: Column(
          children: [
            SettingRow(
              label: 'Add a Sleep Buddy',
              subtitle: 'Add a Sleep Buddy for a gentle nudge if you slip.',
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showBuddySetup(context, ref, prefs),
              showDivider: false,
            ),
          ],
        ),
      );
    }
    
    // Expanded state - show full buddy details
    return CardSection(
      title: 'Sleep Buddy',
      body: Column(
        children: [
          SettingRow(
            label: 'Buddy Name',
            subtitle: prefs.buddyName ?? 'Not set',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showBuddySetup(context, ref, prefs),
          ),
          SettingRow(
            label: 'Contact',
            subtitle: prefs.buddyPhone ?? 'Not set',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showBuddySetup(context, ref, prefs),
            showDivider: false,
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationsSection(
    BuildContext context,
    WidgetRef ref,
    UserPrefs prefs,
  ) => CardSection(
      title: 'Notifications',
      body: Column(
        children: [
          SettingRow(
            label: 'Bedtime Reminders',
            subtitle: 'Get notified 30 minutes before bedtime',
            trailing: Switch(
              value: prefs.notificationsEnabled,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                _updateNotifications(ref, value);
              },
              activeColor: AppTheme.accentPrimary,
            ),
            showDivider: false,
          ),
        ],
      ),
    );
  
  Widget _buildQuickTogglesSection(
    BuildContext context,
    WidgetRef ref,
    UserPrefs prefs,
  ) => CardSection(
      title: 'Quick Settings',
      body: Column(
        children: [
          SettingRow(
            label: 'Reduce Motion',
            subtitle: 'Minimize animations and transitions',
            trailing: Switch(
              value: prefs.reduceMotion,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                _updateReduceMotion(ref, value);
              },
              activeColor: AppTheme.accentPrimary,
            ),
          ),
          SettingRow(
            label: 'Lo-fi Sound',
            subtitle: 'Play gentle sounds during wind-down',
            trailing: Switch(
              value: prefs.lofiSoundEnabled,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                _updateLofiSound(ref, value);
              },
              activeColor: AppTheme.accentPrimary,
            ),
            showDivider: false,
          ),
        ],
      ),
    );
  
  Widget _buildAccessibilitySection(
    BuildContext context,
    WidgetRef ref,
    UserPrefs prefs,
  ) => CardSection(
      title: 'Accessibility',
      body: Column(
        children: [
          SettingRow(
            label: 'High Contrast',
            subtitle: 'Increase text and UI contrast',
            trailing: Switch(
              value: prefs.highContrast,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                _updateHighContrast(ref, value);
              },
              activeColor: AppTheme.accentPrimary,
            ),
            showDivider: false,
          ),
        ],
      ),
    );
  
  Widget _buildPrivacySection(BuildContext context, WidgetRef ref) => CardSection(
      title: 'Privacy',
      body: Column(
        children: [
          SettingRow(
            label: 'Export Data',
            subtitle: 'Download your sleep data as JSON',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => context.push('/settings/privacy'),
          ),
          SettingRow(
            label: 'Delete All Data',
            subtitle: 'Permanently remove all your data',
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showDeleteDataDialog(context, ref),
            showDivider: false,
          ),
        ],
      ),
    );
  
  void _showTimePicker(
    BuildContext context,
    String title,
    TimeOfDay initialTime,
    ValueChanged<TimeOfDay> onChanged,
  ) {
    showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.accentPrimary,
            ),
          ),
          child: child!,
        ),
    ).then((time) {
      if (time != null) {
        onChanged(time);
      }
    });
  }
  
  Future<void> _updateBedtime(WidgetRef ref, TimeOfDay time) async {
    final isar = DatabaseService.instance;
    final prefs = await isar.userPrefs.where().findFirst();
    
    if (prefs != null) {
      final updatedPrefs = prefs.copyWith(
        bedtimeHour: time.hour,
        bedtimeMinute: time.minute,
      );
      
      await isar.writeTxn(() async {
        await isar.userPrefs.put(updatedPrefs);
      });
      
      ref.invalidate(userPrefsProvider);
    }
  }
  
  Future<void> _updateWakeTime(WidgetRef ref, TimeOfDay time) async {
    final isar = DatabaseService.instance;
    final prefs = await isar.userPrefs.where().findFirst();
    
    if (prefs != null) {
      final updatedPrefs = prefs.copyWith(
        wakeTimeHour: time.hour,
        wakeTimeMinute: time.minute,
      );
      
      await isar.writeTxn(() async {
        await isar.userPrefs.put(updatedPrefs);
      });
      
      ref.invalidate(userPrefsProvider);
    }
  }
  
  void _showChronotypePicker(
    BuildContext context,
    WidgetRef ref,
    Chronotype currentChronotype,
  ) {
    BottomSheetModal.show(
      context: context,
      title: 'Select Chronotype',
      content: Column(
        children: Chronotype.values.map((chronotype) {
          final isSelected = chronotype == currentChronotype;
          
          return ListTile(
            leading: Icon(
              _getChronotypeIcon(chronotype),
              color: isSelected ? AppTheme.accentPrimary : AppTheme.textSecondary,
            ),
            title: Text(
              chronotype.displayName,
              style: TextStyle(
                color: isSelected ? AppTheme.accentPrimary : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            subtitle: Text(chronotype.description),
            trailing: isSelected
                ? const Icon(Icons.check, color: AppTheme.accentPrimary)
                : null,
            onTap: () {
              HapticFeedback.selectionClick();
              _updateChronotype(ref, chronotype);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
  
  IconData _getChronotypeIcon(Chronotype chronotype) {
    switch (chronotype) {
      case Chronotype.earlyBird:
        return Icons.wb_sunny;
      case Chronotype.nightOwl:
        return Icons.nightlight_round;
      case Chronotype.balanced:
        return Icons.schedule;
      case Chronotype.irregular:
        return Icons.sync;
    }
  }
  
  Future<void> _updateChronotype(WidgetRef ref, Chronotype chronotype) async {
    await DatabaseService.saveChronotype(chronotype);
    ref.invalidate(userPrefsProvider);
  }
  
  void _showRitualsManager(BuildContext context, WidgetRef ref) {
    // TODO: Implement rituals manager
    Toast.show(
      context: context,
      message: 'Rituals manager coming soon',
      type: ToastType.info,
    );
  }
  
  void _showBuddySetup(BuildContext context, WidgetRef ref, UserPrefs prefs) {
    // TODO: Implement buddy setup
    Toast.show(
      context: context,
      message: 'Buddy setup coming soon',
      type: ToastType.info,
    );
  }
  
  Future<void> _updateNotifications(WidgetRef ref, bool enabled) async {
    final isar = DatabaseService.instance;
    final prefs = await isar.userPrefs.where().findFirst();
    
    if (prefs != null) {
      final updatedPrefs = prefs.copyWith(notificationsEnabled: enabled);
      
      await isar.writeTxn(() async {
        await isar.userPrefs.put(updatedPrefs);
      });
      
      ref.invalidate(userPrefsProvider);
    }
  }
  
  Future<void> _updateReduceMotion(WidgetRef ref, bool enabled) async {
    final isar = DatabaseService.instance;
    final prefs = await isar.userPrefs.where().findFirst();
    
    if (prefs != null) {
      final updatedPrefs = prefs.copyWith(reduceMotion: enabled);
      
      await isar.writeTxn(() async {
        await isar.userPrefs.put(updatedPrefs);
      });
      
      ref.invalidate(userPrefsProvider);
    }
  }
  
  Future<void> _updateLofiSound(WidgetRef ref, bool enabled) async {
    final isar = DatabaseService.instance;
    final prefs = await isar.userPrefs.where().findFirst();
    
    if (prefs != null) {
      final updatedPrefs = prefs.copyWith(lofiSoundEnabled: enabled);
      
      await isar.writeTxn(() async {
        await isar.userPrefs.put(updatedPrefs);
      });
      
      ref.invalidate(userPrefsProvider);
    }
  }
  
  Future<void> _updateHighContrast(WidgetRef ref, bool enabled) async {
    final isar = DatabaseService.instance;
    final prefs = await isar.userPrefs.where().findFirst();
    
    if (prefs != null) {
      final updatedPrefs = prefs.copyWith(highContrast: enabled);
      
      await isar.writeTxn(() async {
        await isar.userPrefs.put(updatedPrefs);
      });
      
      ref.invalidate(userPrefsProvider);
    }
  }
  
  void _showDeleteDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'This will permanently delete all your sleep data, check-ins, and preferences. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAllData(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _deleteAllData(BuildContext context, WidgetRef ref) async {
    try {
      await DatabaseService.clearAll();
      
      if (context.mounted) {
        Toast.show(
          context: context,
          message: 'All data deleted successfully',
          type: ToastType.success,
        );
        
        // Navigate to onboarding
        context.go('/onboarding');
      }
    } catch (e) {
      if (context.mounted) {
        Toast.show(
          context: context,
          message: 'Failed to delete data',
          type: ToastType.error,
        );
      }
    }
  }
  
  String _getChronotypeExplainer(Chronotype chronotype) {
    switch (chronotype) {
      case Chronotype.earlyBird:
        return 'Early Bird: naturally alert in mornings; earlier bedtime helps maintain energy.';
      case Chronotype.nightOwl:
        return 'Night Owl: naturally alert in late evenings; later wind-down works better for you.';
      case Chronotype.balanced:
        return 'Balanced: adapts well to different schedules; consistent routine works best.';
      case Chronotype.irregular:
        return 'Irregular: sleep patterns vary; focus on consistent bedtime and wind-down routine.';
    }
  }
  
  void _showChronotypeInfo(BuildContext context) {
    BottomSheetModal.show(
      context: context,
      title: 'About Chronotypes',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chronotypes are natural sleep-wake patterns that affect when you feel most alert and when you naturally want to sleep.',
            style: AppTheme.body,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Understanding your chronotype helps us:',
            style: AppTheme.title,
          ),
          const SizedBox(height: AppTheme.spacing8),
          ...['• Personalize your sleep schedule', '• Optimize wind-down timing', '• Improve sleep quality'].map(
            (point) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing4),
              child: Text(point, style: AppTheme.body),
            ),
          ),
        ],
      ),
      actions: [
        PrimaryButton(
          text: 'Got it',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
