class LevelScore {
  final int score;
  final int attempts;
  final bool completed;

  const LevelScore({
    required this.score,
    required this.attempts,
    required this.completed,
  });

  factory LevelScore.fromJson(Map<String, dynamic> json) {
    return LevelScore(
      score: json['score'],
      attempts: json['attempts'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'attempts': attempts,
      'completed': completed,
    };
  }
}

class GameProgress {
  final int currentLevel;
  final int highestLevel;
  final int totalScore;
  final Map<int, LevelScore> levelScores;
  final bool soundEnabled;
  final bool hapticEnabled;

  const GameProgress({
    required this.currentLevel,
    required this.highestLevel,
    required this.totalScore,
    required this.levelScores,
    this.soundEnabled = true,
    this.hapticEnabled = true,
  });

  factory GameProgress.initial() {
    return const GameProgress(
      currentLevel: 1,
      highestLevel: 1,
      totalScore: 0,
      levelScores: {},
    );
  }

  factory GameProgress.fromJson(Map<String, dynamic> json) {
    final levelScoresJson = json['levelScores'] as Map<String, dynamic>;
    final levelScores = <int, LevelScore>{};
    
    for (final entry in levelScoresJson.entries) {
      levelScores[int.parse(entry.key)] = LevelScore.fromJson(entry.value);
    }

    return GameProgress(
      currentLevel: json['currentLevel'],
      highestLevel: json['highestLevel'],
      totalScore: json['totalScore'],
      levelScores: levelScores,
      soundEnabled: json['settings']?['soundEnabled'] ?? true,
      hapticEnabled: json['settings']?['hapticEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final levelScoresJson = <String, dynamic>{};
    for (final entry in levelScores.entries) {
      levelScoresJson[entry.key.toString()] = entry.value.toJson();
    }

    return {
      'currentLevel': currentLevel,
      'highestLevel': highestLevel,
      'totalScore': totalScore,
      'levelScores': levelScoresJson,
      'settings': {
        'soundEnabled': soundEnabled,
        'hapticEnabled': hapticEnabled,
      },
    };
  }

  GameProgress copyWith({
    int? currentLevel,
    int? highestLevel,
    int? totalScore,
    Map<int, LevelScore>? levelScores,
    bool? soundEnabled,
    bool? hapticEnabled,
  }) {
    return GameProgress(
      currentLevel: currentLevel ?? this.currentLevel,
      highestLevel: highestLevel ?? this.highestLevel,
      totalScore: totalScore ?? this.totalScore,
      levelScores: levelScores ?? this.levelScores,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }
}