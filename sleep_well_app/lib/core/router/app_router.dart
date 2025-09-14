import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/home/ui/home_screen.dart';
import '../../features/onboarding/ui/onboarding_screen.dart';
import '../../features/wind_down/ui/wind_down_screen.dart';
import '../../features/morning_checkin/ui/morning_checkin_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import '../../features/settings/ui/privacy_screen.dart';
import '../../features/settings/ui/ios_shortcut_guide_screen.dart';
import '../../main.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final initialRoute = ref.watch(initialRouteProvider).when(
    data: (route) => route,
    loading: () => '/onboarding', // Default to onboarding while loading
    error: (_, __) => '/onboarding', // Default to onboarding on error
  );
  
  return GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/wind-down',
        name: 'wind-down',
        builder: (context, state) => const WindDownScreen(),
      ),
      GoRoute(
        path: '/morning-checkin',
        name: 'morning-checkin',
        builder: (context, state) => const MorningCheckinScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: '/privacy',
            name: 'privacy',
            builder: (context, state) => const PrivacyScreen(),
          ),
          GoRoute(
            path: '/ios-shortcut-guide',
            name: 'ios-shortcut-guide',
            builder: (context, state) => const IosShortcutGuideScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you\'re looking for doesn\'t exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
