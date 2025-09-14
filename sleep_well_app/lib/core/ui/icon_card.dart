import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// A compact icon card widget for quick actions
class IconCard extends StatelessWidget {
  final String label;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showChevron;
  final EdgeInsets? padding;

  const IconCard({
    super.key,
    required this.label,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.showChevron = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppTheme.accentPrimary;
    final effectiveBackgroundColor = backgroundColor ?? AppTheme.surfaceAlt;

    return Semantics(
      label: '$label${subtitle != null ? '. $subtitle' : ''}',
      button: true,
      child: InkWell(
        onTap: onTap != null
            ? () {
                HapticFeedback.selectionClick();
                onTap!();
              }
            : null,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Container(
          padding: padding ?? const EdgeInsets.all(AppTheme.spacing16),
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(
              color: AppTheme.divider,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: effectiveIconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: effectiveIconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppTheme.title.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTheme.caption.copyWith(
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Chevron
              if (showChevron && onTap != null) ...[
                const SizedBox(width: AppTheme.spacing8),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A grid of icon cards for quick actions
class IconCardGrid extends StatelessWidget {
  final List<IconCardData> cards;
  final int crossAxisCount;
  final double spacing;
  final double runSpacing;

  const IconCardGrid({
    super.key,
    required this.cards,
    this.crossAxisCount = 2,
    this.spacing = AppTheme.spacing12,
    this.runSpacing = AppTheme.spacing12,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: 2.5, // Adjust based on content
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final cardData = cards[index];
        return IconCard(
          label: cardData.label,
          subtitle: cardData.subtitle,
          icon: cardData.icon,
          iconColor: cardData.iconColor,
          backgroundColor: cardData.backgroundColor,
          onTap: cardData.onTap,
          showChevron: cardData.showChevron,
        );
      },
    );
  }
}

/// Data class for icon card configuration
class IconCardData {
  final String label;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showChevron;

  const IconCardData({
    required this.label,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.showChevron = true,
  });
}

/// A compact streak display card
class StreakCard extends StatelessWidget {
  final int streakDays;
  final VoidCallback? onTap;
  final bool showGoalChip;

  const StreakCard({
    super.key,
    required this.streakDays,
    this.onTap,
    this.showGoalChip = true,
  });

  @override
  Widget build(BuildContext context) {
    final isFirstDay = streakDays == 0;
    final isGoalReached = streakDays >= 3;

    return Semantics(
      label: isFirstDay
          ? 'Day 1 starts tonight'
          : '$streakDays day streak${isGoalReached ? '. 3 day goal reached' : ''}',
      button: onTap != null,
      child: InkWell(
        onTap: onTap != null
            ? () {
                HapticFeedback.selectionClick();
                onTap!();
              }
            : null,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacing20),
          decoration: BoxDecoration(
            color: AppTheme.surfaceAlt,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            border: Border.all(
              color: isGoalReached ? AppTheme.success : AppTheme.divider,
              width: isGoalReached ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isFirstDay ? Icons.nightlight_round : Icons.local_fire_department,
                    color: isFirstDay ? AppTheme.accentPrimary : AppTheme.success,
                    size: 24,
                  ),
                  const SizedBox(width: AppTheme.spacing8),
                  Expanded(
                    child: Text(
                      isFirstDay ? 'Day 1 starts tonight' : '$streakDays day streak',
                      style: AppTheme.title.copyWith(
                        color: isFirstDay ? AppTheme.accentPrimary : AppTheme.success,
                      ),
                    ),
                  ),
                  if (showGoalChip && !isFirstDay)
                    _buildGoalChip(isGoalReached),
                ],
              ),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                isFirstDay
                    ? 'Tiny steps, real sleep.'
                    : isGoalReached
                        ? 'Amazing! You\'ve built a solid sleep routine.'
                        : 'Keep it up! You\'re building healthy habits.',
                style: AppTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalChip(bool isReached) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8,
        vertical: AppTheme.spacing4,
      ),
      decoration: BoxDecoration(
        color: isReached ? AppTheme.success : AppTheme.accentPrimary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '3-day goal',
        style: AppTheme.caption.copyWith(
          color: AppTheme.background,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
