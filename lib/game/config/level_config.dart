import 'dart:ui';
import '../../models/level_data.dart';

class LevelConfig {
  static List<LevelData> getAllLevels() {
    return [
      _getLevel1(),
      _getLevel2(),
      _getLevel3(),
      _getLevel4(),
      _getLevel5(),
      _getLevel6(),
      _getLevel7(),
      _getLevel8(),
      _getLevel9(),
      _getLevel10(),
      _getLevel11(),
      _getLevel12(),
    ];
  }

  static LevelData getLevel(int levelId) {
    final levels = getAllLevels();
    if (levelId > 0 && levelId <= levels.length) {
      return levels[levelId - 1];
    }
    return _generateRandomLevel(levelId);
  }

  static LevelData _getLevel1() {
    return LevelData(
      levelId: 1,
      par: 3,
      obstacles: [
        ObstacleData(
          type: ObstacleType.normal,
          position: const Offset(200, 300),
          size: const Size(150, 20),
        ),
      ],
      goal: const Offset(200, 450),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel2() {
    return LevelData(
      levelId: 2,
      par: 4,
      obstacles: [
        ObstacleData(
          type: ObstacleType.trampoline,
          position: const Offset(100, 250),
          size: const Size(120, 20),
        ),
        ObstacleData(
          type: ObstacleType.normal,
          position: const Offset(300, 350),
          size: const Size(120, 20),
        ),
      ],
      goal: const Offset(200, 500),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel3() {
    return LevelData(
      levelId: 3,
      par: 4,
      obstacles: [
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(150, 200),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(250, 300),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.static,
          position: const Offset(200, 400),
          size: const Size(150, 20),
        ),
      ],
      goal: const Offset(350, 500),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel4() {
    return LevelData(
      levelId: 4,
      par: 5,
      obstacles: [
        ObstacleData(
          type: ObstacleType.magnet,
          position: const Offset(100, 200),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.magnet,
          position: const Offset(300, 200),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.trampoline,
          position: const Offset(200, 300),
          size: const Size(120, 20),
        ),
        ObstacleData(
          type: ObstacleType.lava,
          position: const Offset(200, 400),
          size: const Size(100, 20),
        ),
      ],
      goal: const Offset(200, 520),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel5() {
    return LevelData(
      levelId: 5,
      par: 6,
      obstacles: [
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(150, 180),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(250, 260),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.magnet,
          position: const Offset(150, 340),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.lava,
          position: const Offset(250, 420),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.trampoline,
          position: const Offset(100, 420),
          size: const Size(80, 20),
        ),
      ],
      goal: const Offset(100, 520),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel6() {
    return LevelData(
      levelId: 6,
      par: 5,
      obstacles: [
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(200, 200),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(150, 300),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.normal,
          position: const Offset(250, 400),
          size: const Size(100, 20),
        ),
      ],
      goal: const Offset(300, 500),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel7() {
    return LevelData(
      levelId: 7,
      par: 6,
      obstacles: [
        ObstacleData(
          type: ObstacleType.magnet,
          position: const Offset(100, 250),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.magnet,
          position: const Offset(300, 250),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.normal,
          position: const Offset(200, 350),
          size: const Size(120, 20),
        ),
      ],
      goal: const Offset(200, 500),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel8() {
    return LevelData(
      levelId: 8,
      par: 7,
      obstacles: [
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(100, 180),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(300, 180),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.trampoline,
          position: const Offset(200, 280),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(150, 380),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.lava,
          position: const Offset(250, 430),
          size: const Size(60, 20),
        ),
      ],
      goal: const Offset(100, 520),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel9() {
    return LevelData(
      levelId: 9,
      par: 8,
      obstacles: [
        ObstacleData(
          type: ObstacleType.magnet,
          position: const Offset(120, 150),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.magnet,
          position: const Offset(280, 150),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(200, 250),
          size: const Size(120, 20),
        ),
        ObstacleData(
          type: ObstacleType.trampoline,
          position: const Offset(100, 350),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.lava,
          position: const Offset(300, 350),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(200, 450),
          size: const Size(100, 20),
        ),
      ],
      goal: const Offset(350, 520),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel10() {
    return LevelData(
      levelId: 10,
      par: 8,
      obstacles: [
        ObstacleData(
          type: ObstacleType.lava,
          position: const Offset(100, 150),
          size: const Size(60, 20),
        ),
        ObstacleData(
          type: ObstacleType.lava,
          position: const Offset(300, 150),
          size: const Size(60, 20),
        ),
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(200, 220),
          size: const Size(150, 20),
        ),
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(120, 320),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(280, 320),
          size: const Size(80, 20),
        ),
        ObstacleData(
          type: ObstacleType.trampoline,
          position: const Offset(200, 420),
          size: const Size(100, 20),
        ),
      ],
      goal: const Offset(200, 550),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel11() {
    return LevelData(
      levelId: 11,
      par: 9,
      obstacles: [
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(150, 150),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.rotating,
          position: const Offset(250, 200),
          size: const Size(100, 20),
        ),
        ObstacleData(
          type: ObstacleType.trampoline,
          position: const Offset(200, 400),
          size: const Size(120, 20),
        ),
        ObstacleData(
          type: ObstacleType.static,
          position: const Offset(80, 300),
          size: const Size(60, 80),
        ),
        ObstacleData(
          type: ObstacleType.static,
          position: const Offset(320, 300),
          size: const Size(60, 80),
        ),
      ],
      goal: const Offset(100, 500),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _getLevel12() {
    return LevelData(
      levelId: 12,
      par: 10,
      obstacles: [
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(120, 180),
          size: const Size(120, 20),
        ),
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(200, 280),
          size: const Size(120, 20),
        ),
        ObstacleData(
          type: ObstacleType.ice,
          position: const Offset(280, 380),
          size: const Size(120, 20),
        ),
        ObstacleData(
          type: ObstacleType.lava,
          position: const Offset(50, 250),
          size: const Size(60, 200),
        ),
        ObstacleData(
          type: ObstacleType.normal,
          position: const Offset(150, 450),
          size: const Size(80, 20),
        ),
      ],
      goal: const Offset(350, 500),
      ballStart: const Offset(200, 50),
    );
  }

  static LevelData _generateRandomLevel(int levelId) {
    final obstacles = <ObstacleData>[];
    final types = ObstacleType.values;
    final numObstacles = 3 + (levelId ~/ 2).clamp(0, 5);

    for (int i = 0; i < numObstacles; i++) {
      final x = 50 + (300 * (i % 3)) / 2;
      final y = 150.0 + i * (350 / numObstacles);
      final width = 80.0 + (70.0 * (i % 2));
      final type = types[(i + levelId) % types.length];

      obstacles.add(
        ObstacleData(
          type: type,
          position: Offset(x, y),
          size: Size(width, 20),
        ),
      );
    }

    return LevelData(
      levelId: levelId,
      par: numObstacles + 2,
      obstacles: obstacles,
      goal: Offset(50 + (300 * ((levelId + 1) % 4)) / 3, 500 + (levelId % 3) * 15),
      ballStart: const Offset(200, 50),
    );
  }
}