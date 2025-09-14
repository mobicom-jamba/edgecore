import 'package:flutter/material.dart';

class CustomAnimatedMargin extends StatelessWidget {
  const CustomAnimatedMargin({
    super.key,
    required this.child,
    required this.margin,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final EdgeInsets margin;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: duration,
    curve: curve,
    margin: margin,
    child: child,
  );
}
