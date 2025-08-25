import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../config/game_config.dart';
import '../systems/audio_manager.dart';
import 'package:flutter/services.dart';

class Goal extends BodyComponent {
  double _pulseTime = 0;
  bool _isCompleted = false;
  late CircleShape shape;
  
  Goal({Vector2? initialPosition}) : super() {
    renderBody = false; // Custom rendering
    if (initialPosition != null) {
      _initialPosition = initialPosition;
    }
  }

  Vector2 _initialPosition = Vector2(200, 450);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _createPhysicsBody();
  }

  void _createPhysicsBody() {
    shape = CircleShape()..radius = GameConfig.goalRadius / 10;

    final fixtureDef = FixtureDef(
      shape,
      isSensor: true, // Sensor doesn't create collision response
    );

    final bodyDef = BodyDef(
      position: _initialPosition / 10, // Scale for Box2D
      type: BodyType.static,
    );

    body = world.createBody(bodyDef)..createFixture(fixtureDef);
    body.userData = this;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _pulseTime += dt;
  }

  @override
  void render(Canvas canvas) {
    final position = body.position * 10; // Scale for rendering
    final center = Offset(position.x, position.y);
    final pulseSize = sin(_pulseTime * 3) * 5;
    
    // Outer glow effect
    _renderGlowEffect(canvas, center, pulseSize);
    
    // Main goal body
    _renderGoalBody(canvas, center, pulseSize);
    
    // Border
    _renderBorder(canvas, center, pulseSize);
    
    // Star icon
    _renderStar(canvas, center, 12 + pulseSize / 2);
  }

  void _renderGlowEffect(Canvas canvas, Offset center, double pulseSize) {
    final glowPaint = Paint()
      ..color = GameConfig.successColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      center,
      GameConfig.goalRadius + pulseSize + 10,
      glowPaint,
    );
  }

  void _renderGoalBody(Canvas canvas, Offset center, double pulseSize) {
    final gradient = RadialGradient(
      colors: [
        const Color(0xFF81C784),
        GameConfig.successColor,
      ],
    );
    
    final goalPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(
          center: center,
          radius: GameConfig.goalRadius + pulseSize,
        ),
      );
    
    canvas.drawCircle(
      center,
      GameConfig.goalRadius + pulseSize,
      goalPaint,
    );
  }

  void _renderBorder(Canvas canvas, Offset center, double pulseSize) {
    final borderPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(
      center,
      GameConfig.goalRadius + pulseSize,
      borderPaint,
    );
  }

  void _renderStar(Canvas canvas, Offset center, double size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    const numPoints = 5;
    const angle = 2 * pi / numPoints;
    
    for (int i = 0; i < numPoints * 2; i++) {
      final radius = (i % 2 == 0) ? size : size * 0.5;
      final x = center.dx + radius * cos(i * angle / 2 - pi / 2);
      final y = center.dy + radius * sin(i * angle / 2 - pi / 2);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    canvas.drawPath(path, paint);
  }

  /// Called when ball reaches the goal
  void onGoalReached() {
    if (!_isCompleted) {
      _isCompleted = true;
      AudioManager().playLevelComplete();
      HapticFeedback.heavyImpact();
    }
  }

  /// Check if ball is within goal area
  bool isBallInGoal(Vector2 ballPosition) {
    final goalPosition = body.position * 10;
    final distance = (ballPosition - goalPosition).length;
    return distance <= GameConfig.goalRadius;
  }

  /// Reset goal state
  void reset() {
    _isCompleted = false;
    _pulseTime = 0;
  }

  /// Update goal position
  void updatePosition(Vector2 newPosition) {
    body.setTransform(newPosition / 10, 0);
  }

  // Getters
  bool get isCompleted => _isCompleted;
  Vector2 get worldPosition => body.position * 10;
}