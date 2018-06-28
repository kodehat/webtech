part of mazegame;

/// Represents the rabbit (the player) on the game field.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class Rabbit extends Creature {

  /// Represents the movement state of the rabbit.
  /// This is reset by the [moveTimer].
  bool isAbleToMove = true;

  /// Speed of the rabbit in milliseconds.
  /// Describes, when the rabbit tries to move.
  int _speed;

  /// The duration for the movement trigger.
  /// Speed is based on [speed] in milliseconds.
  Duration _moveCountdown;

  /// Timer, which does the movement of the rabbit.
  /// Uses the [_moveCountdown].
  Timer _moveTimer;

  /// Creates a new rabbit (player).
  Rabbit(final int row, final int col,
      [final this._speed = Constants.RABBIT_MOVEMENT_SPEED]) :
        super(TileType.RABBIT, row, col);

  @override
  void onCollideWithGoal(GameObject collisionObject, int newRow, int newCol) {
    MazeGameModel.level.done = true;;
  }

  @override
  void onCollideWithFox(GameObject collisionObject, int newRow, int newCol) {
    MazeGameModel.level.gameOver = true;
  }

  /// Starts the movement of the rabbit by starting the timer.
  void startTimer(final MazeGameModel game) {
    // Return, if already moving.
    if (this._moveTimer != null && this._moveTimer.isActive) return;

    // Create the countdown.
    this._moveCountdown = new Duration(milliseconds: this._speed);
    // Create the periodic timer and set the [_resetMovementState] method as callback.
    this._moveTimer =
      new Timer.periodic(this._moveCountdown, _resetMovementState);
  }

  /// Stops the movement of the rabbit by cancelling the timer.
  void stopTimer() {
    // Return, if not moving yet.
    if (!_moveTimer.isActive) return;

    // Stop the movement timer.
    this._moveTimer.cancel();
  }

  /// Resets the movement state of the rabbit.
  void _resetMovementState(Timer timer) => this.isAbleToMove = true;
}