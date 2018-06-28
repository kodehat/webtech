part of mazegame;

/// The [MazeGameModel] class represents the game model.
/// It contains relevant information like the current level and the game-state.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class MazeGameModel {

  /// The current level.
  static Level _level;

  /// Number of the current level.
  int levelNumber;

  /// A reference to the rabbit in the level for quicker access.
  Rabbit _rabbit;

  /// A list of enemies in the current level for quicker access.
  List<Enemy> _enemies;

  // A list of speed power-ups in the current level for quicker access.
  List<Powerup> _speedPowerups;

  /// A symbol representing the state if the game.
  /// Possible values are #running for a running game and
  /// #stopped for a stopped game.
  Symbol _gamestate = #stopped;

  /// Creates a new [MazeGameModel] instance with an optional parameter,
  /// which sets the first [levelNumber]. This defaults to level number 1.
  MazeGameModel([this.levelNumber = 1]);

  /// Loads a level into the model by using the [LevelLoader] based on
  /// the current [levelNumber] attribute. Additionally reads and sets
  /// the [rabbit] and the [enemies] objects from the loaded level.
  Future loadCurrentLevel() async {

    // Don't load a level if the game is running.
    if (this.running) return;

    // Load the level into the model and wait for completion.
    _level = await LevelLoader.load(this.levelNumber);

    // Now set all required attributes in the model from the loaded level.
    this._rabbit = _level.findGameObjectExact(TileType.RABBIT);
    this._enemies = _level.findAllGameObjectsExact(TileType.FOX);
    this._speedPowerups = _level.findAllGameObjectsExact(TileType.SPEED_POWERUP);

    // Try to make all power-ups appear.
    _speedPowerups.forEach((final GameObject gameObject) {
      // Try to appear.
      (gameObject as CarrotPowerup).appear();
    });
  }

  /// Returns the currently loaded level.
  static Level get level => _level;

  /// Returns true if game is stopped, otherwise false.
  bool get stopped => _gamestate == #stopped;

  /// Returns true if game is running, otherwise false.
  bool get running => _gamestate == #running;

  /// Starts the game by setting the game-state to running.
  void start() => _gamestate = #running;

  /// Stops the game by setting the game-state to stopped.
  void stop() => _gamestate = #stopped;

  /// Returns the rabbit object (the player) in the current level.
  Rabbit get rabbit => this._rabbit;

  /// Returns a list of enemies (foxes) in the current level.
  List<Enemy> get enemies => this._enemies;

  /// Returns a list of power-ups in the current level.
  List<Powerup> get speedPowerups => this._speedPowerups;
}