import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.color,
    this.size = 24,
  });
  
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final double size;
  
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPressed != null
          ? () {
              HapticFeedback.selectionClick();
              onPressed!();
            }
          : null,
      borderRadius: BorderRadius.circular(22), // 44dp / 2
      child: Container(
        width: 44, // Min 44dp
        height: 44, // Min 44dp
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(
          icon,
          size: size,
          color: color ?? AppTheme.textPrimary,
        ),
      ),
    ),
  );
}
