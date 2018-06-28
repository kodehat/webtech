part of mazegame;

/// Represents a position on the game field.
/// Consists of a row and a column coordinate.
/// This object is immutable!
///
/// => Authors: Claas Bengt Rhodgeß, Marc-Niclas Harm
class Position {

  /// The row coordinate.
  final int row;

  /// The column coordinate.
  final int col;

  /// Creates a new position object with the given coordinates.
  Position.fromCoordinates(final this.row, final this.col);

  String toString() {
    return "[Position{ row: $row, col: $col }]";
  }
}