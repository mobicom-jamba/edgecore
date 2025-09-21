import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'custom_bottom_navigation.dart';

/// A wrapper widget that provides bottom navigation to any screen
/// This allows individual screens to be used with or without navigation
class ScreenWithNavigation extends StatefulWidget {
  final Widget child;
  final int currentIndex;
  final Function(int)? onNavigationTap;
  final AnimationController? animationController;

  const ScreenWithNavigation({
    super.key,
    required this.child,
    required this.currentIndex,
    this.onNavigationTap,
    this.animationController,
  });

  @override
  State<ScreenWithNavigation> createState() => _ScreenWithNavigationState();
}

class _ScreenWithNavigationState extends State<ScreenWithNavigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: widget.child,
      bottomNavigationBar: widget.onNavigationTap != null
          ? CustomBottomNavigation(
              currentIndex: widget.currentIndex,
              onTap: widget.onNavigationTap!,
              animationController: widget.animationController,
            )
          : null,
    );
  }
}

/// Helper function to quickly wrap a screen with navigation
/// Usage: wrapWithNavigation(DashboardScreen(), currentIndex: 0, onTap: (index) => ...)
Widget wrapWithNavigation(
  Widget screen, {
  required int currentIndex,
  required Function(int) onTap,
  AnimationController? animationController,
}) {
  return ScreenWithNavigation(
    currentIndex: currentIndex,
    onNavigationTap: onTap,
    animationController: animationController,
    child: screen,
  );
}
