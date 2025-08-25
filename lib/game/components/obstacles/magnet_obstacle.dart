import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'base_obstacle.dart';
import '../../config/game_config.dart';
import '../../../models/level_data.dart';
import '../ball.dart';
import '../../systems/audio_manager.dart';

class MagnetObstacle extends BaseObstacle with MagneticObstacle {
  final List<MagneticField> _fieldRings = [];
  double _attractionTimer = 0;
  bool _isAttracting = false;

  MagnetObstacle({required Size size, Vector2? position})
      : super(
          type: ObstacleType.magnet,
          obstacleSize: size,
          rotatable: true,
          primaryColor: GameConfig.magnetObstacleColor,
          initialPosition: position,
        ) {
    // Initialize magnetic field rings
    for (int i = 1; i <= 3; i++) {
      _fieldRings.add(MagneticField(radius: 30.0 * i, speed: 0.5 + i * 0.2));
    }
  }

  @override
  void updateSpecialBehavior(double dt) {
    _attractionTimer += dt;
    _isAttracting = false;
    
    // Update magnetic field rings
    for (final ring in _fieldRings) {
      ring.update(dt);
    }
    
    // Find nearby balls and apply magnetic force
    final balls = parent?.children.whereType<Ball>() ?? [];
    
    for (final ball in balls) {
      if (ball.isActive) {
        final distance = (ball.body.position - body.position).length;
        final scaledRange = magneticRange / 10; // Scale for Box2D
        
        if (distance < scaledRange) {
          _isAttracting = true;
          applyMagneticForce(ball);
          
          // Play attraction sound occasionally
          if (_attractionTimer > 0.5) {
            AudioManager().playMagnetAttract();
            _attractionTimer = 0;
          }
        }
      }
    }
  }

  @override
  void renderSpecialEffects(Canvas canvas) {
    // Render magnetic field rings
    final fieldPaint = Paint()
      ..color = primaryColor.withOpacity(0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    for (final ring in _fieldRings) {
      final alpha = _isAttracting ? 0.3 : 0.15;
      final dynamicAlpha = alpha + sin(ring.phase) * 0.1;
      
      fieldPaint.color = primaryColor.withOpacity(dynamicAlpha);
      canvas.drawCircle(Offset.zero, ring.currentRadius, fieldPaint);
    }
    
    // Core magnetic effect
    _renderMagneticCore(canvas);
    
    // Attraction lines if attracting
    if (_isAttracting) {
      _renderAttractionLines(canvas);
    }
  }

  void _renderMagneticCore(Canvas canvas) {
    final corePaint = Paint()
      ..color = primaryColor.withOpacity(0.6)
      ..style = PaintingStyle.fill;
    
    // Pulsing magnetic core
    final coreRadius = 8 + sin(pulseEffect * 4) * 2;
    canvas.drawCircle(Offset.zero, coreRadius, corePaint);
    
    // Inner glow
    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(Offset.zero, coreRadius * 0.6, glowPaint);
  }

  void _renderAttractionLines(Canvas canvas) {
    final linePaint = Paint()
      ..color = primaryColor.withOpacity(0.4)
      ..strokeWidth = 1.5;
    
    // Draw magnetic field lines
    const numLines = 8;
    for (int i = 0; i < numLines; i++) {
      final angle = (i * 2 * pi / numLines) + pulseEffect;
      final startRadius = 15.0;
      final endRadius = magneticRange / 3;
      
      final startX = cos(angle) * startRadius;
      final startY = sin(angle) * startRadius;
      final endX = cos(angle) * endRadius;
      final endY = sin(angle) * endRadius;
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        linePaint,
      );
    }
  }

  @override
  void renderIcon(Canvas canvas) {
    // Magnet emoji with enhanced glow
    final textPainter = TextPainter(
      text: TextSpan(
        text: '🧲',
        style: TextStyle(
          fontSize: 16,
          shadows: [
            Shadow(
              color: primaryColor.withOpacity(0.8),
              blurRadius: 3,
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
  Color getBorderColor() => const Color(0xFF0D47A1);
  
  @override
  List<Color> getGradientColors() => [
    primaryColor,
    const Color(0xFF1976D2),
    const Color(0xFF2196F3),
  ];

  @override
  void onBallHit() {
    super.onBallHit();
    // Create magnetic pulse effect
    for (final ring in _fieldRings) {
      ring.pulse();
    }
  }

  @override
  Map<String, dynamic> getSpecialProperties() => {
    'magneticRange': magneticRange,
    'magneticStrength': magneticStrength,
    'isAttracting': _isAttracting,
  };
}

/// Magnetic field ring for visual effects
class MagneticField {
  final double baseRadius;
  final double speed;
  double phase = 0;
  double pulseStrength = 0;
  
  MagneticField({required double radius, required this.speed}) 
      : baseRadius = radius;

  double get currentRadius => baseRadius + sin(phase) * 5 + pulseStrength;

  void update(double dt) {
    phase += speed * dt;
    if (phase > 2 * pi) phase -= 2 * pi;
    
    // Decay pulse strength
    if (pulseStrength > 0) {
      pulseStrength -= dt * 20; // Decay rate
      if (pulseStrength < 0) pulseStrength = 0;
    }
  }

  void pulse() {
    pulseStrength = 10; // Pulse magnitude
  }
}