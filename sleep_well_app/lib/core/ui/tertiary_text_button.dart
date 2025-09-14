import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TertiaryTextButton extends StatelessWidget {
  const TertiaryTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.textColor,
  });
  
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? textColor;
  
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 20,
            color: textColor ?? AppTheme.accentPrimary,
          ),
          const SizedBox(width: AppTheme.spacing8),
        ],
        Text(
          text,
          style: TextStyle(
            color: textColor ?? AppTheme.accentPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
