part of mazegame;

class TileType {

  static const String HEDGE = "HEDGE";
  static const String TERRAIN = "TERRAIN";
  static const String GOAL = "GOAL";
  static const String START = "START";
  static const String FOX = "FOX";
  static const String WALL = "WALL";

  static List<String> get types => [
    HEDGE,
    TERRAIN,
    GOAL,
    START,
    FOX,
    WALL,
  ];
}

class UnknownTileTypeException implements Exception {
  String message;
  UnknownTileTypeException(message);
}