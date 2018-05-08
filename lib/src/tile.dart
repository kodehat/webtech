part of mazegame;

class Tile extends GameObject {


  Position position;
  TileType type;

  Tile(int row, int col, this.type) {
    this.position = new Position(row, col);
  }

  Tile.fromPosition(this.position, this.type);

}

enum TileType {
  HEDGE, GROUND, GOAL, START
}