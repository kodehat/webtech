part of mazegame;

abstract class Creature extends GameObject {

  final MazeGameModel _game;

  Creature(MazeGameModel this._game, int row, int col) : super(row, col);

}

class Enemy {

}