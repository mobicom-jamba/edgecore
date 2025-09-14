import 'package:flutter/material.dart';

class CustomAnimatedScaleTransition extends StatelessWidget {
  const CustomAnimatedScaleTransition({
    super.key,
    required this.child,
    required this.scale,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Animation<double> scale;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => ScaleTransition(
    scale: scale,
    child: child,
  );
}