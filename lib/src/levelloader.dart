part of mazegame;

/// Responsible for loading and caching level files,
/// which are itself written in JSON.
class LevelLoader {

  // Defines the level number of the last level in the game.
  static const int MAX_LEVEL = 5;

  // Contains the pre-loaded levels mapped by their level number.
  static final Map<int, Level> CACHED_LEVELS = {};

  /// Async pre-loading of all levels as defined by [MAX_LEVEL].
  /// After functions returned, pre-loaded levels can be found in
  /// [CACHED_LEVELS] map.
  static Future preloadAllLevels(final MazeGameModel game) async {
    print("Pre-loading all $MAX_LEVEL levels...");
    final List<Future<Level>> futureLevels = [];

    // Start loading all levels.
    for (int i = 1; i <= MAX_LEVEL; i++) {
      futureLevels.add(load(i, game));
    }

    // Wait until all level have been loaded into the level cache.
    await Future.wait(futureLevels).then((levels) {
      // Load all loaded levels into the level cache.
      for (int i = 0; i < levels.length; i++) {
        CACHED_LEVELS[i + 1] = levels[i];
      }
    });
  }

  /// Async loading of a level with the given [levelNo].
  /// After completion the level is returned as "Level" object.
  static Future<Level> load(final int levelNo, final MazeGameModel game) async {
    print("Trying to load level $levelNo...");

    if (CACHED_LEVELS.containsKey(levelNo)) {
      print("Level $levelNo is already loaded. Using cached version.");
      return CACHED_LEVELS[levelNo];
    }

    print("Level $levelNo isn't cached. Loading it now...");

    final String path = "assets/lvl/$levelNo.json";
    final String jsonLevelStr = await HttpRequest.getString(path);
    final Map levelData = JSON.decode(jsonLevelStr);
    final Level level = _levelFromMap(levelData, game);

    return level;
  }

  /// Extracts the level from a specific map.
  static Level _levelFromMap(final Map data, final MazeGameModel game) {
    Level level = new Level()
      ..name = data["name"]
      ..description = data["description"]
      ..time = data["time"]
      ..rows = data["rows"]
      ..cols = data["cols"]
      ..objects = _tilesFromMap(data["tiles"], data["rows"], data["cols"], game);

    return level;
  }

  /// Extracts all level tiles from a specific map.
  static List<List<GameObject>> _tilesFromMap(
      final List<Map> data,
      final int rows,
      final int cols,
      final MazeGameModel game) {

    // A list of lists representing the game field.
    // The size is [rows] * [cols].
    List<List<GameObject>> objects = new Iterable.generate(rows, (row) {
      return new Iterable.generate(cols, (col) => null).toList();
    }).toList();

    // Iterate each tile in map.
    data.forEach((t) {
      final Position position = _positionFromMap(t["position"]);
      final String type = t["type"];

      switch (type) {
        case TileType.HEDGE:
          objects[position.row][position.col] = new Hedge.fromCoordinates(position.row, position.col);
          break;
        case TileType.TERRAIN:
          objects[position.row][position.col] = new Terrain.fromCoordinates(position.row, position.col);
          break;
        case TileType.GOAL:
          objects[position.row][position.col] = new Goal.fromCoordinates(position.row, position.col);
          break;
        case TileType.RABBIT:
          Rabbit rabbit = new Rabbit(game, position.row, position.col);
          game.rabbit = rabbit;
          print("Found rabbit at: ${rabbit.position}");
          objects[position.row][position.col] = rabbit;
          break;
        case TileType.FOX:
          Fox fox = new Fox(game, position.row, position.col, t["enemyMovementType"]);
          print("Found fox at: ${fox.position} with movement type: ${fox.movementType}");
          game.enemies.add(fox);
          objects[position.row][position.col] = fox;
          break;
      }
    });
    return objects;
  }

  // Extracts a position from a specific map.
  static Position _positionFromMap(Map data) {
    return new Position.fromCoordinates(data["row"], data["col"]);
  }
}