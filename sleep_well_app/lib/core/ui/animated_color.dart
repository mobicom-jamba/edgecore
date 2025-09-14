import 'package:flutter/material.dart';

class CustomAnimatedColor extends StatelessWidget {
  const CustomAnimatedColor({
    super.key,
    required this.child,
    required this.color,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Color color;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    curve: curve,
    color: color,
    child: child,
  );
}
