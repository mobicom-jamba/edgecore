import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/custom_card.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/app_header.dart';

class AnalyticsScreen extends HookWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Analytics Hub',
              showBackButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickWinsSection(),
                    const SizedBox(height: AppTheme.spacing12),
                    _buildSleepInsightsSection(),
                    const SizedBox(height: AppTheme.spacing12),
                    _buildFullReportSection(),
                    const SizedBox(height: 20), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickWinsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Wins',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: AppTheme.spacing16),
        ...AppConstants.quickWins.map((win) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing4),
              child: QuickWinCard(
                title: win['title']!,
                description: win['description']!,
                icon: win['icon']!,
                onTap: () {
                  // Handle quick win tap
                },
              ),
            )),
      ],
    );
  }

  Widget _buildSleepInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Sleep Insights',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: AppTheme.spacing16),
        _buildSleepConsistencyCard(),
        const SizedBox(height: AppTheme.spacing16),
        _buildSleepRecommendationCard(),
      ],
    );
  }

  Widget _buildSleepConsistencyCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: const Icon(
                  Icons.nightlight_round,
                  color: AppTheme.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sleep Consistency',
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Regularity is key.',
                      style: AppTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'Your bedtime varied by **45 minutes** this week. A consistent schedule drastically improves sleep quality.',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacing16),
          PrimaryButton(
            text: 'Set a Bedtime Reminder',
            onPressed: () {
              // Set bedtime reminder
            },
            isFullWidth: false,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('6h 30m', 'Avg. Last 7 Days'),
              ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(
                child: _buildStatItem('30 min', 'After Bedtime'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepRecommendationCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Slightly below the recommended **7-9 hours**. Try to get to bed a little earlier tonight.',
            style: AppTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacing12),
          TextButton(
            onPressed: () {
              // Learn about sleep cycles
            },
            child: Text(
              'Learn about sleep cycles',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullReportSection() {
    return CustomCard(
      onTap: () {
        // Navigate to full report
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: const Icon(
              Icons.bar_chart,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'View Full Report',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Explore all your sleep data.',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.textTertiary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTheme.heading3,
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          label,
          style: AppTheme.bodySmall,
        ),
      ],
    );
  }
}
