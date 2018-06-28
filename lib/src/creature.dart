part of mazegame;

/// Abstract class representing a creature on the game field.
/// This includes the rabbit and the foxes.
/// It contains moving functionality and collision checking.
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
abstract class Creature extends GameObject {

  /// This attribute holds the game objects, which is below the [Creature]
  /// after moving. For instance a fox moves onto a goal field. This goal
  /// game object is now saved in this attribute until
  /// the fox moves away from it.
  /// Initial value is a terrain tile, which is below the [Creature].
  GameObject belowGameObject = new Terrain.fromCoordinates(0, 0);

  /// Creates a new [Creature] with a given [type] and a position
  /// with a [row] and a [col] coordinate.
  Creature(final String type, final int row, final int col) :
        super(type, row, col);

  /// Tries to move the [Creature] onto the given coordinates.
  /// Additionally handles collision checking.
  void _moveTo(final int newRow, final int newCol) {

    // Move to the new position and update the [belowGameObject].
    this.belowGameObject =
        MazeGameModel._level.updateGameObjectAtRowAndCol(newRow, newCol, this);
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