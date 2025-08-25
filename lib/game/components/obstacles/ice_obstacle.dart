import 'package:flutter/material.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'base_obstacle.dart';
import '../../config/game_config.dart';
import '../../../models/level_data.dart';
import '../ball.dart';

class IceObstacle extends BaseObstacle {
  IceObstacle({required Size size, Vector2? position})
      : super(
          type: ObstacleType.ice,
          obstacleSize: size,
          rotatable: true,
          primaryColor: GameConfig.iceObstacleColor,
          initialPosition: position,
        );

  @override
  void renderObstacleBody(Canvas canvas) {
    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: const Offset(3, 3),
        width: obstacleSize.width,
        height: obstacleSize.height,
      ),
      shadowPaint,
    );
    
    // Ice gradient effect
    final iceGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xFFB3E5FC),
        const Color(0xFFE1F5FE),
        const Color(0xFFB3E5FC),
      ],
    );
    
    final bodyPaint = Paint()
      ..shader = iceGradient.createShader(
        Rect.fromCenter(
          center: Offset.zero,
          width: obstacleSize.width,
          height: obstacleSize.height,
        ),
      );
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: obstacleSize.width,
        height: obstacleSize.height,
      ),
      bodyPaint,
    );
    
    // Ice crystals pattern
    final crystalPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Draw some crystalline patterns
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        final centerX = i * 20.0;
        final centerY = j * 10.0;
        
        // Draw a simple crystal pattern
        canvas.drawLine(
          Offset(centerX - 5, centerY),
          Offset(centerX + 5, centerY),
          crystalPaint,
        );
        canvas.drawLine(
          Offset(centerX, centerY - 5),
          Offset(centerX, centerY + 5),
          crystalPaint,
        );
        canvas.drawLine(
          Offset(centerX - 3, centerY - 3),
          Offset(centerX + 3, centerY + 3),
          crystalPaint,
        );
        canvas.drawLine(
          Offset(centerX - 3, centerY + 3),
          Offset(centerX + 3, centerY - 3),
          crystalPaint,
        );
      }
    }
    
    // Border
    final borderPaint = Paint()
      ..color = const Color(0xFF81D4FA)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: obstacleSize.width,
        height: obstacleSize.height,
      ),
      borderPaint,
    );
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
    
    if (other is Ball) {
      other.setOnIce(true);
    }
  }

  /// Called when ball slides on ice (reduced friction)
  void onBallSlide() {
    pulseEffect = 1.0; // Visual feedback
  }

  @override
  double getFriction() => 0.1; // Very low friction for ice
  
  @override
  Color getBorderColor() => const Color(0xFF0277BD);
  
  @override
  List<Color> getGradientColors() => [
    primaryColor,
    const Color(0xFF29B6F6),
    const Color(0xFF03A9F4),
  ];

  @override
  void renderIcon(Canvas canvas) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '❄️',
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