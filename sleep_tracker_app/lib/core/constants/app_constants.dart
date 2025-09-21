class AppConstants {
  // App Info
  static const String appName = 'Sleepy';
  static const String appVersion = '1.0.0';
  
  // Sleep Goals
  static const List<String> sleepGoals = [
    'Fall asleep faster',
    'Sleep through the night',
    'Wake up refreshed',
  ];
  
  // Quick Wins
  static const List<Map<String, String>> quickWins = [
    {
      'title': 'Get some morning light',
      'description': '5-10 min exposure',
      'icon': 'sun',
    },
    {
      'title': 'Avoid caffeine after 2 PM',
      'description': 'Improves sleep quality',
      'icon': 'coffee',
    },
    {
      'title': 'Try a \'Digital Detox\'',
      'description': '30 min before bed',
      'icon': 'phone',
    },
  ];
  
  // Soundscape Categories
  static const List<String> soundscapeCategories = [
    'Meditations',
    'ASMR',
    'Nature Sounds',
    'Binaural Beats',
  ];
  
  // Sample Soundscapes
  static const List<Map<String, dynamic>> sampleSoundscapes = [
    {
      'title': 'Mountain Serenity',
      'duration': '15 min',
      'rating': 4.8,
      'category': 'Nature Sounds',
      'image': 'mountain',
    },
    {
      'title': 'Forest Whispers',
      'duration': '20 min',
      'rating': 4.7,
      'category': 'Nature Sounds',
      'image': 'forest',
    },
    {
      'title': 'Ocean Waves',
      'duration': '25 min',
      'rating': 4.9,
      'category': 'Nature Sounds',
      'image': 'ocean',
    },
    {
      'title': 'Body Scan',
      'duration': '10 min',
      'rating': 4.6,
      'category': 'Meditations',
      'image': 'meditation',
    },
    {
      'title': 'Breathing',
      'duration': '5 min',
      'rating': 4.5,
      'category': 'Meditations',
      'image': 'breathing',
    },
    {
      'title': 'Mindfulness',
      'duration': '12 min',
      'rating': 4.7,
      'category': 'Meditations',
      'image': 'mindfulness',
    },
  ];
  
  // Sleep Stages
  static const List<String> sleepStages = [
    'Awake',
    'Light Sleep',
    'Deep Sleep',
    'REM Sleep',
  ];
  
  // Time Periods
  static const List<String> timePeriods = [
    'Night',
    'Week',
    'Month',
  ];
}
