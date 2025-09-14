import 'package:flutter/material.dart';

class CustomAnimatedSize extends StatelessWidget {
  const CustomAnimatedSize({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedSize(
    duration: duration,
    curve: curve,
    child: child,
  );
}
