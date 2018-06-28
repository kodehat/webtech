part of mazegame;

/// Represents a level in the game.
/// This class is created by the [LevelLoader], which
/// parses and handles level JSON files.
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
class Level {

  /// Name of the level. Shown as title in the game view.
  String name;

  /// Description of the level. Shown as subtitle in the game view.
  String description;

  /// Total time in seconds of the level, the player has to complete it.
  double timeTotal;

  /// The time left the player has to complete the level.
  double timeLeft;

  /// Amount of rows the game field has.
  int rows;

  /// Amount of columns the game field has.
  int cols;

  /// Represents the state, if the player has lost.
  bool gameOver = false;

  /// Represents the state, if the current level
  /// has been completed by the player.
  bool done = false;

  /// The list of lists representing the game field.
  List<List<GameObject>> objects;

  /// Returns true, if the given [row] and [col] coordinate are in the bounds
  /// of the game field.
  bool isInBounds(final int row, final int col) {
    return (row >= 0 && row < this.rows) && (col >= 0 && col < this.cols);
  }

  /// Returns the first game object from the game field matching the
  /// given [tileType]. Can be null if nothing is found.
  GameObject findGameObjectExact(final String tileType) {

    // The later returned matched game object.
    GameObject resultGameObject;

    // Search for a game object based on the given [tileType].
    this.objects.forEach((final List<GameObject> lgo) {
       resultGameObject = lgo.firstWhere((final GameObject go)
        => go.type == tileType);
    });

    // Return the (found) object (can be null).
    return resultGameObject;
  }

  /// Returns all game objects from the game field matching the
  /// given [tileType]. Can be null if nothing is found.
  List<GameObject> findAllGameObjectsExact(final String tileType) {

    // The later returned list of matching game objects.
    List<GameObject> resultGameObjects;

    // Search for all game object based on the given [tileType].
    this.objects.forEach((final List<GameObject> lgo) {
      resultGameObjects = lgo.where((final GameObject go)
        => go.type == tileType);
    });

    // Return the (found) objects (can be null).
    return resultGameObjects;
  }

  /// Returns the game object at the given [position].
  GameObject getGameObjectAtPosition(final Position position) {
    return getGameObjectAtRowAndCol(position.row, position.col);
  }

  /// Returns the game object at the given [row] and [col] coordinate.
  GameObject getGameObjectAtRowAndCol(final int row, final int col) {
    // Throw exception if [row] and [col] are out of bounds.
    if (!isInBounds(row, col)) {
      throw new LevelObjectAccessOutOfBoundsException("GameObject update failed"
          ", because the row ($row) or column ($col) coordinate is bigger than"
          "the boundaries of the level (${this.rows} x ${this.cols}!");
    }

    return this.objects[row][col];
  }

  /// Updates a game object at the given [position]. The game object, which
  /// was previously there is returned.
  void updateGameObjectAtPosition(
      final Position position,
      final GameObject gameObject) {
    updateGameObjectAtRowAndCol(position.row, position.col, gameObject);
  }

  /// Updates a game object at the given [row] and [col] coordinate.
  /// The game object, which was previously there is returned.
  void updateGameObjectAtRowAndCol(
      final int row,
      final int col,
      final GameObject gameObject) {

    // Throw exception if [row] and [col] are out of bounds.
    if (!isInBounds(row, col)) {
      throw new LevelObjectAccessOutOfBoundsException("GameObject update failed"
          ", because the row ($row) or column ($col) coordinate is bigger than"
          "the boundaries of the level (${this.rows} x ${this.cols}!");
    }

    // Save the object on the "old" position.
    GameObject oldGameObject = getGameObjectAtRowAndCol(row, col);

    // If the game object is a [Creature] (here rabbit or fox) handle the
    // game object, which is below the [Creature].
    if ((gameObject.type == TileType.RABBIT || gameObject.type == TileType.FOX)
        && (gameObject as Creature).belowGameObject != null) {

      // Save a reference of the below game object.
      GameObject belowObject = (gameObject as Creature).belowGameObject;

      // Update the position of the below object to the position
      // of the front object.
      belowObject.position = gameObject.position;

      // Insert the object in the game field.
      this.objects[gameObject.position.row][gameObject.position.col] =
          belowObject;

      // Set the below object to the "old" game object.
      (gameObject as Creature).belowGameObject = oldGameObject;
    }

    // Update the [gameObject] at the given position.
    this.objects[row][col] = gameObject;

    // Update position in the game object itself.
    gameObject.position = new Position.fromCoordinates(row, col);
  }
}

/// This exception should be thrown, if a game object in a level is being
/// accessed, but the row and column coordinate are out of bounds.
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
class LevelObjectAccessOutOfBoundsException implements Exception {

  /// Message of the exception.
  String message;

  /// Creates a new [LevelObjectAccessOutOfBoundsException] with
  /// a given message.
  LevelObjectAccessOutOfBoundsException(message);
}