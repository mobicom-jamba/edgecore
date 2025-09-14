import 'package:flutter/material.dart';

class CustomAnimatedPosition extends StatelessWidget {
  const CustomAnimatedPosition({
    super.key,
    required this.child,
    required this.offset,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Offset offset;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => AnimatedPositioned(
    duration: duration,
    curve: curve,
    left: offset.dx,
    top: offset.dy,
    child: child,
  );
}
