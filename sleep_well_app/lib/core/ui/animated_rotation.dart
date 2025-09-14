import 'package:flutter/material.dart';

class CustomAnimatedRotation extends StatelessWidget {
  const CustomAnimatedRotation({
    super.key,
    required this.child,
    required this.angle,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final double angle;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedRotation(
    duration: duration,
    curve: curve,
    turns: angle,
    child: child,
  );
}
