part of mazegame;

class Fox extends Enemy {

  Fox(MazeGameModel game, int row, int col, String movementType) : super(game, TileType.FOX, row, col, movementType);
}