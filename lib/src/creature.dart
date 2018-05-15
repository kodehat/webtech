part of mazegame;

abstract class Creature extends GameObject {

  final MazeGameModel _game;

  Creature(MazeGameModel this._game, int row, int col) : super(row, col);

  GameObject moveLeft() {
    print("Moving left: ${super.position.row}, ${super.position.col - 1}");
    Tile leftTile = _game.level.tiles.firstWhere((t) {
      return t.position.row == super.position.row && t.position.col == super.position.col - 1;
    }, orElse: () => new Tile.fromCoordinates(TileType.WALL, super.position.row, super.position.col - 1));

    print("Tile left: " + (leftTile == null ? "null" : leftTile.type));

    // Object is about to go into a wall
    if (leftTile == null) {
      return null;
    }

    // Terrain
    if (leftTile.type == TileType.TERRAIN) {
      self().type = TileType.TERRAIN;
      super.position.col -= 1;
      leftTile.type = TileType.START;
      return leftTile;
    }

    return leftTile;
  }

  GameObject moveRight() {
    print("Moving right: ${super.position.row}, ${super.position.col + 1}");
    Tile rightTile = _game.level.tiles.firstWhere((t) {
      return t.position.row == super.position.row && t.position.col == super.position.col + 1;
    }, orElse: () => new Tile.fromCoordinates(TileType.WALL, super.position.row, super.position.col + 1));

    print("Tile right: " + (rightTile == null ? "null" : rightTile.type));

    // Terrain
    if (rightTile.type == TileType.TERRAIN) {
      self().type = TileType.TERRAIN;
      super.position.col += 1;
      rightTile.type = TileType.START;
      return rightTile;
    }

    return rightTile;
  }

  GameObject moveUp() {
    print("Moving up: ${super.position.row - 1}, ${super.position.col}");
    Tile upperTile = _game.level.tiles.firstWhere((t) {
      return t.position.row == super.position.row - 1 && t.position.col == super.position.col;
    }, orElse: () => new Tile.fromCoordinates(TileType.WALL, super.position.row - 1, super.position.col));

    print("Tile up: " + (upperTile == null ? "null" : upperTile.type));

    // Terrain
    if (upperTile.type == TileType.TERRAIN) {
      self().type = TileType.TERRAIN;
      super.position.row -= 1;
      upperTile.type = TileType.START;
      return upperTile;
    }

    return upperTile;
  }

  GameObject moveDown() {
    print("Moving down: ${super.position.row + 1}, ${super.position.col}");
    Tile lowerTile = _game.level.tiles.firstWhere((t) {
      return t.position.row == super.position.row + 1 && t.position.col == super.position.col;
    }, orElse: () => new Tile.fromCoordinates(TileType.WALL, super.position.row + 1, super.position.col));

    print("Tile down: " + (lowerTile == null ? "null" : lowerTile.type));

    // Terrain
    if (lowerTile.type == TileType.TERRAIN) {
      self().type = TileType.TERRAIN;
      super.position.row += 1;
      lowerTile.type = TileType.START;
      return lowerTile;
    }

    return lowerTile;
  }

  Tile self();

}

class Enemy {

}