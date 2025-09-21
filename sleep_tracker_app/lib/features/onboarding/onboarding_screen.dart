import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/custom_card.dart';
import '../../shared/widgets/custom_button.dart';

class OnboardingScreen extends HookWidget {
  final VoidCallback? onComplete;
  
  const OnboardingScreen({super.key, this.onComplete});

  @override
  Widget build(BuildContext context) {
    final currentStep = useState(0);
    final selectedGoal = useState<int?>(null);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Skip onboarding
              onComplete?.call();
            },
            child: Text(
              'Skip for now',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          children: [
            _buildProgressIndicator(currentStep.value),
            const SizedBox(height: AppTheme.spacing40),
            Expanded(
              child: _buildStepContent(currentStep.value, selectedGoal),
            ),
            const SizedBox(height: AppTheme.spacing32),
            _buildNavigationButtons(currentStep, selectedGoal),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: index <= currentStep 
                ? AppTheme.primaryBlue 
                : AppTheme.textTertiary,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildStepContent(int currentStep, ValueNotifier<int?> selectedGoal) {
    switch (currentStep) {
      case 0:
        return _buildWelcomeStep();
      case 1:
        return _buildSleepGoalStep(selectedGoal);
      case 2:
        return _buildBedtimeStep();
      case 3:
        return _buildCompleteStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildWelcomeStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.nightlight_round,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        Text(
          'Welcome to Sleepy',
          style: AppTheme.heading1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacing16),
        Text(
          'Your personal sleep optimization companion',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSleepGoalStep(ValueNotifier<int?> selectedGoal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your sleep goal?',
          style: AppTheme.heading2,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'We\'ll tailor your experience to help you achieve your goal.',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        Expanded(
          child: ListView.builder(
            itemCount: AppConstants.sleepGoals.length,
            itemBuilder: (context, index) {
              final goal = AppConstants.sleepGoals[index];
              final isSelected = selectedGoal.value == index;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
                child: CustomCard(
                  onTap: () => selectedGoal.value = index,
                  backgroundColor: isSelected 
                      ? AppTheme.primaryBlue.withOpacity(0.1)
                      : AppTheme.cardBackground,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          goal,
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: isSelected 
                                ? FontWeight.w600 
                                : FontWeight.normal,
                            color: isSelected 
                                ? AppTheme.primaryBlue 
                                : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryBlue,
                        )
                      else
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppTheme.textTertiary,
                          size: 16,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBedtimeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set your bedtime',
          style: AppTheme.heading2,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          'We\'ll help you maintain a consistent sleep schedule.',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '22:30',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacing24),
                Text(
                  'Recommended bedtime',
                  style: AppTheme.bodyLarge,
                ),
                const SizedBox(height: AppTheme.spacing8),
                Text(
                  'Based on your sleep goal',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 60,
            color: AppTheme.successGreen,
          ),
        ),
        const SizedBox(height: AppTheme.spacing32),
        Text(
          'All set!',
          style: AppTheme.heading1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacing16),
        Text(
          'You\'re ready to start your sleep optimization journey.',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(
    ValueNotifier<int> currentStep, 
    ValueNotifier<int?> selectedGoal,
  ) {
    return Column(
      children: [
        PrimaryButton(
          text: currentStep.value == 3 ? 'Get Started' : 'Next',
          onPressed: () {
            if (currentStep.value == 1 && selectedGoal.value == null) {
              // Show error or validation
              return;
            }
            
            if (currentStep.value < 3) {
              currentStep.value++;
            } else {
              // Complete onboarding
              onComplete?.call();
            }
          },
        ),
        if (currentStep.value > 0) ...[
          const SizedBox(height: AppTheme.spacing12),
          TextButton(
            onPressed: () {
              currentStep.value--;
            },
            child: Text(
              'Back',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
