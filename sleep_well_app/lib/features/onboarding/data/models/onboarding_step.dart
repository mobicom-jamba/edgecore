import 'package:flutter/material.dart';
import 'chronotype.dart';
import 'ritual.dart';

enum OnboardingStep {
  schedule('Schedule', 'Set your sleep times', 1),
  chronotype('Chronotype', 'Discover your sleep type', 2),
  rituals('Rituals', 'Choose your wind-down routine', 3);

  const OnboardingStep(this.title, this.subtitle, this.stepNumber);
  
  final String title;
  final String subtitle;
  final int stepNumber;
}

class OnboardingState {
  final OnboardingStep currentStep;
  final TimeOfDay? bedtime;
  final TimeOfDay? wakeTime;
  final Chronotype? chronotype;
  final OnboardingRituals? rituals;
  final bool isCompleted;
  
  const OnboardingState({
    this.currentStep = OnboardingStep.schedule,
    this.bedtime,
    this.wakeTime,
    this.chronotype,
    this.rituals,
    this.isCompleted = false,
  });
  
  OnboardingState copyWith({
    OnboardingStep? currentStep,
    TimeOfDay? bedtime,
    TimeOfDay? wakeTime,
    Chronotype? chronotype,
    OnboardingRituals? rituals,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      bedtime: bedtime ?? this.bedtime,
      wakeTime: wakeTime ?? this.wakeTime,
      chronotype: chronotype ?? this.chronotype,
      rituals: rituals ?? this.rituals,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  
  bool get canProceed {
    switch (currentStep) {
      case OnboardingStep.schedule:
        return bedtime != null && wakeTime != null;
      case OnboardingStep.chronotype:
        return chronotype != null;
      case OnboardingStep.rituals:
        return rituals != null && rituals!.selectedRituals.isNotEmpty;
    }
  }
  
  OnboardingStep? get nextStep {
    switch (currentStep) {
      case OnboardingStep.schedule:
        return OnboardingStep.chronotype;
      case OnboardingStep.chronotype:
        return OnboardingStep.rituals;
      case OnboardingStep.rituals:
        return null; // Completed
    }
  }
  
  OnboardingStep? get previousStep {
    switch (currentStep) {
      case OnboardingStep.schedule:
        return null; // First step
      case OnboardingStep.chronotype:
        return OnboardingStep.schedule;
      case OnboardingStep.rituals:
        return OnboardingStep.chronotype;
    }
  }
}