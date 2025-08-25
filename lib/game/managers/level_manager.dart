import 'package:flutter/foundation.dart';
import '../config/level_config.dart';
import '../../models/level_data.dart';

class LevelManager {
  static final LevelManager _instance = LevelManager._internal();
  factory LevelManager() => _instance;
  LevelManager._internal();

  int _currentLevel = 1;
  LevelData? _currentLevelData;
  final List<LevelData> _allLevels = LevelConfig.getAllLevels();

  int get currentLevel => _currentLevel;
  LevelData? get currentLevelData => _currentLevelData;
  List<LevelData> get allLevels => _allLevels;

  void loadLevel(int levelId) {
    _currentLevel = levelId;
    _currentLevelData = LevelConfig.getLevel(levelId);
    debugPrint('Loaded level $levelId');
  }

  void nextLevel() {
    loadLevel(_currentLevel + 1);
  }

  void previousLevel() {
    if (_currentLevel > 1) {
      loadLevel(_currentLevel - 1);
    }
  }

  void resetToFirstLevel() {
    loadLevel(1);
  }

  bool hasNextLevel() {
    return _currentLevel < _allLevels.length || _currentLevel < 100; // Allow generated levels
  }

  bool hasPreviousLevel() {
    return _currentLevel > 1;
  }

  int getTotalPredefinedLevels() {
    return _allLevels.length;
  }

  bool isCustomLevel(int levelId) {
    return levelId > _allLevels.length;
  }
}