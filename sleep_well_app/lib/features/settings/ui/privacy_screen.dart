import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';
import '../../../core/ui/modals.dart';
import '../../../core/database/database.dart';
import '../data/providers/settings_providers.dart';

class PrivacyScreen extends HookConsumerWidget {
  const PrivacyScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataExport = ref.watch(dataExportProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Data'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy notice
              _buildPrivacyNotice(),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Data export
              _buildDataExportSection(context, ref, dataExport),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Data deletion
              _buildDataDeletionSection(context, ref),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Privacy policy
              _buildPrivacyPolicySection(context),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPrivacyNotice() => Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.privacy_tip_outlined, color: AppTheme.info),
                const SizedBox(width: AppTheme.spacing8),
                Text('Privacy First', style: AppTheme.title),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              'Sleep Well is designed with privacy in mind. All your data is stored locally on your device and never sent to external servers.',
              style: AppTheme.body,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              '• No cloud storage or external servers\n• No data collection or analytics\n• No third-party tracking\n• Complete control over your data',
              style: AppTheme.caption,
            ),
          ],
        ),
      ),
    );
  
  Widget _buildDataExportSection(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<Map<String, dynamic>> dataExport,
  ) => CardSection(
      title: 'Export Your Data',
      body: Column(
        children: [
          Text(
            'Download all your sleep data, check-ins, and preferences as a JSON file.',
            style: AppTheme.body,
          ),
          const SizedBox(height: AppTheme.spacing16),
          dataExport.when(
            data: (data) => PrimaryButton(
              text: 'Export Data',
              icon: Icons.download,
              onPressed: () => _exportData(context, data),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text(
              'Failed to prepare data for export',
              style: AppTheme.caption.copyWith(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  
  Widget _buildDataDeletionSection(BuildContext context, WidgetRef ref) => CardSection(
      title: 'Delete All Data',
      body: Column(
        children: [
          Text(
            'Permanently remove all your sleep data, check-ins, and preferences from this device.',
            style: AppTheme.body,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'This action cannot be undone.',
            style: AppTheme.caption.copyWith(color: AppTheme.warning),
          ),
          const SizedBox(height: AppTheme.spacing16),
          SecondaryButton(
            text: 'Delete All Data',
            icon: Icons.delete_forever,
            onPressed: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
    );
  
  Widget _buildPrivacyPolicySection(BuildContext context) => CardSection(
      title: 'Privacy Policy',
      body: Column(
        children: [
          Text(
            'Learn more about how we handle your data and protect your privacy.',
            style: AppTheme.body,
          ),
          const SizedBox(height: AppTheme.spacing16),
          TertiaryTextButton(
            text: 'View Privacy Policy',
            icon: Icons.open_in_new,
            onPressed: () => _openPrivacyPolicy(context),
          ),
        ],
      ),
    );
  
  Future<void> _exportData(BuildContext context, Map<String, dynamic> data) async {
    try {
      // Convert data to JSON string
      final jsonString = data.toString();
      
      // Copy to clipboard
      await Clipboard.setData(ClipboardData(text: jsonString));
      
      if (context.mounted) {
        Toast.show(
          context: context,
          message: 'Data copied to clipboard',
          type: ToastType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        Toast.show(
          context: context,
          message: 'Failed to export data',
          type: ToastType.error,
        );
      }
    }
  }
  
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'Are you sure you want to delete all your sleep data? This action cannot be undone and you will lose all your progress, check-ins, and preferences.',
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
            child: const Text('Delete All'),
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
  
  void _openPrivacyPolicy(BuildContext context) {
    // TODO: Open privacy policy URL
    Toast.show(
      context: context,
      message: 'Privacy policy coming soon',
      type: ToastType.info,
    );
  }
}
