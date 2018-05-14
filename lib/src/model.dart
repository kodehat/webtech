part of mazegame;

class MazeGameModel {

  // Current level number
   int _levelNo;

  // Current level
  Level _level;

  Symbol _gamestate;

  final StreamController<Level> _levelBroadCast = new StreamController<Level>();

  bool get stopped => _gamestate == #stopped;

  bool get running => _gamestate == #running;

  MazeGameModel([this._levelNo = 1]) {
    loadLevel(this._levelNo);
  }

  void loadLevel(int levelNo) {
    LevelLoader.load(this._levelNo, (Level level) {
      this._level = level;
      _levelBroadCast.add(level);
    });
  }

   Level get level => this._level;

  Stream<Level> get levelStream => _levelBroadCast.stream;

}