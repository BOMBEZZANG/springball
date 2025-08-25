import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../config/game_config.dart';
import '../systems/audio_manager.dart';
import 'package:flutter/services.dart';

class Ball extends BodyComponent {
  final List<Vector2> trail = [];
  bool onIce = false;
  bool isActive = true;
  late CircleShape shape;
  
  Ball({Vector2? initialPosition}) : super() {
    renderBody = false; // We'll handle rendering ourselves
    if (initialPosition != null) {
      _initialPosition = initialPosition;
    }
  }

  Vector2 _initialPosition = Vector2(200, 50);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _createPhysicsBody();
  }

  void _createPhysicsBody() {
    shape = CircleShape()..radius = GameConfig.ballRadius / 10;
    
    final fixtureDef = FixtureDef(
      shape,
      restitution: GameConfig.ballBounce,
      density: 1.0,
      friction: GameConfig.ballFriction,
    );

    final bodyDef = BodyDef(
      position: _initialPosition / 10,
      type: BodyType.dynamic,
    );

    body = world.createBody(bodyDef)..createFixture(fixtureDef);
    body.userData = this;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!isActive) return;

    // Add to trail
    trail.add(body.position.clone() * 10);
    if (trail.length > GameConfig.ballTrailLength) {
      trail.removeAt(0);
    }

    // Apply gravity enhancement (Box2D already applies gravity)
    body.applyForce(Vector2(0, GameConfig.ballGravity * body.mass));

    // Apply friction (modified for ice)
    if (!onIce) {
      final velocity = body.linearVelocity;
      body.linearVelocity = velocity * GameConfig.ballFriction;
    }

    // Check bounds
    if (body.position.y * 10 > GameConfig.gameHeight + 50) {
      onFail();
    }

    // Reset ice state each frame (will be set by ice obstacles)
    onIce = false;
  }

  @override
  void render(Canvas canvas) {
    if (!isActive) return;

    // Render trail
    _renderTrail(canvas);
    
    // Render ball
    final position = body.position * 10;
    _renderBall(canvas, position);

    // Render ice effect if on ice
    if (onIce) {
      _renderIceEffect(canvas, position);
    }
  }

  void _renderBall(Canvas canvas, Vector2 position) {
    final gradient = RadialGradient(
      colors: [
        GameConfig.ballColor,
        GameConfig.ballColor.withOpacity(0.7),
      ],
    );
    
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(
          center: Offset(position.x, position.y),
          radius: GameConfig.ballRadius,
        ),
      );
    
    canvas.drawCircle(
      Offset(position.x, position.y),
      GameConfig.ballRadius,
      paint,
    );
    
    // Border
    final borderPaint = Paint()
      ..color = const Color(0xFFFF8C00)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(
      Offset(position.x, position.y),
      GameConfig.ballRadius,
      borderPaint,
    );
  }

  void _renderTrail(Canvas canvas) {
    for (int i = 0; i < trail.length; i++) {
      final alpha = (i / trail.length * 0.5).clamp(0.0, 1.0);
      final radius = GameConfig.ballRadius * (i / trail.length);
      
      final paint = Paint()
        ..color = GameConfig.ballTrailColor.withOpacity(alpha);
      
      canvas.drawCircle(
        Offset(trail[i].x, trail[i].y),
        radius,
        paint,
      );
    }
  }

  void _renderIceEffect(Canvas canvas, Vector2 position) {
    final paint = Paint()
      ..color = const Color(0xFF00BCD4)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final center = Offset(position.x, position.y);
    
    // Draw dashed circle effect
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4);
      final startX = center.dx + cos(angle) * (GameConfig.ballRadius + 5);
      final startY = center.dy + sin(angle) * (GameConfig.ballRadius + 5);
      final endX = center.dx + cos(angle) * (GameConfig.ballRadius + 10);
      final endY = center.dy + sin(angle) * (GameConfig.ballRadius + 10);
      
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  void setOnIce(bool value) {
    onIce = value;
    if (value) {
      // Remove friction when on ice
      body.fixtures.first.friction = 0;
    } else {
      // Restore normal friction
      body.fixtures.first.friction = GameConfig.ballFriction;
    }
  }

  void applyMagnetForce(Vector2 force) {
    if (isActive) {
      body.applyForce(force);
    }
  }

  void applyTrampolineBounce(Vector2 normal) {
    if (isActive) {
      final bounceForce = normal * GameConfig.trampolineBounceMultiplier * 10;
      body.linearVelocity = body.linearVelocity + bounceForce;
      
      // Play sound and haptic
      AudioManager().playTrampolineBounce();
      HapticFeedback.mediumImpact();
    }
  }

  void onFail() {
    if (isActive) {
      isActive = false;
      AudioManager().playLevelFailed();
      HapticFeedback.heavyImpact();
    }
  }

  void reset(Vector2 position) {
    body.setTransform(position / 10, 0);
    body.linearVelocity = Vector2.zero();
    body.angularVelocity = 0;
    trail.clear();
    onIce = false;
    isActive = true;
  }

  void drop() {
    // Ball drops naturally due to gravity
    AudioManager().playBallDrop();
    HapticFeedback.lightImpact();
  }

  /// Get world position (scaled from physics position)
  Vector2 get worldPosition => body.position * 10;
}