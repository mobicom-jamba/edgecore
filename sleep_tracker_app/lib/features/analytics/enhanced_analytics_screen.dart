import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_header.dart';

class EnhancedAnalyticsScreen extends HookWidget {
  const EnhancedAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = useState(1); // Week is selected by default
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );

    useEffect(() {
      animationController.forward();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'Sleep Analytics',
              showBackButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildSleepPatternsCard(selectedPeriod, animationController),
                    const SizedBox(height: 24),
                    _buildSleepStagesAnalysis(animationController),
                    const SizedBox(height: 24),
                    _buildSleepDebtTracker(animationController),
                    const SizedBox(height: 24),
                    _buildSmartInsights(animationController),
                    const SizedBox(height: 24),
                    _buildWeeklyTrends(animationController),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepPatternsCard(ValueNotifier<int> selectedPeriod, AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: controller,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sleep Patterns',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPeriodButton('Day', 0, selectedPeriod),
                        _buildPeriodButton('Week', 1, selectedPeriod),
                        _buildPeriodButton('Month', 2, selectedPeriod),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSleepChart(),
              const SizedBox(height: 20),
              _buildSleepMetrics(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String text, int index, ValueNotifier<int> selectedPeriod) {
    final isSelected = selectedPeriod.value == index;
    return GestureDetector(
      onTap: () => selectedPeriod.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildSleepChart() {
    return Container(
      height: 220,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: EnhancedSleepWavePainter(),
              child: Container(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeLabel('11 PM'),
                _buildTimeLabel('1 AM'),
                _buildTimeLabel('3 AM'),
                _buildTimeLabel('5 AM'),
                _buildTimeLabel('7 AM'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLabel(String time) {
    return Text(
      time,
      style: const TextStyle(
        fontSize: 12,
        color: AppTheme.textTertiary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSleepMetrics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _buildMetricItem('Avg Duration', '7h 32m', AppTheme.primaryBlue)),
          Expanded(child: _buildMetricItem('Efficiency', '89%', AppTheme.sleepRem)),
          Expanded(child: _buildMetricItem('Consistency', '92%', AppTheme.sleepDeep)),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSleepStagesAnalysis(AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: controller,
          curve: const Interval(0.2, 1.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.cardBackground,
                AppTheme.darkBackground.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sleep Stages Analysis',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '7 Days Avg',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedStageItem('Deep', '1h 45m', AppTheme.sleepDeep, 0.23, 'Excellent'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEnhancedStageItem('Light', '4h 10m', AppTheme.sleepLight, 0.55, 'Good'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildEnhancedStageItem('REM', '1h 25m', AppTheme.sleepRem, 0.18, 'Low'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEnhancedStageItem('Awake', '12m', AppTheme.sleepAwake, 0.04, 'Good'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStageItem(String label, String duration, Color color, double percentage, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
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

  Widget _buildSleepDebtTracker(AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: controller,
          curve: const Interval(0.3, 1.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.sleepAwake.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.sleepAwake.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.trending_down,
                      color: AppTheme.sleepAwake,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sleep Debt',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Track your sleep deficit',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    '-28m',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.sleepAwake,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'This Week',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDebtDay('Mon', 0, true),
                  _buildDebtDay('Tue', -15, false),
                  _buildDebtDay('Wed', 10, true),
                  _buildDebtDay('Thu', -30, false),
                  _buildDebtDay('Fri', -45, false),
                  _buildDebtDay('Sat', 20, true),
                  _buildDebtDay('Sun', 5, true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebtDay(String day, int minutes, bool isPositive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isPositive 
                ? AppTheme.successGreen.withOpacity(0.2)
                : AppTheme.sleepAwake.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              minutes > 0 ? '+$minutes' : '$minutes',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isPositive ? AppTheme.successGreen : AppTheme.sleepAwake,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildSmartInsights(AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: controller,
          curve: const Interval(0.4, 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Smart Insights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInsightCard(
              'Consistency Boost',
              'Your consistent bedtime this week improved REM sleep by 15%. Keep the routine!',
              Icons.trending_up,
              AppTheme.sleepRem,
              true,
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              'Late Meals Impact',
              'Eating within 2 hours of bedtime increases your wake time by 8 minutes on average.',
              Icons.restaurant,
              AppTheme.sleepAwake,
              false,
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              'Weekend Recovery',
              'Your weekend sleep helps recover 73% of weekday sleep debt. Great job!',
              Icons.weekend,
              AppTheme.successGreen,
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, String description, IconData icon, Color iconColor, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? AppTheme.successGreen.withOpacity(0.2)
                            : AppTheme.warningOrange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isPositive ? 'Good' : 'Watch',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isPositive ? AppTheme.successGreen : AppTheme.warningOrange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textTertiary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrends(AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: controller,
          curve: const Interval(0.5, 1.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Weekly Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildTrendItem('Duration', '+12%', true, AppTheme.primaryBlue)),
                  Expanded(child: _buildTrendItem('Quality', '+8%', true, AppTheme.sleepRem)),
                  Expanded(child: _buildTrendItem('Efficiency', '-3%', false, AppTheme.sleepLight)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendItem(String label, String change, bool isPositive, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? AppTheme.successGreen : AppTheme.sleepAwake,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPositive ? AppTheme.successGreen : AppTheme.sleepAwake,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
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

class EnhancedSleepWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryBlue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryBlue.withOpacity(0.3),
          AppTheme.sleepDeep.withOpacity(0.1),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final points = <Offset>[];
    final width = size.width;
    final height = size.height - 20;

    // Generate more realistic sleep wave pattern
    for (int i = 0; i <= 100; i++) {
      final x = (i / 100) * width;
      double y;

      if (i < 10) {
        // Falling asleep gradually
        y = height * 0.8 - (height * 0.3) * (i / 10);
      } else if (i < 25) {
        // First deep sleep cycle
        y = height * 0.5 - height * 0.3 * math.sin((i - 10) * 0.2);
      } else if (i < 40) {
        // Light sleep
        y = height * 0.6 + height * 0.1 * math.sin((i - 25) * 0.4);
      } else if (i < 55) {
        // Second deep sleep cycle
        y = height * 0.4 - height * 0.2 * math.sin((i - 40) * 0.3);
      } else if (i < 70) {
        // REM sleep with more variation
        y = height * 0.7 + height * 0.15 * math.sin((i - 55) * 0.6);
      } else if (i < 85) {
        // Light sleep before morning
        y = height * 0.75 + height * 0.1 * math.sin((i - 70) * 0.5);
      } else {
        // Gradual awakening
        y = height * 0.85 - height * 0.1 * ((i - 85) / 15);
      }

      points.add(Offset(x, y));
    }

    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      fillPath.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; i++) {
        if (i < points.length - 1) {
          final xc = (points[i].dx + points[i + 1].dx) / 2;
          final yc = (points[i].dy + points[i + 1].dy) / 2;
          path.quadraticBezierTo(points[i].dx, points[i].dy, xc, yc);
          fillPath.quadraticBezierTo(points[i].dx, points[i].dy, xc, yc);
        } else {
          path.lineTo(points[i].dx, points[i].dy);
          fillPath.lineTo(points[i].dx, points[i].dy);
        }
      }

      // Complete fill path
      fillPath.lineTo(size.width, size.height - 50);
      fillPath.lineTo(0, size.height - 50);
      fillPath.close();

      // Draw fill first, then stroke
      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
