import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'config/game_config.dart';
import 'systems/level_manager.dart';
import 'systems/audio_manager.dart';
import 'systems/input_system.dart';
import 'systems/physics_contact_listener.dart';
import 'components/ball.dart';
import 'components/goal.dart';
import 'components/obstacles/base_obstacle.dart';
import 'components/obstacles/normal_obstacle.dart';
import 'components/obstacles/static_obstacle.dart';
import 'components/obstacles/rotating_obstacle.dart';
import 'components/obstacles/magnet_obstacle.dart';
import 'components/obstacles/trampoline_obstacle.dart';
import 'components/obstacles/ice_obstacle.dart';
import 'components/obstacles/lava_obstacle.dart';
import 'managers/game_state_manager.dart';
import '../models/level_data.dart';

class PhysicsBallGame extends Forge2DGame with TapCallbacks {
  // Core systems
  late GameStateManager gameStateManager;
  late LevelManager levelManager;
  late AudioManager audioManager;
  late InputSystem inputSystem;
  late PhysicsContactListener contactListener;

  // Game components
  late Ball ball;
  late Goal goal;
  final List<BaseObstacle> obstacles = [];

  // Game state
  bool ballDropped = false;
  bool levelCompleted = false;

  PhysicsBallGame() : super(gravity: Vector2(0, 10)) {
    // Initialize singleton systems
    levelManager = LevelManager();
    audioManager = AudioManager();
    inputSystem = InputSystem(this);
    contactListener = PhysicsContactListener();
  }

  @override
  Color backgroundColor() => GameConfig.backgroundStart;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set up physics world - Contact listener setup may not be needed for basic functionality

    // Set up camera - remove camera setup if causing issues
    // camera.viewfinder.visibleGameSize = Vector2(GameConfig.gameWidth.toDouble(), GameConfig.gameHeight.toDouble());

    // Load initial level
    loadCurrentLevel();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Check win condition
    if (ballDropped && !levelCompleted && ball.isActive) {
      if (goal.isBallInGoal(ball.worldPosition)) {
        onLevelCompleted();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Render enhanced background
    _renderBackground(canvas);

    // Render grid pattern
    _renderGrid(canvas);

    super.render(canvas);
  }

  void _renderBackground(Canvas canvas) {
    const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [GameConfig.backgroundStart, GameConfig.backgroundEnd],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        const Rect.fromLTWH(0, 0, GameConfig.gameWidth, GameConfig.gameHeight),
      );

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, GameConfig.gameWidth, GameConfig.gameHeight),
      paint,
    );
  }

  void _renderGrid(Canvas canvas) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    // Vertical lines
    for (double i = 0; i < GameConfig.gameWidth; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, GameConfig.gameHeight),
        gridPaint,
      );
    }

    // Horizontal lines
    for (double i = 0; i < GameConfig.gameHeight; i += 40) {
      canvas.drawLine(
        Offset(0, i),
        Offset(GameConfig.gameWidth, i),
        gridPaint,
      );
    }
  }

  /// Load the current level from LevelManager
  void loadCurrentLevel() {
    final levelData = levelManager.currentLevelData;
    if (levelData == null) return;

    _clearLevel();
    ballDropped = false;
    levelCompleted = false;

    // Create goal
    goal = Goal(initialPosition: Vector2(levelData.goal.dx, levelData.goal.dy));
    add(goal);

    // Create obstacles
    for (final obstacleData in levelData.obstacles) {
      final obstacle = _createObstacle(obstacleData);
      obstacles.add(obstacle);
      add(obstacle);
    }

    // Create ball
    ball = Ball(
        initialPosition:
            Vector2(levelData.ballStart.dx, levelData.ballStart.dy));
    add(ball);
  }

  BaseObstacle _createObstacle(ObstacleData data) {
    final position = Vector2(data.position.dx, data.position.dy);
    final size = data.size;

    switch (data.type) {
      case ObstacleType.normal:
        return NormalObstacle(size: size, position: position);
      case ObstacleType.static:
        return StaticObstacle(size: size, position: position);
      case ObstacleType.rotating:
        return RotatingObstacle(size: size, position: position);
      case ObstacleType.magnet:
        return MagnetObstacle(size: size, position: position);
      case ObstacleType.trampoline:
        return TrampolineObstacle(size: size, position: position);
      case ObstacleType.ice:
        return IceObstacle(size: size, position: position);
      case ObstacleType.lava:
        return LavaObstacle(size: size, position: position);
    }
  }

  void _clearLevel() {
    // Remove all game components
    removeWhere((component) =>
        component is Ball || component is Goal || component is BaseObstacle);

    obstacles.clear();
  }

  /// Handle ball drop through InputSystem
  void onBallDropped() {
    if (!ballDropped && ball.isActive) {
      ballDropped = true;
      gameStateManager.incrementAttempts();
      ball.drop(); // This handles audio and haptic feedback
    }
  }

  /// Handle level completion
  void onLevelCompleted() {
    if (!levelCompleted) {
      levelCompleted = true;
      goal.onGoalReached(); // Handles audio and haptic feedback

      final levelStats = levelManager.getLevelStats(levelManager.currentLevel);
      final score = gameStateManager.calculateLevelScore(
        levelStats.par,
        gameStateManager.currentAttempts,
      );

      gameStateManager.completeLevel(levelManager.currentLevel, score);
    }
  }

  /// Reset current level
  void resetCurrentLevel() {
    ballDropped = false;
    levelCompleted = false;
    final ballStart = levelManager.currentLevelData?.ballStart;
    ball.reset(ballStart != null
        ? Vector2(ballStart.dx, ballStart.dy)
        : Vector2(200, 50));
    goal.reset();

    // Reset all obstacles
    for (final obstacle in obstacles) {
      obstacle.pulseEffect = 0;
    }
  }

  /// Advance to next level
  void nextLevel() {
    levelManager.nextLevel();
    loadCurrentLevel();
  }

  /// Handle input through InputSystem
  @override
  bool onTapDown(TapDownEvent event) {
    return inputSystem.handleTapDown(event);
  }

  // Getters for external access
  List<BaseObstacle> get allObstacles => obstacles;
  int get currentLevelNumber => levelManager.currentLevel;
  bool get isBallDropped => ballDropped;
  bool get isLevelCompleted => levelCompleted;
}
