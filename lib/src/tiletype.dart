part of mazegame;

/// This class is meant as "Enum".
/// It represents all possible types of tiles.
/// Each tile type is represented by a static constant, whom name
/// is translated into a string equal to the name.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class TileType {

  /// Constant representing a hedge tile type.
  static const String HEDGE = "HEDGE";

  /// Constant representing a terrain (ground) tile type.
  static const String TERRAIN = "TERRAIN";

  /// Constant representing a goal tile type.
  static const String GOAL = "GOAL";

  /// Constant representing the rabbit (player) tile type.
  static const String RABBIT = "RABBIT";

  /// Constant representing a fox (enemy) tile type.
  static const String FOX = "FOX";

  /// Constant representing a wall tile. The tiles of thus type aren't visible,
  /// because they only describe the boundaries of the game field.
  static const String WALL = "WALL";

  /// Constant representing a speed power-up tile type.
  static const String SPEED_POWERUP = "SPEED_POWERUP";

  /// Returns a list of all possible tile types.
  static List<String> get types => [
    HEDGE,
    TERRAIN,
    GOAL,
    RABBIT,
    FOX,
    WALL,
    SPEED_POWERUP,
  ];
}

/// This exception should be thrown, if a tile type is requested/used,
/// which doesn't exist.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class UnknownTileTypeException implements Exception {

  /// Message of the exception.
  String message;

  /// Creates a new [UnknownTileTypeException] with a given [message].
  UnknownTileTypeException(message);
}