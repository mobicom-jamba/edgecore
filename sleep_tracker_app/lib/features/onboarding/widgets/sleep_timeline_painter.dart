import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// Custom painter for sleep timeline visualization
class SleepTimelinePainter extends CustomPainter {
  final TimeOfDay bedtime;
  final TimeOfDay wakeTime;
  final Color primaryColor;
  final Color sleepColor;

  SleepTimelinePainter({
    required this.bedtime,
    required this.wakeTime,
    required this.primaryColor,
    required this.sleepColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;
    final centerY = height / 2;
    final radius = 8.0;

    // Draw 24-hour timeline background
    paint.color = primaryColor.withOpacity(0.2);
    canvas.drawLine(
      Offset(radius, centerY),
      Offset(width - radius, centerY),
      paint,
    );

    // Calculate positions on timeline (0-24 hours)
    double bedtimePos = (bedtime.hour + bedtime.minute / 60.0) / 24.0;
    double wakeTimePos = (wakeTime.hour + wakeTime.minute / 60.0) / 24.0;

    // Handle overnight sleep (bedtime > wake time)
    if (wakeTimePos <= bedtimePos) {
      // Draw sleep arc from bedtime to end of day
      paint.color = sleepColor;
      paint.strokeWidth = 6;
      canvas.drawLine(
        Offset(radius + (width - 2 * radius) * bedtimePos, centerY),
        Offset(width - radius, centerY),
        paint,
      );
      
      // Draw sleep arc from start of day to wake time
      canvas.drawLine(
        Offset(radius, centerY),
        Offset(radius + (width - 2 * radius) * wakeTimePos, centerY),
        paint,
      );
    } else {
      // Normal sleep (same day)
      paint.color = sleepColor;
      paint.strokeWidth = 6;
      canvas.drawLine(
        Offset(radius + (width - 2 * radius) * bedtimePos, centerY),
        Offset(radius + (width - 2 * radius) * wakeTimePos, centerY),
        paint,
      );
    }

    // Draw bedtime marker
    fillPaint.color = primaryColor;
    canvas.drawCircle(
      Offset(radius + (width - 2 * radius) * bedtimePos, centerY),
      radius,
      fillPaint,
    );

    // Draw wake time marker
    fillPaint.color = AppTheme.warningOrange;
    canvas.drawCircle(
      Offset(radius + (width - 2 * radius) * wakeTimePos, centerY),
      radius,
      fillPaint,
    );

    // Draw time labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Bedtime label
    textPainter.text = TextSpan(
      text: _formatTime(bedtime),
      style: TextStyle(
        color: primaryColor,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
    textPainter.layout();
    final bedtimeX = radius + (width - 2 * radius) * bedtimePos;
    textPainter.paint(
      canvas,
      Offset(bedtimeX - textPainter.width / 2, centerY + radius + 4),
    );

    // Wake time label
    textPainter.text = TextSpan(
      text: _formatTime(wakeTime),
      style: TextStyle(
        color: AppTheme.warningOrange,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
    textPainter.layout();
    final wakeTimeX = radius + (width - 2 * radius) * wakeTimePos;
    textPainter.paint(
      canvas,
      Offset(wakeTimeX - textPainter.width / 2, centerY + radius + 4),
    );

    // Draw hour markers
    paint.color = primaryColor.withOpacity(0.3);
    paint.strokeWidth = 1;
    for (int hour = 0; hour <= 24; hour += 6) {
      final x = radius + (width - 2 * radius) * (hour / 24.0);
      canvas.drawLine(
        Offset(x, centerY - 4),
        Offset(x, centerY + 4),
        paint,
      );

      // Hour labels
      if (hour < 24) {
        textPainter.text = TextSpan(
          text: hour == 0 ? '12 AM' : hour == 12 ? '12 PM' : hour < 12 ? '${hour} AM' : '${hour - 12} PM',
          style: TextStyle(
            color: primaryColor.withOpacity(0.6),
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, centerY - radius - 16),
        );
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is! SleepTimelinePainter ||
        oldDelegate.bedtime != bedtime ||
        oldDelegate.wakeTime != wakeTime;
  }
}

