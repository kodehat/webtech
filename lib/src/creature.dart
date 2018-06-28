part of mazegame;

/// Abstract class representing a creature on the game field.
/// This includes the rabbit and the foxes.
/// It contains moving functionality and basic collision checking.
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
abstract class Creature extends GameObject {

  /// This attribute holds the game objects, which is below the [Creature]
  /// after moving. For instance a fox moves onto a goal field. This goal
  /// game object is now saved in this attribute until
  /// the fox moves away from it.
  /// Initial value is a terrain tile, which is below the [Creature].
  GameObject belowGameObject = new Terrain.fromCoordinates(0, 0);

  /// Saves the position prior moving.
  Position previousPosition;

  /// The direction of the [Creature] in which it's looking.
  String direction;

  /// Creates a new [Creature] with a given [type] and a position
  /// with a [row] and a [col] coordinate.
  Creature(final String type, final int row, final int col) :
        super(type, row, col);

  /// Updates the position of the [Creature] and the [belowGameObject].
  /// Doesn't handle collision checking! Only updates the positions!
  void _updatePositions(final int newRow, final int newCol) {
    // Move to the new position. The [belowGameObject] is updated implicitly.
    MazeGameModel._level.updateGameObjectAtRowAndCol(newRow, newCol, this);
  }

  GameObject move(String direction) {
    // Update the [Creature]'s direction.
    this.direction = direction;

    // Update the previous position.
    this.previousPosition = this.position;

    // Get the addends based on the given direction.
    List<int> addends = Direction.getRowAndColIndication(direction);

    // Calculate the new position.
    int newRow = super.position.row + addends[0];
    int newCol = super.position.col + addends[1];

    print("Creature (${this.type}) tries to move $direction at"
        ": $newRow, $newCol.");

    // The object the [Creature] collided with.
    GameObject collisionObj;

    // Try to get the game object at the new position.
    // On error (out of bounds of the game field), set it to a wall tile.
    try {
      collisionObj =
          MazeGameModel._level.getGameObjectAtRowAndCol(newRow, newCol)
              ?? new Wall.fromCoordinates(newRow, newCol);
    } on LevelObjectAccessOutOfBoundsException catch(_) {
      collisionObj = new Wall.fromCoordinates(newRow, newCol);
    }

    // Get the tile type of the collision game object.
    String collisionType = collisionObj.type;

    print("Creature (${this.type}) collides with ${collisionType}.");

    // Handle the collision based on tile type of the collision object.
    switch(collisionType) {
      case TileType.TERRAIN:
        onCollideWithTerrain(collisionObj, newRow, newCol);
        break;
      case TileType.HEDGE:
        onCollideWithHedge(collisionObj, newRow, newCol);
        break;
      case TileType.GOAL:
        onCollideWithGoal(collisionObj, newRow, newCol);
        break;
      case TileType.FOX:
        onCollideWithFox(collisionObj, newRow, newCol);
        break;
      case TileType.RABBIT:
        onCollideWithRabbit(collisionObj, newRow, newCol);
        break;
      case TileType.WALL:
        onCollideWithWall(collisionObj, newRow, newCol);
        break;
      default:
        throw new UnknownTileTypeException("The tile type of the collision"
            "object is unknown!");
    }

    //TODO: Is this really necessary? Maybe set method return type to "void".
    // Return the object, the [Creature] collidied with.
    return collisionObj;
  }

  /// Is called, if the [Creature] collides with a terrain tile.
  /// By default moves the creature. Can be overwritten.
  void onCollideWithTerrain(
      GameObject collisionObject,
      int newRow,
      int newCol) {
    // Update the position of all related game objects.
    _updatePositions(newRow, newCol);
  }

  /// Is called, if the [Creature] collides with a goal tile.
  /// Does nothing by default, should be overwritten.
  void onCollideWithGoal(GameObject collisionObject, int newRow, int newCol) {}

  /// Is called, if the [Creature] collides with a fox tile.
  /// Does nothing by default, should be overwritten.
  void onCollideWithFox(GameObject collisionObject, int newRow, int newCol) {}

  /// Is called, if the [Creature] collides with a rabbit tile.
  /// Does nothing by default, should be overwritten.
  void onCollideWithRabbit(GameObject collisionObject, int newRow, int newCol) {}

  /// Is called, if the [Creature] collides with a hedge tile.
  /// Does nothing by default, should be overwritten.
  void onCollideWithHedge(GameObject collisionObject, int newRow, int newCol) {}

  /// Is called, if the [Creature] collides with a wall tile.
  /// Does nothing by default, should be overwritten.
  void onCollideWithWall(GameObject collisionObject, int newRow, int newCol) {}
}

/// This class is meant as "Enum".
/// Represents the direction an object can move to.
/// These are LEFT, RIGHT, UP and DOWN.
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
class Direction {

  /// Constant representing the left direction.
  static const String LEFT = "LEFT";

  /// Constant representing the right direction.
  static const String RIGHT = "RIGHT";

  /// Constant representing the up direction.
  static const String UP = "UP";

  /// Constant representing the down direction.
  static const String DOWN = "DOWN";

  /// Based on the given direction, it returns an Array consisting of two
  /// values. The first describes the addend of the row coordinate
  /// the second one the addend of the column coordinate.
  /// Returns null, if the direction is unknown.
  static List<int> getRowAndColIndication(final String direction) {
    switch (direction) {
      case LEFT:
        return [0, -1];
      case RIGHT:
        return [0, 1];
      case UP:
        return [-1, 0];
      case DOWN:
        return [1, 0];
      default:
        return null;
    }
  }

  /// Returns a list of all possible directions.
  static List<String> get types => [
    LEFT,
    RIGHT,
    UP,
    DOWN,
  ];
}

/// This exception should be thrown, if a direction is requested/used,
/// which doesn't exist.
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
class UnknownDirectionException implements Exception {

  /// Message of the exception.
  String message;

  /// Creates a new [UnknownDirectionException] with a given [message].
  UnknownDirectionException(message);
}