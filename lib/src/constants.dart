part of mazegame;

/// This class contains the most relevant constants for the other classes.
/// They can be modified directly in here.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class Constants {

  /// The current amount of levels (starts at 1, 5 inclusive).
  static const int MAX_LEVEL = 5;

  /// The initial movement speed of the rabbit in milliseconds.
  static const int RABBIT_MOVEMENT_SPEED = 400;

  /// The initial movement speed of all enemies in milliseconds.
  static const int ENEMY_MOVEMENT_SPEED = 750;

  /// The value used to determine, when the game reacts to horizontal mobile
  /// device movement.
  static const int DEVICE_MOTION_TOGGLE_HORIZONTAL = 18;

  /// The value used to determine, when the game reacts to vertical mobile
  /// device movement.
  static const int DEVICE_MOTION_TOGGLE_VERTICAL = 16;

  /// The time in milliseconds the view is updated periodically.
  static const int VIEW_UPDATE_COUNTDOWN = 200;

  /// The duration in seconds the mini info is shown in the footer.
  static const int MINI_INFO_COUNTDOWN = 3;

}