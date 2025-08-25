import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'base_obstacle.dart';
import '../../config/game_config.dart';
import '../../../models/level_data.dart';
import '../../systems/audio_manager.dart';

class LavaObstacle extends BaseObstacle {
  final List<LavaParticle> _particles = [];
  double _particleTimer = 0;

  LavaObstacle({required Size size, Vector2? position})
      : super(
          type: ObstacleType.lava,
          obstacleSize: size,
          rotatable: false,
          primaryColor: GameConfig.lavaObstacleColor,
          initialPosition: position,
        );

  @override
  void updateSpecialBehavior(double dt) {
    // Generate lava particles
    _particleTimer += dt;
    if (_particleTimer > 0.1 && Random().nextDouble() < 0.3) {
      _particles.add(
        LavaParticle(
          position: Vector2(
            (Random().nextDouble() - 0.5) * obstacleSize.width,
            -obstacleSize.height / 2,
          ),
          velocity: Vector2(
            (Random().nextDouble() - 0.5) * 30,
            -Random().nextDouble() * 50 - 20,
          ),
        ),
      );
      _particleTimer = 0;
    }
    
    // Update and clean up particles
    _particles.removeWhere((particle) => !particle.update(dt));
    
    // Limit particle count for performance
    if (_particles.length > 15) {
      _particles.removeAt(0);
    }
  }

  @override
  void renderSpecialEffects(Canvas canvas) {
    // Glow effect that pulsates
    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(0.4 + sin(pulseEffect * 4) * 0.1)
      ..style = PaintingStyle.fill;
    
    final glowSize = 8 + sin(pulseEffect * 3) * 4;
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset.zero,
        width: obstacleSize.width + glowSize * 2,
        height: obstacleSize.height + glowSize * 2,
      ),
      glowPaint,
    );
    
    // Render fire particles
    for (final particle in _particles) {
      particle.render(canvas);
    }
    
    // Heat shimmer effect (simplified)
    _renderHeatShimmer(canvas);
  }

  void _renderHeatShimmer(Canvas canvas) {
    final shimmerPaint = Paint()
      ..color = Colors.orange.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    // Create wavy heat effect
    final path = Path();
    const waveWidth = 20.0;
    final waveHeight = 3 + sin(pulseEffect * 5) * 2;
    
    path.moveTo(-obstacleSize.width / 2, -obstacleSize.height / 2 - 10);
    
    for (double x = -obstacleSize.width / 2; x <= obstacleSize.width / 2; x += 5) {
      final y = -obstacleSize.height / 2 - 10 + sin(x / waveWidth + pulseEffect * 3) * waveHeight;
      path.lineTo(x, y);
    }
    
    path.lineTo(obstacleSize.width / 2, -obstacleSize.height / 2 - 20);
    path.lineTo(-obstacleSize.width / 2, -obstacleSize.height / 2 - 20);
    path.close();
    
    canvas.drawPath(path, shimmerPaint);
  }

  @override
  void renderIcon(Canvas canvas) {
    // Fire emoji with extra glow
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🔥',
        style: TextStyle(
          fontSize: 18,
          shadows: [
            Shadow(
              color: Colors.orange.withOpacity(0.8),
              blurRadius: 4,
            ),
          ],
        ),
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
  Color getBorderColor() => const Color(0xFFBF360C);
  
  @override
  List<Color> getGradientColors() => [
    primaryColor,
    const Color(0xFFD32F2F),
    const Color(0xFFFF5722),
  ];

  /// Called when ball touches lava (instant game over)
  void onBallDestroyed() {
    // Create explosion effect
    for (int i = 0; i < 10; i++) {
      _particles.add(
        LavaParticle(
          position: Vector2.zero(),
          velocity: Vector2(
            (Random().nextDouble() - 0.5) * 100,
            -Random().nextDouble() * 100,
          ),
          isExplosion: true,
        ),
      );
    }
    
    AudioManager().playLavaContact();
  }

  @override
  double getFriction() => 0.3; // Less friction for hot surface
  
  @override
  double getRestitution() => 0.9; // High bounce for dramatic effect
}

/// Fire particle for lava obstacle effects
class LavaParticle {
  Vector2 position;
  Vector2 velocity;
  double life = 1.0;
  final double size;
  final bool isExplosion;
  final Color color;

  LavaParticle({
    required this.position,
    required this.velocity,
    this.isExplosion = false,
  }) : size = Random().nextDouble() * 6 + 2,
       color = isExplosion ? Colors.red : Colors.orange;

  bool update(double dt) {
    position += velocity * dt;
    velocity.y += 100 * dt; // Gravity
    velocity *= 0.98; // Air resistance
    life -= (isExplosion ? 3.0 : 1.5) * dt;
    return life > 0;
  }

  void render(Canvas canvas) {
    final alpha = life.clamp(0.0, 1.0);
    final currentSize = size * alpha;
    
    final paint = Paint()
      ..color = color.withOpacity(alpha);
    
    canvas.drawCircle(
      Offset(position.x, position.y),
      currentSize,
      paint,
    );
  }
}