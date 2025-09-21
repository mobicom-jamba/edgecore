import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? rightAction;
  final bool showSearch;
  final TextEditingController? searchController;
  final String? searchHint;
  final bool animated;
  final Animation<double>? animation;

  const AppHeader({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.rightAction,
    this.showSearch = false,
    this.searchController,
    this.searchHint,
    this.animated = true,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    if (animated && animation != null) {
      return AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -50 * (1 - animation!.value)),
            child: Opacity(
              opacity: animation!.value,
              child: _buildHeader(context),
            ),
          );
        },
      );
    }

    return _buildHeader(context);
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF111121),
            const Color(0xFF111121).withOpacity(0.95),
          ],
        ),
        border: const Border(
          bottom: BorderSide(color: Colors.white10, width: 0.5),
        ),
      ),
      child: Column(
        children: [
          _buildTopRow(context),
          if (showSearch) ...[
            const SizedBox(height: 16),
            _buildSearchBar(context),
          ],
        ],
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Row(
      children: [
        if (showBackButton)
          _buildAnimatedIconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              if (onBackPressed != null) {
                onBackPressed!();
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: Icons.arrow_back_ios_new,
            delay: 100,
          )
        else
          const SizedBox(width: 48), // Space to center title

        Expanded(
          child: animated && animation != null
              ? TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: _buildTitle(),
                      ),
                    );
                  },
                )
              : _buildTitle(),
        ),

        if (rightAction != null)
          rightAction!
        else
          const SizedBox(width: 48), // Space to balance layout
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    Widget searchBar = Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a2e),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: searchHint ?? 'Search...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
          suffixIcon: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Voice search functionality
            },
            child: Icon(Icons.mic, color: Colors.grey[400], size: 18),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );

    if (animated && animation != null) {
      return TweenAnimationBuilder(
        duration: const Duration(milliseconds: 800),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: Opacity(
              opacity: value,
              child: searchBar,
            ),
          );
        },
      );
    }

    return searchBar;
  }

  Widget _buildAnimatedIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    required int delay,
  }) {
    Widget iconButton = Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
        ),
      ),
    );

    if (animated && animation != null) {
      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 500 + delay),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: 0.5 + (0.5 * value),
            child: Opacity(
              opacity: value,
              child: iconButton,
            ),
          );
        },
      );
    }

    return iconButton;
  }
}

// Helper widget for creating right action buttons
class HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool animated;
  final int delay;

  const HeaderActionButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.animated = true,
    this.delay = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button = Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
        ),
      ),
    );

    if (animated) {
      return TweenAnimationBuilder(
        duration: Duration(milliseconds: 500 + delay),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, double value, child) {
          return Transform.scale(
            scale: 0.5 + (0.5 * value),
            child: Opacity(
              opacity: value,
              child: button,
            ),
          );
        },
      );
    }

    return button;
  }
}
