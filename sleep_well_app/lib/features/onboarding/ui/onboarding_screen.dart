import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/providers/onboarding_providers.dart';
import '../data/models/onboarding_step.dart';
import 'widgets/schedule_step.dart';
import 'widgets/chronotype_step.dart';
import 'widgets/rituals_step.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingStateProvider);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Welcome to Well Sleep',
                      style: AppTheme.h1,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/home'),
                    child: Text(
                      'Skip',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacing8),
              
              Text(
                'Let\'s set up your sleep routine in just 60 seconds',
                style: AppTheme.body,
              ),
              
              const SizedBox(height: AppTheme.spacing32),
              
              // Progress indicator
              Row(
                children: [
                  _buildProgressStep(1, 'Schedule', onboardingState.currentStep == OnboardingStep.schedule),
                  _buildProgressLine(),
                  _buildProgressStep(2, 'Chronotype', onboardingState.currentStep == OnboardingStep.chronotype),
                  _buildProgressLine(),
                  _buildProgressStep(3, 'Rituals', onboardingState.currentStep == OnboardingStep.rituals),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacing32),
              
              // Step content
              Expanded(
                child: _buildStepContent(context, ref, onboardingState),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProgressStep(int stepNumber, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppTheme.accentPrimary : AppTheme.divider,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              stepNumber.toString(),
              style: AppTheme.caption.copyWith(
                color: isActive ? Colors.white : AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppTheme.spacing4),
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: isActive ? AppTheme.accentPrimary : AppTheme.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
  
  Widget _buildProgressLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: AppTheme.divider,
        margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing8),
      ),
    );
  }
  
  Widget _buildStepContent(BuildContext context, WidgetRef ref, OnboardingState state) {
    switch (state.currentStep) {
      case OnboardingStep.schedule:
        return const ScheduleStep();
      case OnboardingStep.chronotype:
        return const ChronotypeStep();
      case OnboardingStep.rituals:
        return const RitualsStep();
    }
  }
}