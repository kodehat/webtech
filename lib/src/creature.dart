part of mazegame;

abstract class Creature extends GameObject {

  final MazeGameModel _game;

  Creature(MazeGameModel this._game, String type, int row, int col) : super(type, row, col);

  void _moveTo(int newRow, int newCol) {
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
      collisionObj = _game.level.objects[newRow][newCol] ?? new Wall.fromCoordinates(newRow, newCol);
    } on RangeError catch(_) {
      collisionObj = new Wall.fromCoordinates(newRow, newCol);
    }

    String collisionType = collisionObj.type;

    print("Try to move at: $newRow, $newCol. Type is $collisionType");

    switch(collisionType) {
      case TileType.TERRAIN:
        onCollideWithTerrain(collisionObj, newRow, newCol);
        break;
      case TileType.GOAL:
        onCollideWithGoal(collisionObj, newRow, newCol);
        break;
      case TileType.FOX:
        onCollideWithFox(collisionObj, newRow, newCol);
        break;
      case TileType.RABBIT:
        onCollideWithRabbit(collisionObj, newRow, newCol);
        break;
    }

    return collisionObj;
  }

  void onCollideWithTerrain(GameObject collisionObject, int newRow, int newCol) {
    _moveTo(newRow, newCol);
  }

  void onCollideWithGoal(GameObject collisionObject, int newRow, int newCol) {
    _game.level.done = true;
    _game.stop();
  }

  void onCollideWithFox(GameObject collisionObject, int newRow, int newCol) {
    _game.level.gameOver = true;
    _game.stop();
  }

  void onCollideWithRabbit(GameObject collisionObject, int newRow, int newCol) {
    _game.level.gameOver = true;
    _game.stop();
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