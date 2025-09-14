import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A circular progress ring widget for displaying countdown timers
class ProgressRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final Widget? child;
  final bool animate;
  final Duration animationDuration;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.color,
    this.backgroundColor,
    this.child,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<ProgressRing> createState() => _ProgressRingState();
}

class _ProgressRingState extends State<ProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.animate ? _animation.value : widget.progress;
    final color = widget.color ?? AppTheme.accentPrimary;
    final backgroundColor = widget.backgroundColor ?? AppTheme.divider;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Background circle
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ProgressRingPainter(
              progress: 1.0,
              strokeWidth: widget.strokeWidth,
              color: backgroundColor,
            ),
          ),
          // Progress circle
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _ProgressRingPainter(
              progress: progress,
              strokeWidth: widget.strokeWidth,
              color: color,
            ),
          ),
          // Child widget (centered)
          if (widget.child != null)
            Center(child: widget.child!),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  _ProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw the arc
    final startAngle = -90 * (3.14159 / 180); // Start from top
    final sweepAngle = 2 * 3.14159 * progress; // Full circle * progress

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _ProgressRingPainter &&
        (oldDelegate.progress != progress ||
            oldDelegate.strokeWidth != strokeWidth ||
            oldDelegate.color != color);
  }
}

/// A pulsing progress ring for urgent countdowns (e.g., T-5 minutes)
class PulsingProgressRing extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final Widget? child;
  final bool shouldPulse;

  const PulsingProgressRing({
    super.key,
    required this.progress,
    this.size = 120.0,
    this.strokeWidth = 8.0,
    this.color,
    this.backgroundColor,
    this.child,
    this.shouldPulse = false,
  });

  @override
  State<PulsingProgressRing> createState() => _PulsingProgressRingState();
}

class _PulsingProgressRingState extends State<PulsingProgressRing>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.shouldPulse) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsingProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldPulse != oldWidget.shouldPulse) {
      if (widget.shouldPulse) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.shouldPulse ? _pulseAnimation.value : 1.0,
          child: ProgressRing(
            progress: widget.progress,
            size: widget.size,
            strokeWidth: widget.strokeWidth,
            color: widget.color,
            backgroundColor: widget.backgroundColor,
            child: widget.child,
            animate: false, // We handle animation with pulse
          ),
        );
      },
    );
  }
}