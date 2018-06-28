part of mazegame;

/// This class contains the most relevant constants for the other classes.
/// They can be modified directly in here.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class Constants {

  /// The current amount of levels (starts at 1, inclusive the value itself).
  static const int MAX_LEVEL = 7;

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

  /// The amount of available tutorial pages.
  static const int MAX_TUTORIAL_PAGES = 5;

  /// List of lists containing all tutorial messages with their headings.
  static const List<List<String>> TUTORIAL_MESSAGES = const [
    const [
      "1. Story",
        "You play as a rabbit"
        " <span><img src='assets/img/rabbit.png' alt='Rabbit'></span> "
        ", which is lost in the woods "
        " <span><img src='assets/img/hedge.png' alt='Hedge'></span> "
        ". You have to find your rabbit hole "
        " <span><img src='assets/img/goal.png' alt='Hole'></span> "
        ", before it's getting dark."
        " You may encounter foxes and power-ups on your way to the rabbit hole."],
    const [
      "2. Enemies and Power-Ups",
        "Don't get caught by foxes"
        " <span><img src='assets/img/fox.png' alt='Fox'></span> "
        ". They will kill you!<br><br>"
        "Collect carrots"
        " <span><img src='assets/img/speed_powerup.png' alt='Carrot'></span> "
        "to be faster for the rest of the level."],
    const [
      "3. Controls (For Mobile Phones)",
        "(Skip if desktop device)<br>"
        "Tilt your device carefully into the direction the rabbit should move."
        "To keep moving into the same direction, don't change the phones position.<br>"
        "Touch the game anywhere while playing to re-calibrate the tilt sensor."],
    const [
      "4. Controls (For Desktop Computer)",
        "(Skip if mobile device)<br>"
        "Use the arrow keys to move the rabbit around. You can only move in"
        " certain time intervals, so don't be confused, if the rabbit doesn't"
        " move immediately."],
    const [
      "5. Have Fun",
        "Now you known everything you need.<br>"
        "So let's go and <strong>play</strong>!"]
  ];
}