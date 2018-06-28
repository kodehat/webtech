part of mazegame;

/// Represents an enemy in the game field.
/// Contains basic and intelligent movement.
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
abstract class Enemy extends Creature {

  /// The type of movement the enemy does.
  /// Does no movement, if null.
  String _movementType;

  /// Speed of the enemy in milliseconds.
  /// Describes, when the enemy tries to move.
  int _speed;

  /// The duration for the movement trigger.
  /// Speed is based on [speed] in milliseconds.
  Duration moveCountdown;

  /// Timer, which does the movement of the enemy.
  /// Uses the [moveCountdown].
  Timer moveTimer;

  /// Creates a new [Enemy] with a given [type], a [movementType]
  /// and a position consisting of a [row] and a [col] coordinate.
  /// The speed of the enemy can be set with the optional parameter [speed].
  Enemy(String type, int row, int col, this._movementType, [this._speed = 750]) :
        super(type, row, col);

  /// Stop the game, if colliding with the rabbit (the player).
  /// Can be overwritten for other functionality.
  @override
  void onCollideWithRabbit(GameObject collisionObject, int newRow, int newCol) {
    //TODO: Update!
    //_game.level.gameOver = true;
    //_game.stop();
  }

  /// Starts the movement of the enemy by starting the timer.
  void startMoving() {
    // Return, if already moving.
    if (moveTimer.isActive) return;

    // Create the countdown.
    this.moveCountdown = new Duration(milliseconds: this._speed);
    // Create the periodic timer and set the [makeMove] method as callback.
    this.moveTimer = new Timer.periodic(this.moveCountdown, makeMove);
  }

  /// Stops the movement of the enemy by cancelling the timer.
  void stopMoving() {
    // Return, if not moving yet.
    if (!moveTimer.isActive) return;

    // Stop the movement timer.
    this.moveTimer.cancel();
  }

  /// Moves the enemy based on his [movementType].
  void makeMove(Timer timer) {
    print("Enemy ${this.position} tries to move ($_movementType).");

    // Move based on [movementType].
    switch (_movementType) {
      case EnemyMovementType.HOR_FIRST_LEFT:
        moveHorizontalFirstLeft();
        break;
      case EnemyMovementType.HOR_FIRST_RIGHT:
        moveHorizontalFirstRight();
        break;
      case EnemyMovementType.VERT_FIRST_UP:
        moveVerticalFirstUp();
        break;
      case EnemyMovementType.VERT_FIRST_DOWN:
        moveVerticalFirstDown();
        break;
      case EnemyMovementType.ON_SIGHT:
        moveIfRabbitInSight();
        break;
      default:
        throw new UnknownMovementTypeException("The enemy movement type"
            " the enemy has, is unknown!");
    }
  }

  /// Method, which is called, if the enemy's movement type describes to
  /// move HORIZONTALLY and the first direction is LEFT.
  void moveHorizontalFirstLeft() {
    // If the direction is null, set it to LEFT.
    if (this.direction == null) {
      this.direction = Direction.LEFT;
    }

    // Move into direction and get the collision object.
    GameObject collisionObj = super.move(this.direction);

    // Change the direction, if standing in front of the end of the game field
    // or a hedge.
    if (collisionObj.type == TileType.WALL
        || collisionObj.type == TileType.HEDGE) {

      // Change the direction into the opposite.
      this.direction = this.direction == Direction.RIGHT ? Direction.LEFT : Direction.RIGHT;

      // Move again, if last move was against a wall or a hedge.
      super.move(this.direction);
    }
  }

  /// Method, which is called, if the enemy's movement type describes to
  /// move HORIZONTALLY and the first direction is RIGHT.
  void moveHorizontalFirstRight() {
    // If the direction is null, set it to RIGHT.
    if (this.direction == null) {
      this.direction = Direction.RIGHT;
    }

    // Move into direction and get the collision object.
    GameObject collisionObj = super.move(this.direction);

    // Change the direction, if standing in front of the end of the game field
    // or a hedge.
    if (collisionObj.type == TileType.WALL || collisionObj.type == TileType.HEDGE) {

      // Change the direction into the opposite.
      this.direction = this.direction == Direction.LEFT ? Direction.RIGHT : Direction.LEFT;

      // Move again, if last move was against a wall or a hedge.
      super.move(this.direction);
    }
  }

  /// Method, which is called, if the enemy's movement type describes to
  /// move VERTICALLY and the first direction is UP.
  void moveVerticalFirstUp() {
    // If the direction is null, set it to RIGHT.
    if (this.direction == null) {
      this.direction = Direction.UP;
    }

    // Move into direction and get the collision object.
    GameObject collisionObj = super.move(this.direction);

    // Change the direction, if standing in front of the end of the game field
    // or a hedge.
    if (collisionObj.type == TileType.WALL || collisionObj.type == TileType.HEDGE) {
      // Change the direction into the opposite.
      this.direction = this.direction == Direction.DOWN ? Direction.UP : Direction.DOWN;

      // Move again, if last move was against a wall or a hedge.
      super.move(this.direction);
    }
  }

  /// Method, which is called, if the enemy's movement type describes to
  /// move VERTICALLY and the first direction is DOWN.
  void moveVerticalFirstDown() {
    // If the direction is null, set it to RIGHT.
    if (this.direction == null) {
      this.direction = Direction.DOWN;
    }

    // Move into direction and get the collision object.
    GameObject collisionObj = super.move(this.direction);

    // Change the direction, if standing in front of the end of the game field
    // or a hedge.
    if (collisionObj.type == TileType.WALL || collisionObj.type == TileType.HEDGE) {
      // Change the direction into the opposite.
      this.direction = this.direction == Direction.UP ? Direction.DOWN : Direction.UP;

      // Move again, if last move was against a wall or a hedge.
      super.move(this.direction);
    }
  }

  /// Method, which is called, if the enemy's movement type describes to
  /// move towards the rabbit (horizontal and vertical not diagonal),
  /// if it's in the enemy's sight.
  void moveIfRabbitInSight() {

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

/// This exception should be thrown, if a enemy movement type
/// is requested/used, which doesn't exist.
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
class UnknownMovementTypeException implements Exception {

  /// Message of the exception.
  String message;

  /// Creates a new [UnknownMovementTypeException] with a given [message].
  UnknownMovementTypeException(message);
}