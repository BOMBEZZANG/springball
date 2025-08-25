import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/game_progress.dart';

enum GameState {
  menu,
  playing,
  paused,
  levelComplete,
  gameOver,
  settings,
}

class GameStateManager extends ChangeNotifier {
  GameProgress _progress = GameProgress.initial();
  GameState _currentState = GameState.menu;
  int _currentAttempts = 0;
  bool _isLoading = false;

  GameProgress get progress => _progress;
  GameState get currentState => _currentState;
  int get currentAttempts => _currentAttempts;
  bool get isLoading => _isLoading;

  GameStateManager() {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('game_progress');
      
      if (progressJson != null) {
        final progressMap = json.decode(progressJson) as Map<String, dynamic>;
        _progress = GameProgress.fromJson(progressMap);
      }
    } catch (e) {
      debugPrint('Error loading progress: $e');
      _progress = GameProgress.initial();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = json.encode(_progress.toJson());
      await prefs.setString('game_progress', progressJson);
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  void setState(GameState newState) {
    _currentState = newState;
    notifyListeners();
  }

  void startLevel(int levelId) {
    _currentAttempts = 0;
    _progress = _progress.copyWith(currentLevel: levelId);
    setState(GameState.playing);
    _saveProgress();
  }

  void incrementAttempts() {
    _currentAttempts++;
    notifyListeners();
  }

  void completeLevel(int levelId, int score) {
    final levelScore = LevelScore(
      score: score,
      attempts: _currentAttempts,
      completed: true,
    );

    final updatedLevelScores = Map<int, LevelScore>.from(_progress.levelScores);
    updatedLevelScores[levelId] = levelScore;

    final newTotalScore = _progress.totalScore + score;
    final newHighestLevel = (_progress.highestLevel < levelId + 1) 
        ? levelId + 1 
        : _progress.highestLevel;

    _progress = _progress.copyWith(
      levelScores: updatedLevelScores,
      totalScore: newTotalScore,
      highestLevel: newHighestLevel,
      currentLevel: levelId + 1,
    );

    setState(GameState.levelComplete);
    _saveProgress();
  }

  void nextLevel() {
    if (_progress.currentLevel <= _progress.highestLevel) {
      startLevel(_progress.currentLevel);
    } else {
      setState(GameState.menu);
    }
  }

  void restartLevel() {
    _currentAttempts = 0;
    setState(GameState.playing);
    notifyListeners();
  }

  void goToMenu() {
    setState(GameState.menu);
  }

  void pauseGame() {
    if (_currentState == GameState.playing) {
      setState(GameState.paused);
    }
  }

  void resumeGame() {
    if (_currentState == GameState.paused) {
      setState(GameState.playing);
    }
  }

  void resetProgress() {
    _progress = GameProgress.initial();
    _currentAttempts = 0;
    setState(GameState.menu);
    _saveProgress();
  }

  void updateSettings({bool? soundEnabled, bool? hapticEnabled}) {
    _progress = _progress.copyWith(
      soundEnabled: soundEnabled,
      hapticEnabled: hapticEnabled,
    );
    _saveProgress();
    notifyListeners();
  }

  bool isLevelUnlocked(int levelId) {
    return levelId <= _progress.highestLevel;
  }

  LevelScore? getLevelScore(int levelId) {
    return _progress.levelScores[levelId];
  }

  int calculateLevelScore(int par, int attempts) {
    if (attempts <= par) {
      return 100 + (par - attempts) * 20;
    } else {
      return (100 - (attempts - par) * 10).clamp(10, 100);
    }
  }
}