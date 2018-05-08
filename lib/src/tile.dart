part of mazegame;

class Tile extends GameObject {

  Position position;
  TileType type;

  Tile();

  Tile.fromCoordinates(int row, int col, this.type) {
    this.position = new Position.fromCoordinates(row, col);
  }

  Tile.fromPosition(this.position, this.type);

  String toString() {
    return "Tile{ pos: $position, type: $type }";
  }
}

enum TileType {
  HEDGE,
  TERRAIN,
  GOAL,
  START,
}