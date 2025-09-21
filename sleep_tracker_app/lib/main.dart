import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/dashboard/streamlined_dashboard_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/analytics/enhanced_analytics_screen.dart';
import 'features/soundscapes/soundscapes_screen.dart';
import 'features/welcome/welcome_screen.dart';
import 'shared/widgets/custom_bottom_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if user is first time
  final prefs = await SharedPreferences.getInstance();
  final isFirstTime = prefs.getBool('isFirstTime') ?? true;
  final isPremium = prefs.getBool('isPremium') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(
        isFirstTime: isFirstTime,
        isPremium: isPremium,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final bool isPremium;

  const MyApp({
    super.key,
    required this.isFirstTime,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Tracker',
      theme: AppTheme.darkTheme,
      home: isFirstTime
          ? const WelcomeScreen()
          : MainNavigationScreen(isPremium: isPremium),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final bool isPremium;

  const MainNavigationScreen({
    super.key,
    required this.isPremium,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _navigationAnimationController;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _navigationAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize screens based on subscription status
    _screens = [
      const StreamlinedDashboardScreen(),
      widget.isPremium
          ? const SoundscapesScreen()
          : const PlaceholderScreen(title: 'Soundscapes - Premium'),
      widget.isPremium
          ? const EnhancedAnalyticsScreen()
          : const PlaceholderScreen(title: 'Analytics - Premium'),
      const PlaceholderScreen(title: 'Profile'),
    ];

    // Start navigation animation
    Future.delayed(const Duration(milliseconds: 500), () {
      _navigationAnimationController.forward();
    });

    // Mark as not first time
    _saveFirstTimeStatus();
  }

  void _saveFirstTimeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    await prefs.setBool('isPremium', widget.isPremium);
  }

  @override
  void dispose() {
    _navigationAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        animationController: _navigationAnimationController,
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.darkBackground,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: AppTheme.textTertiary,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              '$title Screen',
              style: AppTheme.heading2,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              'Coming soon...',
              style: AppTheme.bodyLarge.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
