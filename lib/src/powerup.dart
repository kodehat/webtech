part of mazegame;

/// An abstract class representing a power-up on the game field.
/// This tile has limited functionality.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
abstract class Powerup extends GameObject {

  /// The chance, that this power-up appears in the level.
  /// 1.0 equals 100% and 0.0 equals 0%.
  double appearChance;

  /// The time the power-up stays on the field before disappearing.
  int timeOnField;

  /// True if it may appear, false if not.
  bool mayAppear = false;

  /// True if already appeared, false if not.
  /// Defaults to false.
  bool hasAppeared = false;

  /// Indicated whether this power-up has been used.
  bool used = false;

  /// The countdown for the power-up until it disappears.
  Duration timeOnFieldCountdown;

  /// The timer for the power-up until it disappears.
  Timer timeOnFieldTimer;

  /// Creates a new powerup based on the given [type] and a position
  /// consisting of a [row] and a [col] coordinate.
  Powerup.fromCoordinates(
      final String type,
      final int row,
      final int col,
      this.appearChance,
      this.timeOnField) : super(type, row, col) {

    // Get a random value between 0.0 and 1.0.
    double randomValue = new Random().nextDouble();

    print("Powerup: Random value is $randomValue."
        " Appear chance is ${this.appearChance}.");

    // Check if the power-up may appear.
    if (randomValue <= this.appearChance) {
      print("Powerup $position will appear :)");
      this.mayAppear = true;
    }
  }

  /// Abstract method, which is called if an game object collides with the
  /// power-up. Game object type check should be done by the power-up.
  void applyOn(final GameObject target);

  /// Sets the power-up on the game field.
  void appear() {
    // Return, if the power-up may not appear.
    if (!this.mayAppear) return;

    // Power-up has appeared.
    this.hasAppeared = true;

    // Set countdown and timer objects.
    this.timeOnFieldCountdown = new Duration(seconds: this.timeOnField);
    this.timeOnFieldTimer = new Timer(this.timeOnFieldCountdown, disappear);

    print("Powerup $position has appeared!");

    // Create the power-up on the game field.
    MazeGameModel.level.updateGameObjectAtPosition(this.position, this);
  }

  /// Removes the power-up from the game field.
  void disappear() {
    print("Powerup $position disappeared!");
    MazeGameModel.level.updateGameObjectAtPosition(this.position,
      new Terrain.fromCoordinates(this.position.row, this.position.col));
  }
}

/// A power-up for the rabbit, which makes it faster.
/// It is represented by a carrot image.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class CarrotPowerup extends Powerup {

  // The speed increase of the power-up for the rabbit.
  final int _speedIncrease;

  /// Creates a new speed power-up.
  CarrotPowerup.fromCoordinates(
      int row,
      int col,
      double appearChance,
      int timeOnField,
      this._speedIncrease) :
        super.fromCoordinates(TileType.SPEED_POWERUP, row, col, appearChance, timeOnField);

  @override
  void applyOn(final GameObject target) {
    // Only usable by the rabbit. And only if not used yet.
    if (target.type == TileType.RABBIT && !used) {

      // Cancel the disappearing timer.
      this.timeOnFieldTimer.cancel();

      // Set used to true.
      this.used = true;

      // Disappear.
      this.disappear();

      // Increase the rabbit's speed by lowering the movement rate.
      (target as Rabbit).speed -= this._speedIncrease;

      print("Poweup $position applied on rabbit. New speed ${(target as Rabbit).speed}.");
    }
  }
}