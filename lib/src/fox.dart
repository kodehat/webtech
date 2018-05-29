part of mazegame;

class Fox extends Enemy {

  Fox(MazeGameModel game, int row, int col) : super(game, TileType.FOX, row, col);

  @override
  String getType() => TileType.FOX;

  @override
  void move() {
    // TODO: implement move
  }
}