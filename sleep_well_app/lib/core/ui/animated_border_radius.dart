import 'package:flutter/material.dart';

class CustomAnimatedBorderRadius extends StatelessWidget {
  const CustomAnimatedBorderRadius({
    super.key,
    required this.child,
    required this.borderRadius,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final BorderRadius borderRadius;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    curve: curve,
    decoration: BoxDecoration(
      borderRadius: borderRadius,
    ),
    child: child,
  );
}
