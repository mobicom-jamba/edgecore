import 'package:flutter/material.dart';

class CustomAnimatedPadding extends StatelessWidget {
  const CustomAnimatedPadding({
    super.key,
    required this.child,
    required this.padding,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final EdgeInsets padding;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedPadding(
    duration: duration,
    curve: curve,
    padding: padding,
    child: child,
  );
}
