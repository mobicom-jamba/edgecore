import 'package:flutter/material.dart';

class CustomAnimatedFadeTransition extends StatelessWidget {
  const CustomAnimatedFadeTransition({
    super.key,
    required this.child,
    required this.opacity,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Animation<double> opacity;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: opacity,
    child: child,
  );
}