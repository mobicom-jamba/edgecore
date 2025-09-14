import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
