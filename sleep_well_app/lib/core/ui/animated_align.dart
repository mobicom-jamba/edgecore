import 'package:flutter/material.dart';

class CustomAnimatedAlign extends StatelessWidget {
  const CustomAnimatedAlign({
    super.key,
    required this.child,
    required this.alignment,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
    this.widthFactor,
    this.heightFactor,
  });
  
  final Widget child;
  final Alignment alignment;
  final Duration duration;
  final Curve curve;
  final double? widthFactor;
  final double? heightFactor;
  
  @override
  Widget build(BuildContext context) => AnimatedAlign(
    duration: duration,
    curve: curve,
    alignment: alignment,
    widthFactor: widthFactor,
    heightFactor: heightFactor,
    child: child,
  );
}
