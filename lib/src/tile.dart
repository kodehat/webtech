part of mazegame;

class Tile extends GameObject {

  Position position;
  String type;

  Tile();

  Tile.fromCoordinates(int row, int col, this.type) {
    this.position = new Position.fromCoordinates(row, col);
  }

  Tile.fromPosition(this.position, this.type);

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