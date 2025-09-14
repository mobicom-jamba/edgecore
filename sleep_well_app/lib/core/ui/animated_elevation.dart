import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomAnimatedElevation extends StatelessWidget {
  const CustomAnimatedElevation({
    super.key,
    required this.child,
    required this.elevation,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final double elevation;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    curve: curve,
    decoration: BoxDecoration(
      boxShadow: elevation > 0 ? AppTheme.shadowSoft : null,
    ),
    child: child,
  );
}
