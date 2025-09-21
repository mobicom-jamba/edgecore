import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final AnimationController? animationController;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home, 'label': 'Dashboard'},
      {'icon': Icons.music_note, 'label': 'Soundscapes'},
      {'icon': Icons.analytics, 'label': 'Analytics'},
      {'icon': Icons.person, 'label': 'Profile'},
    ];

    final animation = animationController != null
        ? CurvedAnimation(
            parent: animationController!,
            curve: Curves.easeOutCubic,
          )
        : null;

    Widget buildNavBar() {
      return Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == currentIndex;

                return Expanded(
                  // Equal width for all tabs
                  child: TweenAnimationBuilder(
                    duration: Duration(milliseconds: 300 + (index * 50)),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: 0.5 + (0.5 * value),
                        child: Opacity(
                          opacity: value,
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              onTap(index);
                            },
                            child: Container(
                              height: 64,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4), // Small margin between tabs
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.primaryBlue.withOpacity(0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: isSelected
                                    ? Border.all(
                                        color: AppTheme.primaryBlue
                                            .withOpacity(0.3),
                                        width: 1,
                                      )
                                    : null,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    item['icon'] as IconData,
                                    size: 24, // Fixed size for all tabs
                                    color: isSelected
                                        ? AppTheme.primaryBlue
                                        : AppTheme.textTertiary,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item['label'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10, // Fixed size for all tabs
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? AppTheme.primaryBlue
                                          : AppTheme.textTertiary,
                                      letterSpacing: 0.1,
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      );
    }

    if (animation != null) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 100 * (1 - animation.value)),
            child: Opacity(
              opacity: animation.value,
              child: buildNavBar(),
            ),
          );
        },
      );
    }

    return buildNavBar();
  }
}
