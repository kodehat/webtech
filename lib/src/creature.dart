part of mazegame;

abstract class Creature extends GameObject {

  final MazeGameModel _game;

  Creature(MazeGameModel this._game, int row, int col) : super(row, col);

  void moveTo(int newRow, int newCol) {
    // Update object at previous/own position.
    _game.level.objects[super.position.row][super.position.col] = _game.level.objects[newRow][newCol];

    // Update own position.
    super.position.row = newRow;
    super.position.col = newCol;

    // Update self at new position;
    _game.level.objects[newRow][newCol] = this;
  }

  GameObject _move(int dRow, int dCol) {
    int newRow = super.position.row + dRow;
    int newCol = super.position.col + dCol;
    GameObject collisionObj;

    try {
      collisionObj = _game.level.objects[newRow][newCol] ?? new Tile.fromCoordinates(TileType.WALL, newRow, newCol);
    } on RangeError catch(_) {
      collisionObj = new Tile.fromCoordinates(TileType.WALL, newRow, newCol);
    }

    String collisionType = GameObject.getType(collisionObj);

    print("Try to move at: $newRow, $newCol. Type is $collisionType");

    if (collisionType == TileType.TERRAIN) {
      moveTo(newRow, newCol);
    }

    return collisionObj;
  }

  GameObject moveLeft() {
    print("Moving left!");
    return _move(0, -1);
  }

  GameObject moveRight() {
    print("Moving right!");
    return _move(0, 1);
  }

  GameObject moveUp() {
    print("Moving up!");
    return _move(-1, 0);
  }

  GameObject moveDown() {
    print("Moving down!");
    return _move(1, 0);
  }
}

class Enemy {

}