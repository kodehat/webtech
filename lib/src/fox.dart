part of mazegame;

class Fox extends Creature implements Enemy {
  Fox(MazeGameModel game, int row, int col) : super(game, row, col);

  @override
  Tile self() {
    return _game.level.tiles.firstWhere((t) => t.type == TileType.FOX);
  }
}