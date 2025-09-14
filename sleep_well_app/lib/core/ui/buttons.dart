import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  
  @override
  Widget build(BuildContext context) => SizedBox(
      width: width,
      height: 44, // Min 44dp
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.background),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppTheme.spacing8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
}

class SecondaryButton extends StatelessWidget {
  
  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  
  @override
  Widget build(BuildContext context) => SizedBox(
      width: width,
      height: 44, // Min 44dp
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentPrimary),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: AppTheme.spacing8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
}

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

class AppIconButton extends StatelessWidget {
  
  const AppIconButton({
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
