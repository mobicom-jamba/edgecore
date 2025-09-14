import 'package:flutter/material.dart';

class CustomAnimatedGradient extends StatelessWidget {
  const CustomAnimatedGradient({
    super.key,
    required this.child,
    required this.gradient,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Gradient gradient;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    curve: curve,
    decoration: BoxDecoration(
      gradient: gradient,
    ),
    child: child,
  );
}
