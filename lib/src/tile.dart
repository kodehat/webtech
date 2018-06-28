part of mazegame;

/// An abstract class representing a tile on the game field.
/// This tile has limited functionality.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
abstract class Tile extends GameObject {

  /// Creates a new tile based on the given [type] and a position
  /// consisting of a [row] and a [col] coordinate.
  Tile.fromCoordinates(final String type, final int row, final int col) :
        super(type, row, col) {
    this.position = new Position.fromCoordinates(row, col);
  }

  String toString() {
    return "[Tile{ pos: $position, type: $type }]";
  }
}

/// Tile representing a hedge.
class Hedge extends Tile {

  /// => See superclass.
  Hedge.fromCoordinates(final int row, final int col) :
        super.fromCoordinates(TileType.HEDGE, row, col);
}

/// Tile representing a terrain (ground) tile.
class Terrain extends Tile {

  /// => See superclass.
  Terrain.fromCoordinates(final int row, final int col) :
        super.fromCoordinates(TileType.TERRAIN, row, col);
}

/// Tile representing a goal (here a rabbit hole).
class Goal extends Tile {

  /// => See superclass.
  Goal.fromCoordinates(final int row, final int col) :
        super.fromCoordinates(TileType.GOAL, row, col);
}

/// Tile representing a wall. This tile (type) can't be found in level files.
/// It's used for collision only, if a movable object tries to
/// leave the game field.
class Wall extends Tile {

  /// => See superclass.
  Wall.fromCoordinates(final int row, final int col) :
        super.fromCoordinates(TileType.WALL, row, col);
}