import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SuccessParticle extends Component {
  late Vector2 velocity;
  late double life;
  late double maxLife;
  late Color color;
  late double size;
  
  SuccessParticle({
    required Vector2 position,
    required this.color,
  }) {
    this.position = position;
    velocity = Vector2(
      (Random().nextDouble() - 0.5) * 200,
      -Random().nextDouble() * 300 - 100,
    );
    maxLife = life = 1.0 + Random().nextDouble();
    size = Random().nextDouble() * 8 + 4;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    position += velocity * dt;
    velocity.y += 300 * dt; // Gravity
    life -= dt;
    
    if (life <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final alpha = (life / maxLife).clamp(0.0, 1.0);
    final currentSize = size * alpha;
    
    final paint = Paint()
      ..color = color.withOpacity(alpha)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(position.x, position.y),
      currentSize,
      paint,
    );
  }
}