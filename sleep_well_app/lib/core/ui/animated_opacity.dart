import 'package:flutter/material.dart';

class CustomAnimatedOpacity extends StatelessWidget {
  const CustomAnimatedOpacity({
    super.key,
    required this.child,
    required this.opacity,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final double opacity;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    duration: duration,
    curve: curve,
    opacity: opacity,
    child: child,
  );
}
