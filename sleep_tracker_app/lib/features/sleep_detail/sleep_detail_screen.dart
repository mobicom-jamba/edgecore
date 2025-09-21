import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_header.dart';
import 'widgets/sleep_detail_widgets.dart';

class SleepDetailScreen extends StatefulWidget {
  final DateTime sleepDate;

  const SleepDetailScreen({
    super.key,
    required this.sleepDate,
  });

  @override
  State<SleepDetailScreen> createState() => _SleepDetailScreenState();
}

class _SleepDetailScreenState extends State<SleepDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _hypnogramController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _hypnogramController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _hypnogramController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _hypnogramController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'Sleep Analysis',
              showBackButton: true,
              rightAction: HeaderActionButton(
                icon: Icons.share_outlined,
                onPressed: _showShareOptions,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            _buildSleepOverview(),
                            const SizedBox(height: 24),
                            _buildHypnogram(),
                            const SizedBox(height: 24),
                            _buildSleepStagesBreakdown(),
                            const SizedBox(height: 24),
                            _buildSleepMetrics(),
                            const SizedBox(height: 24),
                            _buildEnvironmentalFactors(),
                            const SizedBox(height: 24),
                            _buildSleepEvents(),
                            const SizedBox(height: 24),
                            _buildRecoveryMetrics(),
                            const SizedBox(height: 24),
                            _buildRecommendations(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryBlue.withOpacity(0.15),
            AppTheme.sleepRem.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatSleepDate(widget.sleepDate),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '7',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            letterSpacing: -2,
                          ),
                        ),
                        TextSpan(
                          text: 'h ',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        TextSpan(
                          text: '32',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            letterSpacing: -2,
                          ),
                        ),
                        TextSpan(
                          text: 'm',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Total Sleep Time',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
              SleepQualityRing(
                score: 85,
                size: 120,
                strokeWidth: 10,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildOverviewMetric(
                  'Bedtime',
                  '10:30 PM',
                  Icons.bedtime_outlined,
                  AppTheme.sleepDeep,
                ),
              ),
              Expanded(
                child: _buildOverviewMetric(
                  'Wake Time',
                  '6:45 AM',
                  Icons.wb_sunny_outlined,
                  AppTheme.warningOrange,
                ),
              ),
              Expanded(
                child: _buildOverviewMetric(
                  'Efficiency',
                  '89%',
                  Icons.trending_up,
                  AppTheme.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
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

  Widget _buildHypnogram() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.borderColor,
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
                'Sleep Hypnogram',
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
                  'Detailed View',
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
          SizedBox(
            height: 250,
            child: AnimatedBuilder(
              animation: _hypnogramController,
              builder: (context, child) {
                return CustomPaint(
                  painter: HypnogramPainter(
                    animationValue: _hypnogramController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildSleepStagesLegend(),
        ],
      ),
    );
  }

  Widget _buildSleepStagesLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Awake', AppTheme.sleepAwake),
        _buildLegendItem('REM', AppTheme.sleepRem),
        _buildLegendItem('Light', AppTheme.sleepLight),
        _buildLegendItem('Deep', AppTheme.sleepDeep),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepStagesBreakdown() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep Stages Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SleepStageCard(
                  stage: 'Deep Sleep',
                  duration: '1h 45m',
                  percentage: 23,
                  color: AppTheme.sleepDeep,
                  quality: 'Excellent',
                  improvement: '+5min vs avg',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SleepStageCard(
                  stage: 'Light Sleep',
                  duration: '4h 10m',
                  percentage: 55,
                  color: AppTheme.sleepLight,
                  quality: 'Good',
                  improvement: 'Normal',
                  isPositive: null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SleepStageCard(
                  stage: 'REM Sleep',
                  duration: '1h 25m',
                  percentage: 18,
                  color: AppTheme.sleepRem,
                  quality: 'Low',
                  improvement: '-8min vs avg',
                  isPositive: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SleepStageCard(
                  stage: 'Awake',
                  duration: '12m',
                  percentage: 4,
                  color: AppTheme.sleepAwake,
                  quality: 'Good',
                  improvement: '-2min vs avg',
                  isPositive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepMetrics() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: [
              MetricCard(
                title: 'Time to Sleep',
                value: '8 min',
                subtitle: '3min faster than avg',
                icon: Icons.timer_outlined,
                color: AppTheme.successGreen,
                isPositive: true,
              ),
              MetricCard(
                title: 'Sleep Debt',
                value: '-15 min',
                subtitle: 'Slight deficit',
                icon: Icons.trending_down,
                color: AppTheme.warningOrange,
                isPositive: false,
              ),
              MetricCard(
                title: 'Restlessness',
                value: '3 times',
                subtitle: 'Low movement',
                icon: Icons.motion_photos_off,
                color: AppTheme.successGreen,
                isPositive: true,
              ),
              MetricCard(
                title: 'Heart Rate',
                value: '58 bpm',
                subtitle: 'Resting average',
                icon: Icons.favorite_outline,
                color: AppTheme.primaryBlue,
                isPositive: null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalFactors() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Environmental Factors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: EnvironmentCard(
                  title: 'Temperature',
                  value: '68°F',
                  status: 'Optimal',
                  icon: Icons.thermostat_outlined,
                  color: AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: EnvironmentCard(
                  title: 'Humidity',
                  value: '45%',
                  status: 'Good',
                  icon: Icons.water_drop_outlined,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: EnvironmentCard(
                  title: 'Noise Level',
                  value: '32 dB',
                  status: 'Quiet',
                  icon: Icons.volume_down_outlined,
                  color: AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: EnvironmentCard(
                  title: 'Light Level',
                  value: '< 1 lux',
                  status: 'Dark',
                  icon: Icons.lightbulb_outline,
                  color: AppTheme.successGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepEvents() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sleep Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _buildSleepEvent(
            time: '11:45 PM',
            event: 'Fell Asleep',
            description: '15 minutes after bedtime',
            icon: Icons.bedtime,
            color: AppTheme.sleepDeep,
          ),
          _buildSleepEvent(
            time: '2:15 AM',
            event: 'Brief Awakening',
            description: '3 minutes, bathroom visit',
            icon: Icons.visibility_off,
            color: AppTheme.sleepAwake,
          ),
          _buildSleepEvent(
            time: '4:30 AM',
            event: 'Deep Sleep Peak',
            description: 'Longest deep sleep cycle',
            icon: Icons.trending_up,
            color: AppTheme.successGreen,
          ),
          _buildSleepEvent(
            time: '6:45 AM',
            event: 'Natural Wake',
            description: 'Woke up naturally',
            icon: Icons.wb_sunny,
            color: AppTheme.warningOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildSleepEvent({
    required String time,
    required String event,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryMetrics() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.successGreen.withOpacity(0.1),
            AppTheme.successGreen.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.successGreen.withOpacity(0.2),
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
                  color: AppTheme.successGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  color: AppTheme.successGreen,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recovery Score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'How well your body recovered',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                '87%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildRecoveryItem(
                  'HRV',
                  '42ms',
                  '+5ms vs avg',
                  true,
                ),
              ),
              Expanded(
                child: _buildRecoveryItem(
                  'Resting HR',
                  '58 bpm',
                  '-2 bpm vs avg',
                  true,
                ),
              ),
              Expanded(
                child: _buildRecoveryItem(
                  'Temperature',
                  '98.1°F',
                  'Normal range',
                  null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryItem(String label, String value, String change, bool? isPositive) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          change,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isPositive == null
                ? AppTheme.textTertiary
                : isPositive
                    ? AppTheme.successGreen
                    : AppTheme.warningOrange,
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personalized Recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _buildRecommendation(
            'Increase REM Sleep',
            'Try going to bed 15 minutes earlier to boost REM sleep duration',
            Icons.bedtime,
            AppTheme.sleepRem,
            'High Impact',
          ),
          _buildRecommendation(
            'Maintain Consistency',
            'Your sleep timing is excellent. Keep this routine for optimal recovery',
            Icons.schedule,
            AppTheme.successGreen,
            'Keep It Up',
          ),
          _buildRecommendation(
            'Room Temperature',
            'Your sleep environment is perfect. Temperature and humidity are ideal',
            Icons.thermostat,
            AppTheme.primaryBlue,
            'Optimized',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(
    String title,
    String description,
    IconData icon,
    Color color,
    String priority,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        priority,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSleepDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Last Night\'s Sleep';
    } else if (difference == 1) {
      return 'Yesterday\'s Sleep';
    } else {
      return 'Sleep from ${difference} days ago';
    }
  }

  void _showShareOptions() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Sleep Analysis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: AppTheme.primaryBlue),
              title: const Text('Export as PDF'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppTheme.primaryBlue),
              title: const Text('Share Summary'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: AppTheme.primaryBlue),
              title: const Text('Email to Doctor'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
