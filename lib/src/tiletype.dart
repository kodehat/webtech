part of mazegame;

class TileType {

  static const String HEDGE = "HEDGE";
  static const String TERRAIN = "TERRAIN";
  static const String GOAL = "GOAL";
  static const String RABBIT = "RABBIT";
  static const String FOX = "FOX";
  static const String WALL = "WALL";

  static List<String> get types => [
    HEDGE,
    TERRAIN,
    GOAL,
    RABBIT,
    FOX,
    WALL,
  ];
}

class UnknownTileTypeException implements Exception {
  String message;
  UnknownTileTypeException(message);
}