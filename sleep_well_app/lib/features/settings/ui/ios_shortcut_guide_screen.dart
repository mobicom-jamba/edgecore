import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui/buttons.dart';
import '../../../core/ui/cards.dart';

class IosShortcutGuideScreen extends StatelessWidget {
  const IosShortcutGuideScreen({super.key});
  
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('iOS Shortcut Setup'),
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
              // Header
              _buildHeader(),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Steps
              _buildSteps(),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Download shortcut
              _buildDownloadSection(context),
              
              const SizedBox(height: AppTheme.spacing24),
              
              // Troubleshooting
              _buildTroubleshootingSection(),
            ],
          ),
        ),
      ),
    );
  
  Widget _buildHeader() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set up Do Not Disturb Shortcut',
          style: AppTheme.h1,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'Since iOS doesn\'t allow apps to toggle Do Not Disturb directly, we\'ve created a Shortcut that you can use to quickly enable DND during your wind-down routine.',
          style: AppTheme.body,
        ),
      ],
    );
  
  Widget _buildSteps() => CardSection(
      title: 'Setup Steps',
      body: Column(
        children: [
          _buildStep(
            '1',
            'Open the Shortcuts app',
            'Find the Shortcuts app on your iPhone (it\'s pre-installed)',
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildStep(
            '2',
            'Tap the + button',
            'Create a new shortcut by tapping the + in the top right',
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildStep(
            '3',
            'Add "Set Do Not Disturb" action',
            'Search for "Set Do Not Disturb" and add it to your shortcut',
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildStep(
            '4',
            'Set to "Turn On"',
            'Make sure the action is set to "Turn On" Do Not Disturb',
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildStep(
            '5',
            'Name your shortcut',
            'Give it a name like "Sleep Well DND" and save it',
          ),
          const SizedBox(height: AppTheme.spacing16),
          _buildStep(
            '6',
            'Add to Home Screen (optional)',
            'Long press the shortcut and select "Add to Home Screen" for quick access',
          ),
        ],
      ),
    );
  
  Widget _buildStep(String number, String title, String description) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppTheme.accentPrimary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: AppTheme.caption.copyWith(
                color: AppTheme.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.title,
              ),
              const SizedBox(height: AppTheme.spacing4),
              Text(
                description,
                style: AppTheme.caption,
              ),
            ],
          ),
        ),
      ],
    );
  
  Widget _buildDownloadSection(BuildContext context) => CardSection(
      title: 'Quick Setup',
      body: Column(
        children: [
          Text(
            'For your convenience, we\'ve prepared a shortcut file that you can download and import directly.',
            style: AppTheme.body,
          ),
          const SizedBox(height: AppTheme.spacing16),
          PrimaryButton(
            text: 'Download Shortcut',
            icon: Icons.download,
            onPressed: () => _downloadShortcut(context),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'After downloading, tap the file to import it into Shortcuts',
            style: AppTheme.caption,
          ),
        ],
      ),
    );
  
  Widget _buildTroubleshootingSection() => CardSection(
      title: 'Troubleshooting',
      body: Column(
        children: [
          _buildTroubleshootingItem(
            'Shortcut not working',
            'Make sure you\'ve granted all necessary permissions in Settings > Shortcuts',
          ),
          const SizedBox(height: AppTheme.spacing12),
          _buildTroubleshootingItem(
            'Can\'t find Shortcuts app',
            'Search for "Shortcuts" in the App Store and install it if it\'s not on your device',
          ),
          const SizedBox(height: AppTheme.spacing12),
          _buildTroubleshootingItem(
            'DND not turning on',
            'Check that Do Not Disturb is enabled in Settings > Focus > Do Not Disturb',
          ),
        ],
      ),
    );
  
  Widget _buildTroubleshootingItem(String problem, String solution) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.help_outline,
          color: AppTheme.info,
          size: 20,
        ),
        const SizedBox(width: AppTheme.spacing8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                problem,
                style: AppTheme.title.copyWith(fontSize: 16),
              ),
              const SizedBox(height: AppTheme.spacing4),
              Text(
                solution,
                style: AppTheme.caption,
              ),
            ],
          ),
        ),
      ],
    );
  
  void _downloadShortcut(BuildContext context) {
    // TODO: Implement shortcut download
    HapticFeedback.lightImpact();
    
    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shortcut download coming soon'),
        backgroundColor: AppTheme.info,
      ),
    );
  }
}
