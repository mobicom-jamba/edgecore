import 'package:flutter/material.dart';

class CustomAnimatedScale extends StatelessWidget {
  const CustomAnimatedScale({
    super.key,
    required this.child,
    required this.scale,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final double scale;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedScale(
    duration: duration,
    curve: curve,
    scale: scale,
    child: child,
  );
}
