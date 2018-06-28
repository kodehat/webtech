part of mazegame;

abstract class Enemy extends Creature {

  String _movementType;
  String _lastDirection;

  Enemy(MazeGameModel game, String type, int row, int col, this._movementType) : super(game, type, row, col);

  void move() {
    print("Enemy move $_movementType");
    switch (_movementType) {
      case EnemyMovementType.HOR_FIRST_LEFT:
        onHorFirstLeft();
        break;
      case EnemyMovementType.HOR_FIRST_RIGHT:
        onHorFirstRight();
        break;
      case EnemyMovementType.VERT_FIRST_UP:
        onVertFirstUp();
        break;
      case EnemyMovementType.VERT_FIRST_DOWN:
        onVertFirstDown();
        break;
      case EnemyMovementType.ON_SIGHT:
        onOnSight();
        break;
    }
  }

  void onHorFirstLeft() {
    if (_lastDirection == null) {
      _lastDirection = Direction.LEFT;
    }

    GameObject collisionObj = _moveInCurrentLocation();

    if (collisionObj.type == TileType.WALL || collisionObj.type == TileType.HEDGE) {
      _lastDirection = _lastDirection == Direction.RIGHT ? Direction.LEFT : Direction.RIGHT;
      _moveInCurrentLocation();
    }
  }

  void onHorFirstRight() {
      if (_lastDirection == null) {
        _lastDirection = Direction.RIGHT;
      }

      GameObject collisionObj = _moveInCurrentLocation();

      if (collisionObj.type == TileType.WALL || collisionObj.type == TileType.HEDGE) {
        _lastDirection = _lastDirection == Direction.LEFT ? Direction.RIGHT : Direction.LEFT;
        _moveInCurrentLocation();
      }
  }

  void onVertFirstUp() {
    if (_lastDirection == null) {
      _lastDirection = Direction.UP;
    }

    GameObject collisionObj = _moveInCurrentLocation();

    if (collisionObj.type == TileType.WALL || collisionObj.type == TileType.HEDGE) {
      _lastDirection = _lastDirection == Direction.DOWN ? Direction.UP : Direction.DOWN;
      _moveInCurrentLocation();
    }
  }

  void onVertFirstDown() {
    if (_lastDirection == null) {
      _lastDirection = Direction.DOWN;
    }

    GameObject collisionObj = _moveInCurrentLocation();

    if (collisionObj.type == TileType.WALL || collisionObj.type == TileType.HEDGE) {
      _lastDirection = _lastDirection == Direction.UP ? Direction.DOWN : Direction.UP;
      _moveInCurrentLocation();
    }
  }

  void onOnSight() {
    // TODO: Check if no obstacles are between the enemy and the rabbit. Then move into desired location.

    if (this.position.row == this._game._rabbit.position.row) { // On same row
      for (int dCol = min(this.position.col, this._game._rabbit.position.col) + 1; dCol < max(this.position.col, this._game._rabbit.position.col); dCol++) {
        GameObject obj = _game._level.objects[this.position.row][dCol];
        if (obj.type != TileType.TERRAIN) {
          return;
        }
      }
      print("On sight enemy on: ${this.position} has rabbit in sight!");
      if (this.position.col < this._game._rabbit.position.col) {
        moveRight();
      } else {
        moveLeft();
      }
    } else if (this.position.col == this._game._rabbit.position.col) { // On same column
      for (int dRow = min(this.position.row, this._game._rabbit.position.row) + 1; dRow < max(this.position.row, this._game._rabbit.position.row); dRow++) {
        GameObject obj = _game._level.objects[dRow][this.position.col];
        if (obj.type != TileType.TERRAIN) {
          return;
        }
      }
      print("On sight enemy on: ${this.position} has rabbit in sight!");
      if (this.position.row < this._game._rabbit.position.row) {
        moveDown();
      } else {
        moveUp();
      }
    }
  }

  GameObject _moveInCurrentLocation() {
    switch(_lastDirection) {
      case Direction.LEFT:
        return super.moveLeft();
      case Direction.RIGHT:
        return super.moveRight();
      case Direction.UP:
        return super.moveUp();
      case Direction.DOWN:
        return super.moveDown();
    }
    return null;
  }

  String get movementType => _movementType;
}

class EnemyMovementType {

  static const String HOR_FIRST_LEFT = "HOR_FIRST_LEFT";
  static const String HOR_FIRST_RIGHT = "HOR_FIRST_RIGHT";
  static const String VERT_FIRST_UP = "VERT_FIRST_UP";
  static const String VERT_FIRST_DOWN = "VERT_FIRST_DOWN";
  static const String ON_SIGHT = "ON_SIGHT";

  static List<String> get types => [
    HOR_FIRST_LEFT,
    HOR_FIRST_RIGHT,
    VERT_FIRST_UP,
    VERT_FIRST_DOWN,
    ON_SIGHT,
  ];

}

class Direction {

  static const String LEFT = "LEFT";
  static const String RIGHT = "RIGHT";
  static const String UP = "UP";
  static const String DOWN = "DOWN";

  static List<String> get types => [
    LEFT,
    RIGHT,
    UP,
    DOWN,
  ];

}