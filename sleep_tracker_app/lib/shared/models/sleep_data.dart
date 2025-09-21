class SleepData {
  final String id;
  final DateTime date;
  final Duration totalSleep;
  final Duration timeToFallAsleep;
  final int sleepQuality; // 0-100
  final List<SleepStage> stages;
  final bool inBedOnTime;
  final int energyLevel; // 1-5
  final int moodLevel; // 1-5

  const SleepData({
    required this.id,
    required this.date,
    required this.totalSleep,
    required this.timeToFallAsleep,
    required this.sleepQuality,
    required this.stages,
    required this.inBedOnTime,
    required this.energyLevel,
    required this.moodLevel,
  });

  factory SleepData.fromJson(Map<String, dynamic> json) {
    return SleepData(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      totalSleep: Duration(minutes: json['totalSleep'] as int),
      timeToFallAsleep: Duration(minutes: json['timeToFallAsleep'] as int),
      sleepQuality: json['sleepQuality'] as int,
      stages: (json['stages'] as List)
          .map((stage) => SleepStage.fromJson(stage as Map<String, dynamic>))
          .toList(),
      inBedOnTime: json['inBedOnTime'] as bool,
      energyLevel: json['energyLevel'] as int,
      moodLevel: json['moodLevel'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'totalSleep': totalSleep.inMinutes,
      'timeToFallAsleep': timeToFallAsleep.inMinutes,
      'sleepQuality': sleepQuality,
      'stages': stages.map((stage) => stage.toJson()).toList(),
      'inBedOnTime': inBedOnTime,
      'energyLevel': energyLevel,
      'moodLevel': moodLevel,
    };
  }
}

class SleepStage {
  final String type;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;

  const SleepStage({
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory SleepStage.fromJson(Map<String, dynamic> json) {
    return SleepStage(
      type: json['type'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      duration: Duration(minutes: json['duration'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'duration': duration.inMinutes,
    };
  }
}

class SleepInsight {
  final String title;
  final String description;
  final String icon;
  final String actionText;
  final String? actionUrl;

  const SleepInsight({
    required this.title,
    required this.description,
    required this.icon,
    required this.actionText,
    this.actionUrl,
  });
}

class Soundscape {
  final String id;
  final String title;
  final String duration;
  final double rating;
  final String category;
  final String image;
  final bool isFavorite;
  final bool isPlaying;

  const Soundscape({
    required this.id,
    required this.title,
    required this.duration,
    required this.rating,
    required this.category,
    required this.image,
    this.isFavorite = false,
    this.isPlaying = false,
  });

  Soundscape copyWith({
    String? id,
    String? title,
    String? duration,
    double? rating,
    String? category,
    String? image,
    bool? isFavorite,
    bool? isPlaying,
  }) {
    return Soundscape(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      image: image ?? this.image,
      isFavorite: isFavorite ?? this.isFavorite,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
