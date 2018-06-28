part of mazegame;

/// Represents a fox on the game field.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class Fox extends Enemy {

  /// Creates a new fox game objects.
  Fox(int row, int col, String movementType) :
        super(TileType.FOX, row, col, movementType);
}