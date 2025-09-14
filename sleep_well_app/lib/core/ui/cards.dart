import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CardSection extends StatelessWidget {
  
  const CardSection({
    super.key,
    required this.title,
    required this.body,
    this.action,
    this.padding,
  });
  final String title;
  final Widget body;
  final Widget? action;
  final EdgeInsets? padding;
  
  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTheme.title,
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            body,
          ],
        ),
      ),
    );
}

class SettingRow extends StatelessWidget {
  
  const SettingRow({
    super.key,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  
  @override
  Widget build(BuildContext context) => Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTheme.body,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          subtitle!,
                          style: AppTheme.caption,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: AppTheme.spacing8),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
}

class ProgressRing extends StatelessWidget {
  
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 6,
    this.color,
    this.backgroundColor,
    this.child,
  });
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final Widget? child;
  
  @override
  Widget build(BuildContext context) => SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              backgroundColor ?? AppTheme.divider,
            ),
          ),
          // Progress circle
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppTheme.accentPrimary,
            ),
          ),
          // Center content
          if (child != null)
            Center(child: child!),
        ],
      ),
    );
}

class InfoBanner extends StatelessWidget {
  
  const InfoBanner({
    super.key,
    required this.message,
    required this.type,
    this.onAction,
    this.actionText,
  });
  final String message;
  final InfoBannerType type;
  final VoidCallback? onAction;
  final String? actionText;
  
  @override
  Widget build(BuildContext context) {
    final colors = _getColors(type);
    
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacing12),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Icon(
            colors.icon,
            color: colors.foreground,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacing8),
          Expanded(
            child: Text(
              message,
              style: AppTheme.body.copyWith(color: colors.foreground),
            ),
          ),
          if (onAction != null && actionText != null) ...[
            const SizedBox(width: AppTheme.spacing8),
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: TextStyle(color: colors.foreground),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  _BannerColors _getColors(InfoBannerType type) {
    switch (type) {
      case InfoBannerType.success:
        return _BannerColors(
          background: AppTheme.success.withOpacity(0.1),
          foreground: AppTheme.success,
          border: AppTheme.success.withOpacity(0.3),
          icon: Icons.check_circle_outline,
        );
      case InfoBannerType.warning:
        return _BannerColors(
          background: AppTheme.warning.withOpacity(0.1),
          foreground: AppTheme.warning,
          border: AppTheme.warning.withOpacity(0.3),
          icon: Icons.warning_outlined,
        );
      case InfoBannerType.info:
        return _BannerColors(
          background: AppTheme.info.withOpacity(0.1),
          foreground: AppTheme.info,
          border: AppTheme.info.withOpacity(0.3),
          icon: Icons.info_outline,
        );
      case InfoBannerType.error:
        return _BannerColors(
          background: AppTheme.error.withOpacity(0.1),
          foreground: AppTheme.error,
          border: AppTheme.error.withOpacity(0.3),
          icon: Icons.error_outline,
        );
    }
  }
}

enum InfoBannerType { success, warning, info, error }

class _BannerColors {
  
  const _BannerColors({
    required this.background,
    required this.foreground,
    required this.border,
    required this.icon,
  });
  final Color background;
  final Color foreground;
  final Color border;
  final IconData icon;
}
