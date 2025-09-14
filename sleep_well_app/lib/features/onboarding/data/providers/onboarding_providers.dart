import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/database/database.dart';
import '../models/onboarding_step.dart';
import '../models/chronotype.dart';
import '../models/ritual.dart';

// Onboarding state provider
final onboardingStateProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});

// Individual step providers for easy access
final currentStepProvider = Provider<OnboardingStep>((ref) {
  return ref.watch(onboardingStateProvider).currentStep;
});

final bedtimeProvider = Provider<TimeOfDay?>((ref) {
  return ref.watch(onboardingStateProvider).bedtime;
});

final wakeTimeProvider = Provider<TimeOfDay?>((ref) {
  return ref.watch(onboardingStateProvider).wakeTime;
});

final chronotypeProvider = Provider<Chronotype?>((ref) {
  return ref.watch(onboardingStateProvider).chronotype;
});

final ritualsProvider = Provider<OnboardingRituals?>((ref) {
  return ref.watch(onboardingStateProvider).rituals;
});

final canProceedProvider = Provider<bool>((ref) {
  return ref.watch(onboardingStateProvider).canProceed;
});

// Chronotype quiz provider
final chronotypeQuizProvider = Provider<ChronotypeQuiz>((ref) {
  return ChronotypeQuiz.defaultQuiz;
});

// Quiz answers provider
final quizAnswersProvider = StateProvider<Map<int, ChronotypeOption>>((ref) {
  return {};
});

// Ritual selection provider
final selectedRitualsProvider = StateProvider<List<Ritual>>((ref) {
  return OnboardingRituals.defaultRituals;
});

// Buddy provider
final buddyProvider = StateProvider<SleepBuddy?>((ref) {
  return null;
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;
  
  OnboardingNotifier(this._ref) : super(const OnboardingState());
  
  void setSchedule(TimeOfDay bedtime, TimeOfDay wakeTime) {
    state = state.copyWith(
      bedtime: bedtime,
      wakeTime: wakeTime,
    );
  }
  
  void setChronotype(Chronotype chronotype) {
    state = state.copyWith(chronotype: chronotype);
  }
  
  void setRituals(OnboardingRituals rituals) {
    state = state.copyWith(rituals: rituals);
  }
  
  void nextStep() {
    final next = state.nextStep;
    if (next != null) {
      state = state.copyWith(currentStep: next);
    }
  }
  
  void previousStep() {
    final previous = state.previousStep;
    if (previous != null) {
      state = state.copyWith(currentStep: previous);
    }
  }
  
  void goToStep(OnboardingStep step) {
    state = state.copyWith(currentStep: step);
  }
  
  Future<void> completeOnboarding() async {
    if (!state.canProceed) return;
    
    try {
      // Save to database
      final prefs = await SharedPreferences.getInstance();
      
      // Save schedule
      if (state.bedtime != null && state.wakeTime != null) {
        await DatabaseService.saveUserPrefs(
          bedtime: state.bedtime!,
          wakeTime: state.wakeTime!,
        );
      }
      
      // Save chronotype
      if (state.chronotype != null) {
        await DatabaseService.saveChronotype(state.chronotype!);
      }
      
      // Save rituals
      if (state.rituals != null) {
        await DatabaseService.saveRituals(state.rituals!.selectedRituals);
        
        // Save buddy if provided
        if (state.rituals!.buddy != null) {
          await DatabaseService.saveSleepBuddy(state.rituals!.buddy!);
        }
      }
      
      // Mark onboarding as completed
      await prefs.setBool('onboarding_completed', true);
      
      state = state.copyWith(isCompleted: true);
    } catch (e) {
      // Handle error - could emit error state
      rethrow;
    }
  }
  
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }
  
  void reset() {
    state = const OnboardingState();
  }
}

// Helper function to calculate chronotype from quiz answers
ChronotypeResult calculateChronotypeResult(Map<int, ChronotypeOption> answers) {
  final Map<Chronotype, int> scores = {};
  
  for (final answer in answers.values) {
    scores[answer.chronotype] = (scores[answer.chronotype] ?? 0) + answer.score;
  }
  
  return ChronotypeResult.calculateResult(scores);
}