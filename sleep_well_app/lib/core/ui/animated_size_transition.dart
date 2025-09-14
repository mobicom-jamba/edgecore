import 'package:flutter/material.dart';

class CustomAnimatedSizeTransition extends StatelessWidget {
  const CustomAnimatedSizeTransition({
    super.key,
    required this.child,
    required this.sizeFactor,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });
  
  final Widget child;
  final Animation<double> sizeFactor;
  final Duration duration;
  final Curve curve;
  
  @override
  Widget build(BuildContext context) => SizeTransition(
    sizeFactor: sizeFactor,
    child: child,
  );
}