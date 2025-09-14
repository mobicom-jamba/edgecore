import 'package:flutter/material.dart';

class CustomAnimatedBorder extends StatelessWidget {
  const CustomAnimatedBorder({
    super.key,
    required this.child,
    required this.border,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Border border;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    curve: curve,
    decoration: BoxDecoration(
      border: border,
    ),
    child: child,
  );
}
