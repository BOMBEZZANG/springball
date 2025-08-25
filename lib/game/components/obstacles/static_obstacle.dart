import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'base_obstacle.dart';
import '../../config/game_config.dart';
import '../../../models/level_data.dart';

class StaticObstacle extends BaseObstacle {
  StaticObstacle({required Size size, Vector2? position})
      : super(
          type: ObstacleType.static,
          obstacleSize: size,
          rotatable: false,
          primaryColor: GameConfig.staticObstacleColor,
          initialPosition: position,
        );

  @override
  void renderIcon(Canvas canvas) {
    // No special icon for static obstacles, but maybe add a "lock" symbol
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🔒',
        style: TextStyle(fontSize: 12),
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