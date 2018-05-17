part of mazegame;

class Tile extends GameObject {

  String type;

  Tile.fromCoordinates(this.type, int row, int col) : super(row, col) {
    this.position = new Position.fromCoordinates(row, col);
  }

  String toString() {
    return "Tile{ pos: $position, type: $type }";
  }
}

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