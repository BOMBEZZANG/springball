import 'dart:ui';

enum ObstacleType {
  normal,
  static,
  rotating,
  magnet,
  trampoline,
  ice,
  lava
}

class ObstacleData {
  final ObstacleType type;
  final Offset position;
  final Size size;
  final double initialRotation;
  final Map<String, dynamic> properties;

  const ObstacleData({
    required this.type,
    required this.position,
    required this.size,
    this.initialRotation = 0,
    this.properties = const {},
  });

  factory ObstacleData.fromJson(Map<String, dynamic> json) {
    return ObstacleData(
      type: ObstacleType.values.byName(json['type']),
      position: Offset(json['position']['x'], json['position']['y']),
      size: Size(json['size']['width'], json['size']['height']),
      initialRotation: json['initialRotation']?.toDouble() ?? 0,
      properties: json['properties'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'position': {'x': position.dx, 'y': position.dy},
      'size': {'width': size.width, 'height': size.height},
      'initialRotation': initialRotation,
      'properties': properties,
    };
  }
}

class LevelData {
  final int levelId;
  final int par;
  final List<ObstacleData> obstacles;
  final Offset goal;
  final Offset ballStart;

  const LevelData({
    required this.levelId,
    required this.par,
    required this.obstacles,
    required this.goal,
    required this.ballStart,
  });

  factory LevelData.fromJson(Map<String, dynamic> json) {
    return LevelData(
      levelId: json['levelId'],
      par: json['par'],
      obstacles: (json['obstacles'] as List)
          .map((o) => ObstacleData.fromJson(o))
          .toList(),
      goal: Offset(json['goal']['x'], json['goal']['y']),
      ballStart: Offset(json['ballStart']['x'], json['ballStart']['y']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'levelId': levelId,
      'par': par,
      'obstacles': obstacles.map((o) => o.toJson()).toList(),
      'goal': {'x': goal.dx, 'y': goal.dy},
      'ballStart': {'x': ballStart.dx, 'y': ballStart.dy},
    };
  }
}