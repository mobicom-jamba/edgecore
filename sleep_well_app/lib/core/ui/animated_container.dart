import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomAnimatedContainer extends StatelessWidget {
  const CustomAnimatedContainer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
    this.padding,
    this.margin,
    this.color,
    this.elevation = 0,
    this.borderRadius,
    this.border,
    this.width,
    this.height,
  });
  
  final Widget child;
  final Duration duration;
  final Curve curve;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final double? width;
  final double? height;
  
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    curve: curve,
    padding: padding,
    margin: margin,
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color ?? AppTheme.surface,
      borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusCard),
      border: border,
      boxShadow: elevation > 0 ? AppTheme.shadowSoft : null,
    ),
    child: child,
  );
}
