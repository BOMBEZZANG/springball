import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import '../components/obstacles/base_obstacle.dart';
import '../physics_ball_game.dart';
import 'audio_manager.dart';
import '../managers/game_state_manager.dart';
import 'dart:ui';

/// Dedicated input system for handling all touch and tap events
class InputSystem {
  final PhysicsBallGame game;

  InputSystem(this.game);

  /// Handle tap down events for obstacle rotation and ball dropping
  bool handleTapDown(TapDownEvent event) {
    final localPosition = event.localPosition;
    final offsetPosition = Offset(localPosition.x, localPosition.y);

    // Check if tapping on obstacles first
    if (_handleObstacleTap(offsetPosition)) {
      return true;
    }

    // Check if tapping drop button area (handled by UI)
    return false;
  }

  /// Handle obstacle rotation taps
  bool _handleObstacleTap(Offset tapPosition) {
    // Convert screen coordinates to game world coordinates
    final gamePosition = _screenToGameCoordinates(tapPosition);

    // Check obstacles in reverse order (top to bottom for better UX)
    final obstacles = game.obstacles.reversed.toList();

    for (final obstacle in obstacles) {
      if (obstacle.rotatable && _isPointInObstacle(gamePosition, obstacle)) {
        _rotateObstacle(obstacle);
        return true;
      }
    }

    return false;
  }

  /// Convert screen coordinates to game world coordinates
  Vector2 _screenToGameCoordinates(Offset screenPosition) {
    // Account for camera transformation and scaling
    return Vector2(
        screenPosition.dx, screenPosition.dy); // Convert Offset to Vector2
  }

  /// Check if a point is within an obstacle's tap area
  bool _isPointInObstacle(Vector2 point, BaseObstacle obstacle) {
    final obstaclePosition = obstacle.body.position * 10; // Scale from Box2D
    final distance = (point - obstaclePosition).length;

    // Use a generous tap area based on obstacle size
    final tapRadius = _calculateTapRadius(obstacle);
    return distance <= tapRadius;
  }

  /// Calculate appropriate tap radius based on obstacle size
  double _calculateTapRadius(BaseObstacle obstacle) {
    final baseRadius =
        (obstacle.obstacleSize.width + obstacle.obstacleSize.height) / 4;
    const minTapRadius = 30.0; // Minimum tap area for usability
    const maxTapRadius = 60.0; // Maximum to avoid overlap

    return (baseRadius + 20).clamp(minTapRadius, maxTapRadius);
  }

  /// Rotate an obstacle and provide feedback
  void _rotateObstacle(BaseObstacle obstacle) {
    obstacle.rotate();
    AudioManager().playObstacleRotate();

    // Visual feedback could be added here (e.g., ripple effect)
    _showTapFeedback(obstacle);
  }

  /// Show visual feedback for obstacle tap
  void _showTapFeedback(BaseObstacle obstacle) {
    // Could add particle effect or highlight animation here
    obstacle.onTapped();
  }

  /// Handle ball drop command
  void handleBallDrop() {
    if (!game.ballDropped && game.ball.isActive) {
      game.ball.drop();
      game.onBallDropped();
    }
  }

  /// Handle level reset command
  void handleLevelReset() {
    game.resetCurrentLevel();
    AudioManager().playObstacleRotate(); // Reuse rotate sound for reset
  }

  /// Handle pause/resume commands
  void handlePauseToggle() {
    if (game.gameStateManager.currentState == GameState.playing) {
      game.gameStateManager.pauseGame();
    } else if (game.gameStateManager.currentState == GameState.paused) {
      game.gameStateManager.resumeGame();
    }
  }

  /// Get obstacles under a specific point (for debugging/testing)
  List<BaseObstacle> getObstaclesAtPoint(Offset point) {
    final gamePosition = _screenToGameCoordinates(point);
    return game.obstacles
        .where((obstacle) => _isPointInObstacle(gamePosition, obstacle))
        .toList();
  }

  /// Check if any obstacle is being touched (for UI state)
  bool isAnyObstacleBeingTouched(Offset point) {
    return getObstaclesAtPoint(point).isNotEmpty;
  }

  /// Handle drag for potential future features (if needed in future)
  // bool handlePanUpdate(DragUpdateEvent event) {
  //   // Could implement drag-to-rotate obstacles
  //   return false;
  // }
}
