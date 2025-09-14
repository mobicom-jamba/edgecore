import 'package:flutter/material.dart';

class CustomAnimatedCrossFade extends StatelessWidget {
  const CustomAnimatedCrossFade({
    super.key,
    required this.firstChild,
    required this.secondChild,
    required this.crossFadeState,
    this.duration = const Duration(milliseconds: 200),
    this.layoutBuilder = AnimatedCrossFade.defaultLayoutBuilder,
  });
  
  final Widget firstChild;
  final Widget secondChild;
  final CrossFadeState crossFadeState;
  final Duration duration;
  final AnimatedCrossFadeBuilder layoutBuilder;
  
  @override
  Widget build(BuildContext context) => AnimatedCrossFade(
    firstChild: firstChild,
    secondChild: secondChild,
    crossFadeState: crossFadeState,
    duration: duration,
    layoutBuilder: layoutBuilder,
  );
}
