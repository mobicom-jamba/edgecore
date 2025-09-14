import 'package:flutter/material.dart';

class CustomAnimatedRotationTransition extends StatelessWidget {
  const CustomAnimatedRotationTransition({
    super.key,
    required this.child,
    required this.turns,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Animation<double> turns;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => RotationTransition(
    turns: turns,
    child: child,
  );
}