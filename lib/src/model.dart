part of mazegame;

class MazeGameModel {

  // Local storage
  Storage local = window.localStorage;

  // Current level number
  int levelNo;

  // Current level
  Level _level;

  double timeLeft;

  Rabbit rabbit;

  Symbol _gamestate = #stopped;

  bool get stopped => _gamestate == #stopped;

  bool get running => _gamestate == #running;

  void start() => _gamestate = #running;

  void stop() => _gamestate = #stopped;

  MazeGameModel([this.levelNo = 1]);

  loadLevel(int levelNo) async {
    Level level = await LevelLoader.load(this.levelNo, this);
    this._level = level;

    timeLeft = level.time;
  }

  Level get level => this._level;

  set levelNr(int i) => levelNo = i;

}