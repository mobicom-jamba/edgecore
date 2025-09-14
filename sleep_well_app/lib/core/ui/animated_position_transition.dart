import 'package:flutter/material.dart';

class CustomAnimatedPositionTransition extends StatelessWidget {
  const CustomAnimatedPositionTransition({
    super.key,
    required this.child,
    required this.position,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Animation<RelativeRect> position;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => PositionedTransition(
    rect: position,
    child: child,
  );
}