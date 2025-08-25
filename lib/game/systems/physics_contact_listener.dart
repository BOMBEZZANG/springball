import 'package:flame_forge2d/flame_forge2d.dart';
import '../components/ball.dart';
import '../components/obstacles/lava_obstacle.dart';
import '../components/obstacles/trampoline_obstacle.dart';
import '../components/obstacles/ice_obstacle.dart';
import '../components/obstacles/base_obstacle.dart';
import 'audio_manager.dart';

/// Custom contact listener for handling special obstacle interactions
class PhysicsContactListener extends ContactListener {
  @override
  void beginContact(Contact contact) {
    final fixtureA = contact.fixtureA;
    final fixtureB = contact.fixtureB;

    final bodyA = fixtureA.body;
    final bodyB = fixtureB.body;

    // Get the components from userData
    final componentA = bodyA.userData;
    final componentB = bodyB.userData;

    Ball? ball;
    BaseObstacle? obstacle;

    // Determine which is the ball and which is the obstacle
    if (componentA is Ball && componentB is BaseObstacle) {
      ball = componentA;
      obstacle = componentB;
    } else if (componentA is BaseObstacle && componentB is Ball) {
      ball = componentB;
      obstacle = componentA;
    }

    if (ball != null && obstacle != null) {
      _handleObstacleCollision(ball, obstacle, contact);
    }
  }

  @override
  void endContact(Contact contact) {
    // Handle any cleanup when contact ends
  }

  void _handleObstacleCollision(
      Ball ball, BaseObstacle obstacle, Contact contact) {
    if (!ball.isActive) return;

    switch (obstacle.runtimeType) {
      case LavaObstacle:
        _handleLavaCollision(ball, obstacle as LavaObstacle);
        break;

      case TrampolineObstacle:
        _handleTrampolineCollision(
            ball, obstacle as TrampolineObstacle, contact);
        break;

      case IceObstacle:
        _handleIceCollision(ball, obstacle as IceObstacle);
        break;

      default:
        _handleNormalCollision(ball, obstacle);
        break;
    }
  }

  void _handleLavaCollision(Ball ball, LavaObstacle lava) {
    // Instant game over on lava contact
    ball.onFail();
    AudioManager().playLavaContact();

    // Could trigger particle effects here
    lava.onBallDestroyed();
  }

  void _handleTrampolineCollision(
      Ball ball, TrampolineObstacle trampoline, Contact contact) {
    // Calculate bounce direction from contact normal
    final worldManifold = WorldManifold();
    contact.getWorldManifold(worldManifold);

    if (worldManifold.points.isNotEmpty) {
      // Use the contact normal for bounce direction
      final normal = worldManifold.normal;

      // Apply trampoline bounce effect
      ball.applyTrampolineBounce(normal);

      // Trigger trampoline visual effects
      trampoline.onBallBounce();
    }
  }

  void _handleIceCollision(Ball ball, IceObstacle ice) {
    // Apply ice effect (remove friction)
    ball.setOnIce(true);
    AudioManager().playIceSlide();

    // Trigger ice visual effects
    ice.onBallSlide();
  }

  void _handleNormalCollision(Ball ball, BaseObstacle obstacle) {
    // Standard collision - just play bounce sound
    AudioManager().playBallBounce();

    // Trigger obstacle hit effect
    obstacle.onBallHit();
  }

  @override
  void preSolve(Contact contact, Manifold oldManifold) {
    // Modify collision behavior before resolution if needed
  }

  @override
  void postSolve(Contact contact, ContactImpulse impulse) {
    // Handle post-collision effects if needed
  }
}
