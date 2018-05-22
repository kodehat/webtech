part of mazegame;

class MazeGameModel {

  // Current level number
  int levelNo;

  // Current level
  Level _level;

  double timeLeft;

  Rabbit rabbit;

  Symbol _gamestate = #stopped;

  final StreamController<Level> _levelBroadCast = new StreamController<Level>();

  bool get stopped => _gamestate == #stopped;

  bool get running => _gamestate == #running;

  void start() => _gamestate = #running;

  void stop() => _gamestate = #stopped;

  MazeGameModel([this.levelNo = 1]);

  loadLevel(int levelNo) async {
    Level level = await LevelLoader.load(this.levelNo, this);
    this._level = level;

    timeLeft = level.time;

    _levelBroadCast.add(level);
  }

  Level get level => this._level;

  Stream<Level> get levelStream => _levelBroadCast.stream;

}