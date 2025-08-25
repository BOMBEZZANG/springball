import 'dart:ui';

class GameConfig {
  static const double gameWidth = 400;
  static const double gameHeight = 600;
  
  static const double ballRadius = 15;
  static const double ballGravity = 0.5;
  static const double ballBounce = 0.7;
  static const double ballFriction = 0.99;
  static const int ballTrailLength = 10;
  
  static const double goalRadius = 30;
  
  static const int particleLimit = 50;
  static const int maxPhysicsBodies = 100;
  
  static const double obstacleRotationStep = 0.7854; // 45 degrees in radians
  
  static const Duration levelTransitionDelay = Duration(milliseconds: 1500);
  static const Duration particleLifetime = Duration(milliseconds: 1000);
  
  // Colors
  static const Color backgroundStart = Color(0xFF1e3c72);
  static const Color backgroundEnd = Color(0xFF2a5298);
  static const Color ballColor = Color(0xFFFFD700);
  static const Color ballTrailColor = Color(0x80FFD700);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color failureColor = Color(0xFFFF5252);
  
  // Obstacle colors
  static const Color normalObstacleColor = Color(0xFF4CAF50);
  static const Color staticObstacleColor = Color(0xFFFF6B6B);
  static const Color rotatingObstacleColor = Color(0xFF9C27B0);
  static const Color magnetObstacleColor = Color(0xFF2196F3);
  static const Color trampolineObstacleColor = Color(0xFF00BCD4);
  static const Color iceObstacleColor = Color(0xFFE0F7FA);
  static const Color lavaObstacleColor = Color(0xFFFF5722);
  
  // Physics constants
  static const double magnetForce = 100;
  static const double trampolineBounceMultiplier = 1.8;
  static const double rotatingObstacleSpeed = 0.02;
  static const double iceFrictionMultiplier = 0;
}