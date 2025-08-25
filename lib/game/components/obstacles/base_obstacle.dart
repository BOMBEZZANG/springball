import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import '../../config/game_config.dart';
import '../../../models/level_data.dart';
import '../../systems/audio_manager.dart';

/// Abstract base class for all obstacles with common properties and behavior
abstract class BaseObstacle extends BodyComponent {
  final ObstacleType type;
  final Size obstacleSize;
  final bool rotatable;
  final Color primaryColor;

  // Common state
  double targetAngle = 0;
  double currentAngle = 0;
  double pulseEffect = 0;
  late PolygonShape shape;

  BaseObstacle({
    required this.type,
    required this.obstacleSize,
    required this.rotatable,
    required this.primaryColor,
    Vector2? initialPosition,
  }) : super() {
    renderBody = false; // Custom rendering
    if (initialPosition != null) {
      _initialPosition = initialPosition;
    }
  }

  Vector2 _initialPosition = Vector2(200, 300);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _createPhysicsBody();
  }

  void _createPhysicsBody() {
    shape = PolygonShape()
      ..setAsBoxXY(
        obstacleSize.width / 20, // Scale for Box2D
        obstacleSize.height / 20,
      );

    final fixtureDef = FixtureDef(
      shape,
      friction: getFriction(),
      restitution: getRestitution(),
      density: getDensity(),
    );

    final bodyDef = BodyDef(
      position: _initialPosition / 10, // Scale for Box2D
      angle: currentAngle,
      type: BodyType.static,
    );

    body = world.createBody(bodyDef)..createFixture(fixtureDef);
    body.userData = this;
  }

  @override
  void update(double dt) {
    super.update(dt);

    pulseEffect += dt;

    // Handle rotation animation
    if (rotatable && !isAutoRotating()) {
      final angleDiff = targetAngle - currentAngle;
      if (angleDiff.abs() > 0.01) {
        currentAngle += angleDiff * 5 * dt; // Smooth rotation
        body.setTransform(body.position, currentAngle);
      }
    }

    // Auto-rotation for specific obstacles
    if (isAutoRotating()) {
      currentAngle += getAutoRotationSpeed() * dt;
      body.setTransform(body.position, currentAngle);
    }

    updateSpecialBehavior(dt);
  }

  @override
  void render(Canvas canvas) {
    final position = body.position * 10; // Scale for rendering

    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.rotate(body.angle);

    // Render special effects first (glow, particles, etc.)
    renderSpecialEffects(canvas);

    // Render the main obstacle body
    renderObstacleBody(canvas);

    // Render obstacle icon/symbol
    renderIcon(canvas);

    canvas.restore();
  }

  /// Render the main obstacle body (can be overridden for special shapes)
  void renderObstacleBody(Canvas canvas) {
    // Shadow
    _renderShadow(canvas);

    // Main body with gradient
    _renderMainBody(canvas);

    // Border
    _renderBorder(canvas);
  }

  void _renderShadow(Canvas canvas) {
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
  }

  void _renderMainBody(Canvas canvas) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: getGradientColors(),
    );

    final bodyPaint = Paint()
      ..shader = gradient.createShader(
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
  }

  void _renderBorder(Canvas canvas) {
    final borderPaint = Paint()
      ..color = getBorderColor()
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

  /// Rotate the obstacle (for rotatable obstacles)
  void rotate() {
    if (rotatable && !isAutoRotating()) {
      targetAngle += GameConfig.obstacleRotationStep;
      if (targetAngle > 2 * pi) {
        targetAngle -= 2 * pi;
      }
      onRotated();
    }
  }

  /// Handle tap/touch events
  void onTapped() {
    if (rotatable) {
      rotate();
    }
  }

  /// Called when obstacle is rotated
  void onRotated() {
    AudioManager().playObstacleRotate();
    // Visual feedback can be added here
  }

  /// Called when ball hits this obstacle
  void onBallHit() {
    // Default implementation - can be overridden
    pulseEffect = 0; // Reset pulse for visual feedback
  }

  // Abstract methods that must be implemented by specific obstacles
  void updateSpecialBehavior(double dt) {}
  void renderSpecialEffects(Canvas canvas) {}
  void renderIcon(Canvas canvas) {}

  // Virtual methods with default implementations (can be overridden)
  List<Color> getGradientColors() =>
      [primaryColor, primaryColor.withOpacity(0.7)];
  Color getBorderColor() => primaryColor.withOpacity(0.8);
  double getFriction() => 0.7;
  double getRestitution() => 0.8;
  double getDensity() => 1.0;
  bool isAutoRotating() => false;
  double getAutoRotationSpeed() => 0.0;

  // Utility methods
  Vector2 get worldPosition => body.position * 10;

  void updatePosition(Vector2 newPosition) {
    body.setTransform(newPosition / 10, body.angle);
  }

  bool isPointInTapArea(Vector2 point) {
    final obstaclePosition = worldPosition;
    final distance = (point - obstaclePosition).length;
    final tapRadius = (obstacleSize.width + obstacleSize.height) / 4 + 20;
    return distance <= tapRadius;
  }

  /// Get obstacle type-specific properties for special behaviors
  Map<String, dynamic> getSpecialProperties() => {};
}

/// Mixin for obstacles that have magnetic properties
mixin MagneticObstacle on BaseObstacle {
  double get magneticRange => GameConfig.magnetForce;
  double get magneticStrength => 0.3;

  void applyMagneticForce(BodyComponent ball) {
    final ballPos = ball.body.position;
    final magnetPos = body.position;
    final distance = (ballPos - magnetPos).length;

    if (distance < magneticRange / 10) {
      // Scale for Box2D
      final direction = (magnetPos - ballPos).normalized();
      final force = (1 - distance / (magneticRange / 10)) * magneticStrength;
      final magnetForce = direction * force;

      ball.body.applyForce(magnetForce);
    }
  }
}

/// Mixin for obstacles that affect ball physics
mixin PhysicsAffectingObstacle on BaseObstacle {
  void affectBallPhysics(BodyComponent ball);
}
