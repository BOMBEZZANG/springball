import 'package:flutter/foundation.dart';
import '../config/level_config.dart';
import '../../models/level_data.dart';

/// Singleton LevelManager for centralized level management
class LevelManager {
  static LevelManager? _instance;

  factory LevelManager() {
    _instance ??= LevelManager._internal();
    return _instance!;
  }

  LevelManager._internal() {
    _initialize();
  }

  int _currentLevel = 1;
  LevelData? _currentLevelData;
  final List<LevelData> _allLevels = LevelConfig.getAllLevels();
  bool _initialized = false;

  // Getters
  int get currentLevel => _currentLevel;
  LevelData? get currentLevelData => _currentLevelData;
  List<LevelData> get allLevels => _allLevels;
  int get totalPredefinedLevels => _allLevels.length;
  bool get isInitialized => _initialized;

  void _initialize() {
    if (_initialized) return;

    debugPrint(
        'LevelManager initialized with ${_allLevels.length} predefined levels');
    loadLevel(1); // Load first level by default
    _initialized = true;
  }

  /// Load a specific level
  void loadLevel(int levelId) {
    if (levelId < 1) {
      debugPrint('Invalid level ID: $levelId');
      return;
    }

    _currentLevel = levelId;
    _currentLevelData = LevelConfig.getLevel(levelId);

    debugPrint('Loaded level $_currentLevel');
    if (isCustomLevel(levelId)) {
      debugPrint('  -> Custom generated level');
    }
  }

  /// Advance to the next level
  void nextLevel() {
    loadLevel(_currentLevel + 1);
  }

  /// Go to the previous level (if available)
  void previousLevel() {
    if (_currentLevel > 1) {
      loadLevel(_currentLevel - 1);
    } else {
      debugPrint('Already at the first level');
    }
  }

  /// Reset to the first level
  void resetToFirstLevel() {
    loadLevel(1);
  }

  /// Jump to a specific level (with validation)
  bool jumpToLevel(int targetLevel) {
    if (targetLevel < 1) {
      debugPrint('Cannot jump to level $targetLevel: Invalid level number');
      return false;
    }

    // For custom levels, we don't restrict access
    loadLevel(targetLevel);
    return true;
  }

  /// Check if there's a next level available
  bool hasNextLevel() {
    // Always true since we support infinite generated levels
    return true;
  }

  /// Check if there's a previous level available
  bool hasPreviousLevel() {
    return _currentLevel > 1;
  }

  /// Check if a level is a custom generated level
  bool isCustomLevel(int levelId) {
    return levelId > _allLevels.length;
  }

  /// Check if a level is predefined
  bool isPredefinedLevel(int levelId) {
    return levelId > 0 && levelId <= _allLevels.length;
  }

  /// Get level difficulty rating (1-5 stars)
  int getLevelDifficulty(int levelId) {
    if (levelId <= 2) return 1; // Tutorial levels
    if (levelId <= 5) return 2; // Basic levels
    if (levelId <= 8) return 3; // Intermediate levels
    if (levelId <= 12) return 4; // Advanced levels

    // Custom levels: increase difficulty gradually
    final customLevelIndex = levelId - _allLevels.length;
    return (3 + (customLevelIndex ~/ 5)).clamp(3, 5);
  }

  /// Get estimated completion time for a level (in seconds)
  int getEstimatedCompletionTime(int levelId) {
    final difficulty = getLevelDifficulty(levelId);
    const baseTime = 30; // 30 seconds base time
    return baseTime + (difficulty * 15); // +15 seconds per difficulty level
  }

  /// Get level statistics
  LevelStats getLevelStats(int levelId) {
    final levelData = levelId == _currentLevel
        ? _currentLevelData
        : LevelConfig.getLevel(levelId);

    return LevelStats(
      levelId: levelId,
      obstacleCount: levelData?.obstacles.length ?? 0,
      par: levelData?.par ?? (3 + (levelId ~/ 2)),
      difficulty: getLevelDifficulty(levelId),
      estimatedTime: getEstimatedCompletionTime(levelId),
      isCustom: isCustomLevel(levelId),
    );
  }

  /// Validate level data integrity
  bool validateCurrentLevel() {
    if (_currentLevelData == null) return false;

    // Check if goal position is valid
    final goal = _currentLevelData!.goal;
    if (goal.dx < 0 || goal.dy < 0) return false;

    // Check if ball start position is valid
    final ballStart = _currentLevelData!.ballStart;
    if (ballStart.dx < 0 || ballStart.dy < 0) return false;

    // Check if obstacles have valid positions
    for (final obstacle in _currentLevelData!.obstacles) {
      if (obstacle.position.dx < 0 || obstacle.position.dy < 0) return false;
      if (obstacle.size.width <= 0 || obstacle.size.height <= 0) return false;
    }

    return true;
  }

  /// Get all available levels info
  List<LevelStats> getAllLevelsInfo({int maxCustomLevels = 20}) {
    final allStats = <LevelStats>[];

    // Add predefined levels
    for (int i = 1; i <= _allLevels.length; i++) {
      allStats.add(getLevelStats(i));
    }

    // Add some custom levels for preview
    for (int i = _allLevels.length + 1;
        i <= _allLevels.length + maxCustomLevels;
        i++) {
      allStats.add(getLevelStats(i));
    }

    return allStats;
  }

  /// Cleanup resources
  void dispose() {
    debugPrint('LevelManager disposed');
  }
}

/// Data class for level statistics
class LevelStats {
  final int levelId;
  final int obstacleCount;
  final int par;
  final int difficulty;
  final int estimatedTime;
  final bool isCustom;

  const LevelStats({
    required this.levelId,
    required this.obstacleCount,
    required this.par,
    required this.difficulty,
    required this.estimatedTime,
    required this.isCustom,
  });

  @override
  String toString() {
    return 'Level $levelId: $obstacleCount obstacles, par $par, '
        '$difficulty stars, ~${estimatedTime}s ${isCustom ? '(Custom)' : ''}';
  }
}
