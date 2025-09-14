import 'package:flutter/material.dart';

class CustomAnimatedGrid extends StatelessWidget {
  const CustomAnimatedGrid({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.gridDelegate,
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
  final SliverGridDelegate gridDelegate;
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
  Widget build(BuildContext context) => AnimatedGrid(
    itemBuilder: itemBuilder,
    initialItemCount: itemCount,
    gridDelegate: gridDelegate,
    scrollDirection: scrollDirection,
    reverse: reverse,
    controller: controller,
    primary: primary,
    physics: physics,
    padding: padding,
  );
}
