import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation = 0,
    this.borderRadius,
    this.border,
  });
  
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  
  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    decoration: BoxDecoration(
      color: color ?? AppTheme.surface,
      borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusCard),
      border: border,
      boxShadow: elevation > 0 ? AppTheme.shadowSoft : null,
    ),
    child: Padding(
      padding: padding ?? const EdgeInsets.all(AppTheme.spacing16),
      child: child,
    ),
  );
}
