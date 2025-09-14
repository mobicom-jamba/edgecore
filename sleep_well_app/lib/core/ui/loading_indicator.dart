import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 2,
    this.color,
    this.message,
  });
  
  final double size;
  final double strokeWidth;
  final Color? color;
  final String? message;
  
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppTheme.accentPrimary,
          ),
        ),
      ),
      if (message != null) ...[
        const SizedBox(height: AppTheme.spacing16),
        Text(
          message!,
          style: AppTheme.body,
          textAlign: TextAlign.center,
        ),
      ],
    ],
  );
}
