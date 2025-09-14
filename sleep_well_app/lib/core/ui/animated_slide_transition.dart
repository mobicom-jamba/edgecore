import 'package:flutter/material.dart';

class CustomAnimatedSlideTransition extends StatelessWidget {
  const CustomAnimatedSlideTransition({
    super.key,
    required this.child,
    required this.position,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Animation<Offset> position;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => SlideTransition(
    position: position,
    child: child,
  );
}