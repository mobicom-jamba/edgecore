import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../models/enhanced_sleep_data.dart';
import 'enhanced_dashboard_widgets.dart';

class InteractiveSleepChart extends StatefulWidget {
  final EnhancedSleepData sleepData;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;
  final Function(DateTime)? onTimePointTap;

  const InteractiveSleepChart({
    Key? key,
    required this.sleepData,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.onTimePointTap,
  }) : super(key: key);

  @override
  State<InteractiveSleepChart> createState() => _InteractiveSleepChartState();
}

class _InteractiveSleepChartState extends State<InteractiveSleepChart>
    with TickerProviderStateMixin {
  Offset? _touchPoint;
  DateTime? _touchTime;
  SleepStageType? _touchStage;
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
    return Container(
      height: 320,
      child: Column(
        children: [
          // Period selector with strong visual states
          PeriodSelector(
            periods: ['Day', 'Week', 'Month'],
            selected: widget.selectedPeriod,
            onChanged: widget.onPeriodChanged,
          ),
          const SizedBox(height: 16),
          // Interactive chart with touch feedback
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: SleepColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildChartHeader(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Semantics(
                      label: 'Sleep wave chart',
                      hint: 'Interactive chart showing sleep stages throughout the night. Touch to explore different time points.',
                      child: GestureDetector(
                        onTapDown: _handleChartTap,
                        onPanUpdate: _handleChartPan,
                        onPanEnd: (_) => _clearTouch(),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: EnhancedSleepChartPainter(
                              data: widget.sleepData,
                              period: widget.selectedPeriod,
                              touchPoint: _touchPoint,
                              touchTime: _touchTime,
                              touchStage: _touchStage,
                              animationValue: _animation.value,
                            ),
                            size: Size.infinite,
                          );
                        },
                      ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeLabels(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Stage breakdown with corrected format
          SleepStageBreakdown(data: widget.sleepData),
        ],
      ),
    );
  }

  Widget _buildChartHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sleep Wave',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SleepColors.textPrimary,
          ),
        ),
        if (_touchTime != null && _touchStage != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: SleepColors.getStageColor(_touchStage!).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_formatTime(_touchTime!)} - ${_getStageDisplayName(_touchStage!)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: SleepColors.getStageColor(_touchStage!),
              ),
            ),
          ),
        ] else ...[
          Text(
            '${widget.sleepData.formattedTotalSleep} total',
            style: TextStyle(
              fontSize: 14,
              color: SleepColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeLabels() {
    final bedtime = widget.sleepData.bedtime;
    final wakeTime = widget.sleepData.wakeTime;
    final totalHours = wakeTime.difference(bedtime).inHours;
    
    final labels = <String>[];
    for (int i = 0; i <= 4; i++) {
      final time = bedtime.add(Duration(hours: (totalHours * i / 4).round()));
      labels.add(_formatTime(time));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) {
        return Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: SleepColors.textTertiary,
          ),
        );
      }).toList(),
    );
  }

  void _handleChartTap(TapDownDetails details) {
    _updateTouchPoint(details.localPosition);
    HapticFeedback.lightImpact();
  }

  void _handleChartPan(DragUpdateDetails details) {
    _updateTouchPoint(details.localPosition);
  }

  void _updateTouchPoint(Offset point) {
    setState(() {
      _touchPoint = point;
      _touchTime = _calculateTimeFromPoint(point);
      _touchStage = _calculateStageFromPoint(point);
    });
    
    if (widget.onTimePointTap != null && _touchTime != null) {
      widget.onTimePointTap!(_touchTime!);
    }
  }

  void _clearTouch() {
    setState(() {
      _touchPoint = null;
      _touchTime = null;
      _touchStage = null;
    });
  }

  DateTime? _calculateTimeFromPoint(Offset point) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    
    final size = renderBox.size;
    final chartWidth = size.width - 32; // Account for padding
    final progress = (point.dx - 16).clamp(0.0, chartWidth) / chartWidth;
    
    final bedtime = widget.sleepData.bedtime;
    final wakeTime = widget.sleepData.wakeTime;
    final totalDuration = wakeTime.difference(bedtime);
    
    return bedtime.add(Duration(
      milliseconds: (totalDuration.inMilliseconds * progress).round(),
    ));
  }

  SleepStageType? _calculateStageFromPoint(Offset point) {
    if (_touchTime == null) return null;
    
    // Find which sleep stage the touch time falls into
    for (final stage in widget.sleepData.stages) {
      if (_touchTime!.isAfter(stage.startTime) && 
          _touchTime!.isBefore(stage.endTime)) {
        return stage.type;
      }
    }
    return null;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final period = time.hour < 12 ? 'AM' : 'PM';
    return '$hour ${period}';
  }

  String _getStageDisplayName(SleepStageType type) {
    switch (type) {
      case SleepStageType.deep:
        return 'Deep Sleep';
      case SleepStageType.light:
        return 'Light Sleep';
      case SleepStageType.rem:
        return 'REM Sleep';
      case SleepStageType.awake:
        return 'Awake';
    }
  }
}

class EnhancedSleepChartPainter extends CustomPainter {
  final EnhancedSleepData data;
  final String period;
  final Offset? touchPoint;
  final DateTime? touchTime;
  final SleepStageType? touchStage;
  final double animationValue;

  EnhancedSleepChartPainter({
    required this.data,
    required this.period,
    this.touchPoint,
    this.touchTime,
    this.touchStage,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height - 20; // Leave space for touch indicator

    // Draw sleep stages as colored segments
    _drawSleepStages(canvas, width, height);
    
    // Draw the main sleep wave
    _drawSleepWave(canvas, width, height);
    
    // Draw touch indicator
    if (touchPoint != null) {
      _drawTouchIndicator(canvas, width, height);
    }
    
    // Draw stage duration labels
    _drawStageDurationLabels(canvas, width, height);
  }

  void _drawSleepStages(Canvas canvas, double width, double height) {
    final bedtime = data.bedtime;
    final wakeTime = data.wakeTime;
    final totalDuration = wakeTime.difference(bedtime);

    for (final stage in data.stages) {
      final stageStart = stage.startTime.difference(bedtime).inMilliseconds / 
                        totalDuration.inMilliseconds;
      final stageDuration = stage.duration.inMilliseconds / 
                           totalDuration.inMilliseconds;
      
      final startX = stageStart * width * animationValue;
      final stageWidth = stageDuration * width * animationValue;
      
      final paint = Paint()
        ..color = SleepColors.getStageColor(stage.type).withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(startX, 0, stageWidth, height),
        paint,
      );
    }
  }

  void _drawSleepWave(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..color = SleepColors.lightSleep
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          SleepColors.lightSleep.withOpacity(0.3),
          SleepColors.deepSleep.withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Generate wave points based on sleep stages
    final points = _generateWavePoints(width, height);

    if (points.isNotEmpty) {
      // Animate the wave drawing
      final animatedPoints = points.take((points.length * animationValue).round()).toList();
      
      if (animatedPoints.isNotEmpty) {
        path.moveTo(animatedPoints[0].dx, animatedPoints[0].dy);
        fillPath.moveTo(animatedPoints[0].dx, animatedPoints[0].dy);

        for (int i = 1; i < animatedPoints.length; i++) {
          if (i < animatedPoints.length - 1) {
            final xc = (animatedPoints[i].dx + animatedPoints[i + 1].dx) / 2;
            final yc = (animatedPoints[i].dy + animatedPoints[i + 1].dy) / 2;
            path.quadraticBezierTo(animatedPoints[i].dx, animatedPoints[i].dy, xc, yc);
            fillPath.quadraticBezierTo(animatedPoints[i].dx, animatedPoints[i].dy, xc, yc);
          } else {
            path.lineTo(animatedPoints[i].dx, animatedPoints[i].dy);
            fillPath.lineTo(animatedPoints[i].dx, animatedPoints[i].dy);
          }
        }

        // Complete fill path
        if (animatedPoints.isNotEmpty) {
          fillPath.lineTo(animatedPoints.last.dx, height);
          fillPath.lineTo(0, height);
          fillPath.close();
        }

        // Draw fill first, then stroke
        canvas.drawPath(fillPath, fillPaint);
        canvas.drawPath(path, paint);
      }
    }
  }

  List<Offset> _generateWavePoints(double width, double height) {
    final points = <Offset>[];
    final bedtime = data.bedtime;
    final wakeTime = data.wakeTime;
    final totalDuration = wakeTime.difference(bedtime);

    // Generate points based on actual sleep stages
    for (int i = 0; i <= 100; i++) {
      final progress = i / 100;
      final currentTime = bedtime.add(Duration(
        milliseconds: (totalDuration.inMilliseconds * progress).round(),
      ));
      
      // Find current sleep stage
      SleepStageType currentStage = SleepStageType.awake;
      for (final stage in data.stages) {
        if (currentTime.isAfter(stage.startTime) && 
            currentTime.isBefore(stage.endTime)) {
          currentStage = stage.type;
          break;
        }
      }
      
      // Map sleep stage to Y position
      final y = _getYPositionForStage(currentStage, height, progress);
      points.add(Offset(progress * width, y));
    }

    return points;
  }

  double _getYPositionForStage(SleepStageType stage, double height, double progress) {
    // Add some variation to make it look more natural
    final baseNoise = sin(progress * 10) * 0.05;
    final detailNoise = sin(progress * 50) * 0.02;
    
    switch (stage) {
      case SleepStageType.awake:
        return height * (0.1 + baseNoise + detailNoise);
      case SleepStageType.light:
        return height * (0.4 + baseNoise + detailNoise);
      case SleepStageType.rem:
        return height * (0.3 + baseNoise + detailNoise);
      case SleepStageType.deep:
        return height * (0.7 + baseNoise + detailNoise);
    }
  }

  void _drawTouchIndicator(Canvas canvas, double width, double height) {
    if (touchPoint == null) return;

    final paint = Paint()
      ..color = SleepColors.textPrimary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = touchStage != null 
          ? SleepColors.getStageColor(touchStage!)
          : SleepColors.textPrimary
      ..style = PaintingStyle.fill;

    // Draw vertical line
    canvas.drawLine(
      Offset(touchPoint!.dx, 0),
      Offset(touchPoint!.dx, height),
      paint,
    );

    // Draw touch point circle
    canvas.drawCircle(touchPoint!, 6, fillPaint);
    canvas.drawCircle(touchPoint!, 6, paint);
  }

  void _drawStageDurationLabels(Canvas canvas, double width, double height) {
    // Draw duration labels for major sleep stages
    final bedtime = data.bedtime;
    final wakeTime = data.wakeTime;
    final totalDuration = wakeTime.difference(bedtime);

    for (final stage in data.stages) {
      if (stage.duration.inMinutes < 30) continue; // Skip short stages
      
      final stageMiddle = stage.startTime.add(Duration(
        milliseconds: stage.duration.inMilliseconds ~/ 2,
      ));
      
      final progress = stageMiddle.difference(bedtime).inMilliseconds / 
                      totalDuration.inMilliseconds;
      final x = progress * width;
      final y = _getYPositionForStage(stage.type, height, progress);
      
      final hours = stage.duration.inHours;
      final minutes = stage.duration.inMinutes.remainder(60);
      final durationText = hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
      
      _drawLabel(
        canvas,
        '${durationText} ${_getStageDisplayName(stage.type)}',
        Offset(x, y - 20),
        SleepColors.getStageColor(stage.type),
      );
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset position, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    // Draw background
    final rect = Rect.fromCenter(
      center: position,
      width: textPainter.width + 12,
      height: textPainter.height + 6,
    );
    
    final bgPaint = Paint()
      ..color = SleepColors.background.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      bgPaint,
    );
    
    // Draw text
    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  String _getStageDisplayName(SleepStageType type) {
    switch (type) {
      case SleepStageType.deep:
        return 'Deep Sleep';
      case SleepStageType.light:
        return 'Light Sleep';
      case SleepStageType.rem:
        return 'REM Sleep';
      case SleepStageType.awake:
        return 'Awake';
    }
  }

  @override
  bool shouldRepaint(EnhancedSleepChartPainter oldDelegate) {
    return oldDelegate.touchPoint != touchPoint ||
           oldDelegate.animationValue != animationValue ||
           oldDelegate.period != period;
  }
}
