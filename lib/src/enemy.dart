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
      case EnemyMovementType.VERT_FIRST_LEFT:
        onVertFirstLeft();
        break;
      case EnemyMovementType.VERT_FIRST_RIGHT:
        onVertFirstRight();
        break;
      case EnemyMovementType.ON_SIGHT:
        onOnSight();
        break;
    }
  }

  void onHorFirstLeft() {

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

  void onVertFirstLeft() {

  }

  void onVertFirstRight() {

  }

  void onOnSight() {

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
  static const String VERT_FIRST_LEFT = "VERT_FIRST_LEFT";
  static const String VERT_FIRST_RIGHT = "VERT_FIRST_RIGHT";
  static const String ON_SIGHT = "ON_SIGHT";

  static List<String> get types => [
    HOR_FIRST_LEFT,
    HOR_FIRST_RIGHT,
    VERT_FIRST_LEFT,
    VERT_FIRST_RIGHT,
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