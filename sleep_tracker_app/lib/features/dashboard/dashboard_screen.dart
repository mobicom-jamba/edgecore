import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_header.dart';

class DashboardScreen extends HookWidget {
  const DashboardScreen({super.key});

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
            _buildGreetingHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    _buildSleepSummaryCard(animationController),
                    const SizedBox(height: 8),
                    _buildSleepWaveCard(selectedPeriod, animationController),
                    const SizedBox(height: 8),
                    _buildTodaysFocus(animationController),
                    const SizedBox(height: 8),
                    _buildQuickActions(animationController),
                    const SizedBox(height: 8),
                    _buildSmartInsights(animationController),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildSleepNowFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildGreetingHeader() {
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 3, 12, 2),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, Sarah',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  _getContextualSubtitle(),
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppTheme.cardBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppTheme.textSecondary,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getContextualSubtitle() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'How did you sleep last night?';
    if (hour < 17) return 'Plan for better sleep tonight';
    return 'Ready for a restful night?';
  }

  Widget _buildSleepSummaryCard(AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: controller,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryBlue.withOpacity(0.08),
                AppTheme.sleepRem.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.13),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Last Night\'s Sleep',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: '7',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'h ',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              TextSpan(
                                text: '32',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: 'm',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1),
                        const Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 9,
                              color: AppTheme.sleepRem,
                            ),
                            SizedBox(width: 2),
                            Text(
                              '+12% vs last week',
                              style: TextStyle(
                                fontSize: 7,
                                color: AppTheme.sleepRem,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      _buildCircularProgress(85, 'Quality\nScore'),
                      const SizedBox(height: 5),
                      _buildDebtIndicator(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              _buildGoalProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProgress(int value, String label) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              value: value / 100,
              strokeWidth: 3,
              backgroundColor: AppTheme.cardBackground,
              valueColor: AlwaysStoppedAnimation<Color>(
                value >= 80
                    ? AppTheme.sleepRem
                    : value >= 60
                        ? AppTheme.primaryBlue
                        : AppTheme.sleepAwake,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 6,
                  color: AppTheme.textTertiary,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebtIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.sleepAwake.withOpacity(0.08),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: AppTheme.sleepAwake.withOpacity(0.22),
          width: 1,
        ),
      ),
      child: const Column(
        children: [
          Text(
            'Sleep Debt',
            style: TextStyle(
              fontSize: 6,
              color: AppTheme.textTertiary,
            ),
          ),
          Text(
            '-28m',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: AppTheme.sleepAwake,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.4),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.flag_outlined,
            color: AppTheme.primaryBlue,
            size: 11,
          ),
          SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sleep Goal Progress',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  '7h 32m of 8h goal',
                  style: TextStyle(
                    fontSize: 7,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '94%',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepWaveCard(
      ValueNotifier<int> selectedPeriod, AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 6,
                offset: const Offset(0, 2),
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
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 8),
              _buildSleepChart(),
              const SizedBox(height: 8),
              _buildSleepStagesSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaysFocus(AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.sleepRem.withOpacity(0.08),
                AppTheme.sleepDeep.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.sleepRem.withOpacity(0.13),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppTheme.sleepRem.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.sleepRem,
                  size: 15,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Focus',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      'Optimize your sleep environment',
                      style: TextStyle(
                        fontSize: 9,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          '2 of 3 completed',
                          style: TextStyle(
                            fontSize: 8,
                            color: AppTheme.sleepRem,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: 2 / 3,
                            backgroundColor: AppTheme.cardBackground,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.sleepRem),
                            minHeight: 4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textTertiary,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepNowFAB() {
    final hour = DateTime.now().hour;
    final isEvening = hour >= 20 || hour <= 6;

    if (!isEvening) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: () {
        // Navigate to sleep session
      },
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.bedtime, size: 16),
      label: const Text('Sleep Now', style: TextStyle(fontSize: 12)),
      elevation: 3,
    );
  }

  Widget _buildPeriodButton(
      String text, int index, ValueNotifier<int> selectedPeriod) {
    final isSelected = selectedPeriod.value == index;
    return GestureDetector(
      onTap: () => selectedPeriod.value = index,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 8,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.white : AppTheme.textTertiary,
          ),
        ),
      ),
    );
  }

  Widget _buildSleepChart() {
    return Container(
      height: 90,
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
        fontSize: 7,
        color: AppTheme.textTertiary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSleepStagesSummary() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardBackground,
            AppTheme.darkBackground.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.07),
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
                'Sleep Stages',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Last Night',
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                  child: _buildEnhancedStageItem(
                      'Deep', '1h 45m', AppTheme.sleepDeep, 0.23)),
              const SizedBox(width: 6),
              Expanded(
                  child: _buildEnhancedStageItem(
                      'Light', '4h 10m', AppTheme.sleepLight, 0.55)),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                  child: _buildEnhancedStageItem(
                      'REM', '1h 25m', AppTheme.sleepRem, 0.18)),
              const SizedBox(width: 6),
              Expanded(
                  child: _buildEnhancedStageItem(
                      'Awake', '12m', AppTheme.sleepAwake, 0.04)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedStageItem(
      String label, String duration, Color color, double percentage) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: color.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 8,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            '${(percentage * 100).toInt()}%',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withOpacity(0.13),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(2),
            minHeight: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
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
            const Text(
              'Quick Log',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickLogChip(
                      'Caffeine', Icons.local_cafe, AppTheme.sleepAwake),
                  const SizedBox(width: 6),
                  _buildQuickLogChip(
                      'Exercise', Icons.fitness_center, AppTheme.sleepRem),
                  const SizedBox(width: 6),
                  _buildQuickLogChip('Mood', Icons.mood, AppTheme.sleepDeep),
                  const SizedBox(width: 6),
                  _buildQuickLogChip(
                      'Stress', Icons.psychology, AppTheme.sleepLight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLogChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartInsights(AnimationController controller) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Smart Insights',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 9,
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            _buildInsightCard(
              'Consistency Pays Off',
              'Your consistent bedtime this week boosted your REM sleep by 15%. Keep it up!',
              Icons.trending_up,
              AppTheme.sleepRem,
              true,
            ),
            const SizedBox(height: 5),
            _buildInsightCard(
              'Late-Night Eating Impact',
              'Eating within 2 hours of bed seems to increase your awake time.',
              Icons.restaurant,
              AppTheme.sleepAwake,
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(String title, String description, IconData icon,
      Color iconColor, bool isPositive) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: iconColor.withOpacity(0.13),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.13),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 15,
            ),
          ),
          const SizedBox(width: 8),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPositive
                            ? AppTheme.sleepRem.withOpacity(0.13)
                            : AppTheme.sleepAwake.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        isPositive ? 'Good' : 'Watch',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: isPositive
                              ? AppTheme.sleepRem
                              : AppTheme.sleepAwake,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppTheme.textTertiary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.textTertiary,
            size: 15,
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
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryBlue.withOpacity(0.18),
          AppTheme.sleepDeep.withOpacity(0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final points = <Offset>[];
    final width = size.width;
    final height = size.height - 10;

    // Generate more realistic sleep wave pattern
    for (int i = 0; i <= 100; i++) {
      final x = (i / 100) * width;
      double y;

      if (i < 10) {
        y = height * 0.8 - (height * 0.3) * (i / 10);
      } else if (i < 25) {
        y = height * 0.5 - height * 0.3 * math.sin((i - 10) * 0.2);
      } else if (i < 40) {
        y = height * 0.6 + height * 0.1 * math.sin((i - 25) * 0.4);
      } else if (i < 55) {
        y = height * 0.4 - height * 0.2 * math.sin((i - 40) * 0.3);
      } else if (i < 70) {
        y = height * 0.7 + height * 0.15 * math.sin((i - 55) * 0.6);
      } else if (i < 85) {
        y = height * 0.75 + height * 0.1 * math.sin((i - 70) * 0.5);
      } else {
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

      fillPath.lineTo(size.width, size.height - 20);
      fillPath.lineTo(0, size.height - 20);
      fillPath.close();

      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
