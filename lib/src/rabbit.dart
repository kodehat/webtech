part of mazegame;

class Rabbit extends Creature {
  Rabbit(MazeGameModel game, int row, int col) : super(game, row, col);

  @override
  Tile self() {
    return _game.level.tiles.firstWhere((t) => t.type == TileType.START);
  }
}