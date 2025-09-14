import 'package:flutter/material.dart';

class CustomAnimatedList extends StatelessWidget {
  const CustomAnimatedList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.cacheExtent,
    this.semanticChildCount,
  });
  
  final Widget Function(BuildContext context, int index, Animation<double> animation) itemBuilder;
  final int itemCount;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? cacheExtent;
  final int? semanticChildCount;
  
  @override
  Widget build(BuildContext context) => AnimatedList(
    itemBuilder: itemBuilder,
    initialItemCount: itemCount,
    scrollDirection: scrollDirection,
    reverse: reverse,
    controller: controller,
    primary: primary,
    physics: physics,
    shrinkWrap: shrinkWrap,
    padding: padding,
  );
}
