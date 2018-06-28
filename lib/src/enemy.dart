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
  Duration _moveCountdown;

  /// Timer, which does the movement of the enemy.
  /// Uses the [_moveCountdown].
  Timer _moveTimer;

  /// Instance of the model.
  MazeGameModel _game;

  /// Creates a new [Enemy] with a given [type], a [movementType]
  /// and a position consisting of a [row] and a [col] coordinate.
  /// The speed of the enemy can be set with the optional parameter [speed].
  Enemy(
      final String type,
      final int row,
      final int col,
      final this._movementType,
      [final this._speed = Constants.ENEMY_MOVEMENT_SPEED]) : super(type, row, col);

  /// Stop the game, if colliding with the rabbit (the player).
  /// Can be overwritten for other functionality.
  @override
  void onCollideWithRabbit(GameObject collisionObject, int newRow, int newCol) {
    //TODO: Update!
    //_game.level.gameOver = true;
    //_game.stop();
  }

  /// Starts the movement of the enemy by starting the timer.
  void startMoving(final MazeGameModel game) {
    // Return, if already moving.
    if (this._moveTimer != null && this._moveTimer.isActive) return;

    // Set the model for intelligent enemy movement.
    this._game = game;

    // Create the countdown.
    this._moveCountdown = new Duration(milliseconds: this._speed);
    // Create the periodic timer and set the [makeMove] method as callback.
    this._moveTimer = new Timer.periodic(this._moveCountdown, makeMove);
  }

  /// Stops the movement of the enemy by cancelling the timer.
  void stopMoving() {
    // Return, if not moving yet.
    if (!_moveTimer.isActive) return;

    // Stop the movement timer.
    this._moveTimer.cancel();
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
  /// if it's in the enemy's sight (just terrain between them).
  void moveIfRabbitInSight() {
    // Reference of the rabbit's position (just for shorter code).
    Position rabbitPos = this._game.rabbit.position;

    // If the enemy and the rabbit are on the same row.
    if (this.position.row == rabbitPos.row) {

      // Iterate all game objects horizontally between the enemy and the rabbit.
      // Check if no obstacles are in the way.
      // Skips the first one, it's one of the involved.
      for (int dCol = min(this.position.col, rabbitPos.col) + 1;
        dCol < max(this.position.col, rabbitPos.col);
        dCol++) {

        // Get the current object in the way between the involved.
        GameObject betweenObject =
          MazeGameModel.level.getGameObjectAtRowAndCol(this.position.row, dCol);

        // Return if type isn't terrain (ground).
        if (betweenObject.type != TileType.TERRAIN) {
          return;
        }
      }

      print("Enemy ${this.position} has rabbit in sight!");

      // Decide in which direction the enemy has to move.
      if (this.position.col < rabbitPos.col) {
        super.move(Direction.RIGHT);
      } else {
        super.move(Direction.LEFT);
      }

      // If the enemy and the rabbit are on the same column.
    } else if (this.position.col == rabbitPos.col) {
      for (int dRow = min(this.position.row, rabbitPos.row) + 1;
        dRow < max(this.position.row, rabbitPos.row);
        dRow++) {

        // Get the current object in the way between the involved.
        GameObject betweenObject =
          MazeGameModel.level.getGameObjectAtRowAndCol(dRow, this.position.col);

        // Return if type isn't terrain (ground).
        if (betweenObject.type != TileType.TERRAIN) {
          return;
        }
      }

      print("Enemy ${this.position} has rabbit in sight!");

      // Decide in which direction the enemy has to move.
      if (this.position.row < rabbitPos.row) {
        super.move(Direction.DOWN);
      } else {
        super.move(Direction.UP);
      }
    }
  }

  String get movementType => _movementType;
}

/// This class is meant as "Enum".
/// Represents the different movement types an enemy can have.
/// For instance there are HORIZONTAL FIRST LEFT or ON SIGHT.
class EnemyMovementType {

  /// Constant representing the HORIZONTAL FIRST LEFT movement type.
  static const String HOR_FIRST_LEFT = "HOR_FIRST_LEFT";

  /// Constant representing the HORIZONTAL FIRST RIGHT movement type.
  static const String HOR_FIRST_RIGHT = "HOR_FIRST_RIGHT";

  /// Constant representing the VERTICAL FIRST UP movement type.
  static const String VERT_FIRST_UP = "VERT_FIRST_UP";

  /// Constant representing the VERTICAL FIRST DOWN movement type.
  static const String VERT_FIRST_DOWN = "VERT_FIRST_DOWN";

  /// Constant representing the ON SIGHT movement type.
  static const String ON_SIGHT = "ON_SIGHT";

  /// Returns a list of a possible enemy movement types.
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