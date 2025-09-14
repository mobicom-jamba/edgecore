enum Chronotype {
  earlyBird('Early Bird', 'You naturally wake up early and feel most energetic in the morning'),
  nightOwl('Night Owl', 'You prefer staying up late and feel most productive in the evening'),
  balanced('Balanced', 'You adapt well to different schedules and have consistent energy'),
  irregular('Irregular', 'Your sleep patterns vary and you benefit from flexible routines');

  const Chronotype(this.displayName, this.description);
  
  final String displayName;
  final String description;
}

class ChronotypeQuiz {
  final List<ChronotypeQuestion> questions;
  
  const ChronotypeQuiz({
    required this.questions,
  });
  
  static const ChronotypeQuiz defaultQuiz = ChronotypeQuiz(
    questions: [
      ChronotypeQuestion(
        id: 1,
        question: 'What time do you naturally wake up on weekends?',
        options: [
          ChronotypeOption('Before 7 AM', Chronotype.earlyBird, 3),
          ChronotypeOption('7-9 AM', Chronotype.balanced, 2),
          ChronotypeOption('9-11 AM', Chronotype.nightOwl, 1),
          ChronotypeOption('After 11 AM', Chronotype.irregular, 0),
        ],
      ),
      ChronotypeQuestion(
        id: 2,
        question: 'When do you feel most alert and productive?',
        options: [
          ChronotypeOption('Early morning (6-9 AM)', Chronotype.earlyBird, 3),
          ChronotypeOption('Morning (9 AM-12 PM)', Chronotype.balanced, 2),
          ChronotypeOption('Afternoon (12-6 PM)', Chronotype.balanced, 1),
          ChronotypeOption('Evening (6 PM-12 AM)', Chronotype.nightOwl, 3),
        ],
      ),
      ChronotypeQuestion(
        id: 3,
        question: 'How do you feel about early morning meetings?',
        options: [
          ChronotypeOption('Love them, I\'m at my best', Chronotype.earlyBird, 3),
          ChronotypeOption('They\'re fine with coffee', Chronotype.balanced, 2),
          ChronotypeOption('I can manage but prefer later', Chronotype.nightOwl, 1),
          ChronotypeOption('I struggle to function', Chronotype.irregular, 0),
        ],
      ),
      ChronotypeQuestion(
        id: 4,
        question: 'What\'s your ideal bedtime?',
        options: [
          ChronotypeOption('Before 10 PM', Chronotype.earlyBird, 3),
          ChronotypeOption('10 PM - 12 AM', Chronotype.balanced, 2),
          ChronotypeOption('12 AM - 2 AM', Chronotype.nightOwl, 3),
          ChronotypeOption('It varies a lot', Chronotype.irregular, 1),
        ],
      ),
    ],
  );
}

class ChronotypeQuestion {
  final int id;
  final String question;
  final List<ChronotypeOption> options;
  
  const ChronotypeQuestion({
    required this.id,
    required this.question,
    required this.options,
  });
}

class ChronotypeOption {
  final String text;
  final Chronotype chronotype;
  final int score;
  
  const ChronotypeOption(this.text, this.chronotype, this.score);
}

class ChronotypeResult {
  final Chronotype chronotype;
  final int score;
  final String recommendation;
  
  const ChronotypeResult({
    required this.chronotype,
    required this.score,
    required this.recommendation,
  });
  
  static ChronotypeResult calculateResult(Map<Chronotype, int> scores) {
    Chronotype topChronotype = Chronotype.balanced;
    int topScore = 0;
    
    for (final entry in scores.entries) {
      if (entry.value > topScore) {
        topScore = entry.value;
        topChronotype = entry.key;
      }
    }
    
    String recommendation = _getRecommendation(topChronotype);
    
    return ChronotypeResult(
      chronotype: topChronotype,
      score: topScore,
      recommendation: recommendation,
    );
  }
  
  static String _getRecommendation(Chronotype chronotype) {
    switch (chronotype) {
      case Chronotype.earlyBird:
        return 'Try going to bed around 9-10 PM and waking up at 5-6 AM for optimal energy.';
      case Chronotype.nightOwl:
        return 'Aim for bedtime around 11 PM-12 AM and wake up at 7-8 AM. Use bright light in the morning.';
      case Chronotype.balanced:
        return 'Aim for consistent sleep times around 10-11 PM bedtime and 6-7 AM wake time.';
      case Chronotype.irregular:
        return 'Focus on consistent sleep and wake times, even on weekends. Consider light therapy.';
    }
  }
}
