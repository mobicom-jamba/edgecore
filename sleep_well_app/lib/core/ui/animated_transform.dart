import 'package:flutter/material.dart';

class CustomAnimatedTransform extends StatelessWidget {
  const CustomAnimatedTransform({
    super.key,
    required this.child,
    required this.transform,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Matrix4 transform;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Matrix4>(
    duration: duration,
    curve: curve,
    tween: Matrix4Tween(begin: Matrix4.identity(), end: transform),
    builder: (context, value, child) => Transform(
      transform: value,
      child: child,
    ),
    child: child,
  );
}
