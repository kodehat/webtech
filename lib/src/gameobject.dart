part of mazegame;

/// An abstract class representing an object living on thr game field.
/// Consists of a position and a type.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
abstract class GameObject {

  /// The game object's position on the game field.
  Position position;

  /// Its tile type.
  String _type;

  /// Creates a new game object with the given [type] and a
  /// position with the coordinates [row] and [col].
  GameObject(final this._type, final int row, final int col) {
    this.position = new Position.fromCoordinates(row, col);
  }

  /// Sets the type.
  ///
  /// => Throws an [UnknownTileTypeException] if the tile type is invalid.
  set type(String newType) {
    if (!TileType.types.contains(newType)) {
      throw new UnknownTileTypeException("The given tile type is unknown");
    }
    _type = newType;
  }

  /// Returns the type.
  String get type => _type;
}