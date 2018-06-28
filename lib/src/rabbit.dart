part of mazegame;

class Rabbit extends Creature {

  Rabbit(final int row, final int col) : super(TileType.RABBIT, row, col);

  @override
  void onCollideWithGoal(GameObject collisionObject, int newRow, int newCol) {
    //TODO: Update!
    //_game.level.done = true;
    //_game.stop();
  }

  @override
  void onCollideWithFox(GameObject collisionObject, int newRow, int newCol) {
    //TODO: Update!
    //_game.level.gameOver = true;
    // _game.stop();
  }

}