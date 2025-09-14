import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
