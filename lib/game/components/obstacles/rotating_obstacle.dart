import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:math';
import 'base_obstacle.dart';
import '../../config/game_config.dart';
import '../../../models/level_data.dart';

class RotatingObstacle extends BaseObstacle {
  final double _autoRotationSpeed = GameConfig.rotatingObstacleSpeed;

  RotatingObstacle({required Size size, Vector2? position})
      : super(
          type: ObstacleType.rotating,
          obstacleSize: size,
          rotatable: false, // Auto-rotates, can't be manually rotated
          primaryColor: GameConfig.rotatingObstacleColor,
          initialPosition: position,
        );

  @override
  void updateSpecialBehavior(double dt) {
    // Auto-rotation
    currentAngle += _autoRotationSpeed;
    if (currentAngle > 2 * pi) {
      currentAngle -= 2 * pi;
    }
    body.setTransform(body.position, currentAngle);
  }

  @override
  void renderIcon(Canvas canvas) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🌀',
        style: TextStyle(fontSize: 16),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        -textPainter.width / 2,
        -textPainter.height / 2,
      ),
    );
  }
}
