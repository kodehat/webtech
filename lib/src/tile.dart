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

  static final String HEDGE = "HEDGE";
  static final String TERRAIN = "TERRAIN";
  static final String GOAL = "GOAL";
  static final String START = "START";
  static final String FOX = "FOX";

  static List<String> get types => [
    HEDGE,
    TERRAIN,
    GOAL,
    START,
    FOX,
  ];
}