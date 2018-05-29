part of mazegame;

abstract class Tile extends GameObject {

  Tile.fromCoordinates(String type, int row, int col) : super(type, row, col) {
    this.position = new Position.fromCoordinates(row, col);
  }

  String toString() {
    return "Tile{ pos: $position, type: $type }";
  }
}

class Hedge extends Tile {

  Hedge.fromCoordinates(int row, int col) : super.fromCoordinates(TileType.HEDGE, row, col);
}

class Terrain extends Tile {

  Terrain.fromCoordinates(int row, int col) : super.fromCoordinates(TileType.TERRAIN, row, col);
}

class Goal extends Tile {

  Goal.fromCoordinates(int row, int col) : super.fromCoordinates(TileType.GOAL, row, col);
}

class Wall extends Tile {

  Wall.fromCoordinates(int row, int col) : super.fromCoordinates(TileType.WALL, row, col);
}