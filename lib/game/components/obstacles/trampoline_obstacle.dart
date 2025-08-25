import 'package:flutter/material.dart';
import 'dart:math';
import 'base_obstacle.dart';
import '../../config/game_config.dart';
import '../../../models/level_data.dart';

/// Trampoline obstacle that provides high bounce (cyan)
class TrampolineObstacle extends BaseObstacle with PhysicsAffectingObstacle {
  double _bounceStrength = 0;

  TrampolineObstacle({required Size size, Vector2? position})
      : super(
          type: ObstacleType.trampoline,
          obstacleSize: size,
          rotatable: true,
          primaryColor: GameConfig.trampolineObstacleColor,
          initialPosition: position,
        );

  @override
  void updateSpecialBehavior(double dt) {
    // Decay bounce strength for visual feedback
    if (_bounceStrength > 0) {
      _bounceStrength -= dt * 3;
      if (_bounceStrength < 0) _bounceStrength = 0;
    }
  }

  @override
  void renderObstacleBody(Canvas canvas) {
    // Bouncy effect - modify height based on bounce strength
    final bounceOffset = _bounceStrength * 3;
    
    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(3, 3 - bounceOffset),
        width: obstacleSize.width,
        height: obstacleSize.height,
      ),
      shadowPaint,
    );
    
    // Trampoline body with spring pattern
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: getGradientColors(),
    );
    
    final bodyPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCenter(
          center: Offset(0, -bounceOffset),
          width: obstacleSize.width,
          height: obstacleSize.height,
        ),
      );
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(0, -bounceOffset),
        width: obstacleSize.width,
        height: obstacleSize.height,
      ),
      bodyPaint,
    );
    
    // Spring pattern
    _renderSpringPattern(canvas, bounceOffset);
    
    // Border
    final borderPaint = Paint()
      ..color = getBorderColor()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(0, -bounceOffset),
        width: obstacleSize.width,
        height: obstacleSize.height,
      ),
      borderPaint,
    );
  }

  void _renderSpringPattern(Canvas canvas, double bounceOffset) {
    final springPaint = Paint()
      ..color = const Color(0xFF00ACC1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    // Draw spring zigzag pattern
    for (double x = -obstacleSize.width/2 + 15; x < obstacleSize.width/2; x += 25) {
      final path = Path();
      path.moveTo(x, -obstacleSize.height/2 - bounceOffset);
      path.lineTo(x + 5, -bounceOffset);
      path.lineTo(x + 10, -obstacleSize.height/2 - bounceOffset);
      path.lineTo(x + 15, obstacleSize.height/2 - bounceOffset);
      path.lineTo(x + 20, -obstacleSize.height/2 - bounceOffset);
      canvas.drawPath(path, springPaint);
    }
  }

  @override
  void renderIcon(Canvas canvas) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '🌊',
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

  @override
  void affectBallPhysics(ball) {
    // This is handled by the ContactListener for proper physics integration
  }

  /// Called when ball bounces on trampoline
  void onBallBounce() {
    _bounceStrength = 1.0; // Visual feedback
    pulseEffect = 0; // Reset pulse
  }

  @override
  Color getBorderColor() => const Color(0xFF006064);
  
  @override
  List<Color> getGradientColors() => [
    primaryColor,
    const Color(0xFF26C6DA),
    const Color(0xFF00BCD4),
  ];

  @override
  double getRestitution() => GameConfig.trampolineBounceMultiplier;
}