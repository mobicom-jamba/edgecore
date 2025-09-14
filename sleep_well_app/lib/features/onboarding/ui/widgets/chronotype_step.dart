import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/buttons.dart';
import '../../data/providers/onboarding_providers.dart';
import '../../data/models/chronotype.dart';

class ChronotypeStep extends HookConsumerWidget {
  const ChronotypeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quiz = ref.watch(chronotypeQuizProvider);
    final answers = ref.watch(quizAnswersProvider);
    final currentQuestionIndex = ref.watch(currentQuestionIndexProvider);
    final canProceed = ref.watch(canProceedProvider);

    final currentQuestion = quiz.questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == quiz.questions.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator
        Row(
          children: [
            Text(
              'Question ${currentQuestionIndex + 1} of ${quiz.questions.length}',
              style: AppTheme.caption,
            ),
            const Spacer(),
            Text(
              '${((currentQuestionIndex + 1) / quiz.questions.length * 100).round()}%',
              style: AppTheme.caption.copyWith(
                color: AppTheme.accentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing8),
        LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / quiz.questions.length,
          backgroundColor: AppTheme.divider,
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppTheme.accentPrimary),
        ),

        const SizedBox(height: AppTheme.spacing32),

        // Question
        Text(
          currentQuestion.question,
          style: AppTheme.h1,
        ),

        const SizedBox(height: AppTheme.spacing24),

        // Answer options
        Column(
          children: currentQuestion.options.map((option) {
            final isSelected = answers[currentQuestion.id] == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
              child: GestureDetector(
                onTap: () => _selectAnswer(ref, currentQuestion.id, option),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppTheme.spacing16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentPrimary.withOpacity(0.1)
                        : AppTheme.surface,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentPrimary
                          : AppTheme.divider,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? AppTheme.accentPrimary
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: AppTheme.spacing12),
                      Expanded(
                        child: Text(
                          option.text,
                          style: AppTheme.body.copyWith(
                            color: isSelected
                                ? AppTheme.accentPrimary
                                : AppTheme.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const Spacer(),

        // Navigation buttons
        Row(
          children: [
            if (currentQuestionIndex > 0) ...[
              Expanded(
                child: SecondaryButton(
                  text: 'Previous',
                  onPressed: () =>
                      ref.read(currentQuestionIndexProvider.notifier).state--,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
            ],
            Expanded(
              child: PrimaryButton(
                text: isLastQuestion ? 'Get Results' : 'Next',
                onPressed: answers.containsKey(currentQuestion.id)
                    ? () => _handleNext(ref, isLastQuestion)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _selectAnswer(WidgetRef ref, int questionId, ChronotypeOption option) {
    ref.read(quizAnswersProvider.notifier).state = {
      ...ref.read(quizAnswersProvider),
      questionId: option,
    };
  }

  void _handleNext(WidgetRef ref, bool isLastQuestion) {
    if (isLastQuestion) {
      _calculateAndSaveChronotype(ref);
    } else {
      ref.read(currentQuestionIndexProvider.notifier).state++;
    }
  }

  void _calculateAndSaveChronotype(WidgetRef ref) {
    final answers = ref.read(quizAnswersProvider);
    final result = calculateChronotypeResult(answers);

    ref.read(onboardingStateProvider.notifier).setChronotype(result.chronotype);
    ref.read(onboardingStateProvider.notifier).nextStep();
  }
}

// Provider for current question index
final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);
