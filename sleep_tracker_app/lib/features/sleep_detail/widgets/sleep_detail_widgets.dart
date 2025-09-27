import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SleepQualityRing extends StatefulWidget {
  final int score;
  final double size;
  final double strokeWidth;

  const SleepQualityRing({
    super.key,
    required this.score,
    this.size = 100,
    this.strokeWidth = 8,
  });

  @override
  State<SleepQualityRing> createState() => _SleepQualityRingState();
}

class _SleepQualityRingState extends State<SleepQualityRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                width: widget.size,
                height: widget.size,
                child: CircularProgressIndicator(
                  value: (widget.score / 100) * _animation.value,
                  strokeWidth: widget.strokeWidth,
                  backgroundColor: AppTheme.cardBackground.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getScoreColor(widget.score),
                  ),
                ),
              );
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final animatedScore = (widget.score * _animation.value).toInt();
                  return Text(
                    '$animatedScore',
                    style: TextStyle(
                      fontSize: widget.size * 0.25,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  );
                },
              ),
              Text(
                'Quality\nScore',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.size * 0.1,
                  color: AppTheme.textTertiary,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return AppTheme.successGreen;
    if (score >= 60) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }
}

class SleepStageCard extends StatelessWidget {
  final String stage;
  final String duration;
  final int percentage;
  final Color color;
  final String quality;
  final String improvement;
  final bool? isPositive;

  const SleepStageCard({
    super.key,
    required this.stage,
    required this.duration,
    required this.percentage,
    required this.color,
    required this.quality,
    required this.improvement,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  stage,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: _getQualityColor(quality).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  quality,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: _getQualityColor(quality),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(2),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPositive != null)
                Icon(
                  isPositive! ? Icons.trending_up : Icons.trending_down,
                  size: 10,
                  color: isPositive! ? AppTheme.successGreen : AppTheme.warningOrange,
                ),
              if (isPositive != null) const SizedBox(width: 2),
              Flexible(
                child: Text(
                  improvement,
                  style: TextStyle(
                    fontSize: 9,
                    color: isPositive == null
                        ? AppTheme.textTertiary
                        : isPositive!
                            ? AppTheme.successGreen
                            : AppTheme.warningOrange,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getQualityColor(String quality) {
    switch (quality.toLowerCase()) {
      case 'excellent':
        return AppTheme.successGreen;
      case 'good':
        return AppTheme.primaryBlue;
      case 'low':
        return AppTheme.warningOrange;
      default:
        return AppTheme.textSecondary;
    }
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool? isPositive;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              if (isPositive != null)
                Icon(
                  isPositive! ? Icons.trending_up : Icons.trending_down,
                  color: isPositive! ? AppTheme.successGreen : AppTheme.warningOrange,
                  size: 14,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 1),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 8,
                color: isPositive == null
                    ? AppTheme.textTertiary
                  : isPositive!
                      ? AppTheme.successGreen
                      : AppTheme.warningOrange,
              fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class EnvironmentCard extends StatelessWidget {
  final String title;
  final String value;
  final String status;
  final IconData icon;
  final Color color;

  const EnvironmentCard({
    super.key,
    required this.title,
    required this.value,
    required this.status,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class HypnogramPainter extends CustomPainter {
  final double animationValue;

  HypnogramPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height - 40;

    // Sleep stages (0 = Awake, 1 = REM, 2 = Light, 3 = Deep)
    final sleepStages = [
      0, 0, 2, 2, 3, 3, 3, 2, 2, 1, 1, 2, 2, 3, 3, 3, 2, 2, 1, 1, 1, 2, 2, 0, 0,
      2, 2, 3, 3, 2, 2, 1, 1, 1, 2, 2, 3, 3, 2, 2, 1, 1, 2, 2, 0, 0, 2, 2, 1, 1,
      1, 1, 2, 2, 0, 0, 0, 0, 0, 0
    ];

    final path = Path();
    final points = <Offset>[];

    // Generate points based on sleep stages
    for (int i = 0; i < sleepStages.length; i++) {
      if (i / sleepStages.length <= animationValue) {
        final x = (i / (sleepStages.length - 1)) * width;
        final stage = sleepStages[i];
        final y = height - (stage / 3) * height;
        points.add(Offset(x, y));
      }
    }

    if (points.isNotEmpty) {
      // Create smooth path
      path.moveTo(points[0].dx, points[0].dy);
      
      for (int i = 1; i < points.length; i++) {
        final currentPoint = points[i];
        final previousPoint = points[i - 1];
        
        // Create step-like transitions for sleep stages
        path.lineTo(currentPoint.dx, previousPoint.dy);
        path.lineTo(currentPoint.dx, currentPoint.dy);
      }

      // Draw different colors for different stages
      for (int i = 0; i < points.length - 1; i++) {
        final currentPoint = points[i];
        final nextPoint = points[i + 1];
        final stage = sleepStages[i.clamp(0, sleepStages.length - 1)];
        
        paint.color = _getStageColor(stage);
        
        final segmentPath = Path();
        segmentPath.moveTo(currentPoint.dx, currentPoint.dy);
        segmentPath.lineTo(nextPoint.dx, currentPoint.dy);
        segmentPath.lineTo(nextPoint.dx, nextPoint.dy);
        
        canvas.drawPath(segmentPath, paint);
      }
    }

    // Draw time labels
    _drawTimeLabels(canvas, size);
    
    // Draw stage labels
    _drawStageLabels(canvas, size);
  }

  void _drawTimeLabels(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final times = ['10:30 PM', '12:30 AM', '2:30 AM', '4:30 AM', '6:30 AM'];
    
    for (int i = 0; i < times.length; i++) {
      final x = (i / (times.length - 1)) * size.width;
      
      textPainter.text = TextSpan(
        text: times[i],
        style: const TextStyle(
          color: AppTheme.textTertiary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 20),
      );
    }
  }

  void _drawStageLabels(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final stages = ['Awake', 'REM', 'Light', 'Deep'];
    final height = size.height - 40;
    
    for (int i = 0; i < stages.length; i++) {
      final y = height - (i / 3) * height;
      
      textPainter.text = TextSpan(
        text: stages[i],
        style: TextStyle(
          color: _getStageColor(i),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width - 8, y - textPainter.height / 2),
      );
    }
  }

  Color _getStageColor(int stage) {
    switch (stage) {
      case 0:
        return AppTheme.sleepAwake;
      case 1:
        return AppTheme.sleepRem;
      case 2:
        return AppTheme.sleepLight;
      case 3:
        return AppTheme.sleepDeep;
      default:
        return AppTheme.textTertiary;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is HypnogramPainter && oldDelegate.animationValue != animationValue;
  }
}
