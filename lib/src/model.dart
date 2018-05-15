part of mazegame;

class MazeGameModel {

  // Current level number
   int _levelNo;

  // Current level
  Level _level;

  Rabbit rabbit;

  List<Enemy> enemies = new List<Enemy>();

  int timeLeft;

  Symbol _gamestate;

  final StreamController<Level> _levelBroadCast = new StreamController<Level>();

  bool get stopped => _gamestate == #stopped;

  bool get running => _gamestate == #running;

  void start() => _gamestate = #running;

  void stop() => _gamestate = #stopped;

  MazeGameModel([this._levelNo = 1]) {
    loadLevel(this._levelNo);
  }

  void loadLevel(int levelNo) {
    LevelLoader.load(this._levelNo, (Level level) {
      this._level = level;

      timeLeft = level.time;
      Position rabbitPos = level.tiles.firstWhere((t) => t.type == TileType.START).position;
      rabbit = new Rabbit(this, rabbitPos.row, rabbitPos.col);
      List<Tile> enemyTiles = level.tiles.where((t) => t.type == TileType.FOX);
      enemyTiles.forEach((et) => enemies.add(new Fox(this, et.position.row, et.position.col)));

      _levelBroadCast.add(level);
    });
  }

  Level get level => this._level;

  Stream<Level> get levelStream => _levelBroadCast.stream;

}