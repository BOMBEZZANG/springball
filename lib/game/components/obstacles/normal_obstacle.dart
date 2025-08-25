import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'base_obstacle.dart';
import '../../config/game_config.dart';
import '../../../models/level_data.dart';

/// Standard rotatable obstacle (green)
class NormalObstacle extends BaseObstacle {
  NormalObstacle({required Size size, Vector2? position})
      : super(
          type: ObstacleType.normal,
          obstacleSize: size,
          rotatable: true,
          primaryColor: GameConfig.normalObstacleColor,
          initialPosition: position,
        );

  @override
  void renderIcon(Canvas canvas) {
    // Normal obstacles don't have a special icon
    // Could add rotation indicator arrows here if desired
  }

  @override
  Color getBorderColor() => const Color(0xFF1B5E20);
}