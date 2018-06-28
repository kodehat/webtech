part of mazegame;

/// Responsible for loading and caching level files,
/// which are itself written in JSON.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class LevelLoader {

  // Contains the pre-loaded levels mapped by their level number.
  static final Map<int, Level> CACHED_LEVELS = {};

  /// Async pre-loading of all levels as defined by [MAX_LEVEL].
  /// After functions returned, pre-loaded levels can be found in
  /// [CACHED_LEVELS] map.
  static Future preloadAllLevels() async {
    print("Pre-loading all ${Constants.MAX_LEVEL} levels...");
    final List<Future<Level>> futureLevels = [];

    // Start loading all levels.
    for (int i = 1; i <= Constants.MAX_LEVEL; i++) {
      futureLevels.add(load(i));
    }

    // Wait until all level have been loaded into the level cache.
    await Future.wait(futureLevels).then((levels) {
      // Load all loaded levels into the level cache.
      for (int i = 0; i < levels.length; i++) {
        CACHED_LEVELS[i + 1] = levels[i];
      }
    });
  }

  /// Resets the level with the given [levelNumber] in the level cache.
  /// Useful after a level has ended.
  static Future resetInCache(final int levelNumber) async {
    print("LevelLoader: Resetting level $levelNumber in cache.");

    // Wait, until the level has been loaded.
    Level level = await load(levelNumber, true);
    // Update level in level cache.
    CACHED_LEVELS[levelNumber] = level;
  }

  /// Async loading of a level with the given [levelNumber].
  /// After completion the level is returned as "Level" object.
  static Future<Level> load(final int levelNumber,
      [final bool ignoreCache = false]) async {

    print("Trying to load level $levelNumber...");

    if (!ignoreCache && CACHED_LEVELS.containsKey(levelNumber)) {
      print("Level $levelNumber is already loaded. Using cached version.");
      return CACHED_LEVELS[levelNumber];
    }

    print("Level $levelNumber isn't cached. Loading it now...");

    final String path = "assets/lvl/$levelNumber.json";
    final String jsonLevelStr = await HttpRequest.getString(path);
    final Map levelData = JSON.decode(jsonLevelStr);
    final Level level = _levelFromMap(levelData);

    return level;
  }

  /// Extracts the level from a specific map.
  static Level _levelFromMap(final Map data) {
    Level level = new Level()
      ..name = data["name"]
      ..description = data["description"]
      ..timeTotal = data["time"]
      ..timeLeft = data["time"]
      ..rows = data["rows"]
      ..cols = data["cols"]
      ..objects = _tilesFromMap(data["tiles"], data["rows"], data["cols"]);

    return level;
  }

  /// Extracts all level tiles from a specific map.
  static List<List<GameObject>> _tilesFromMap(
      final List<Map> data,
      final int rows,
      final int cols) {

    // A list of lists representing the game field.
    // The size is [rows] * [cols].
    List<List<GameObject>> objects = new Iterable.generate(rows, (row) {
      return new Iterable.generate(cols, (final col) => null).toList();
    }).toList();

    // Iterate each tile in map.
    data.forEach((final t) {
      final Position position = _positionFromMap(t["position"]);
      final String type = t["type"];

      switch (type) {
        case TileType.HEDGE:
          objects[position.row][position.col] =
            new Hedge.fromCoordinates(position.row, position.col);
          break;
        case TileType.TERRAIN:
          objects[position.row][position.col] =
            new Terrain.fromCoordinates(position.row, position.col);
          break;
        case TileType.GOAL:
          objects[position.row][position.col] =
            new Goal.fromCoordinates(position.row, position.col);
          break;
        case TileType.RABBIT:
          print("LevelLoader: Rabbit found at $position.");

          objects[position.row][position.col] =
            new Rabbit(position.row, position.col);
          break;
        case TileType.FOX:
          print("LevelLoader: Fox found at $position.");

          objects[position.row][position.col] =
            new Fox(position.row, position.col, t["enemyMovementType"]);
          break;
        default:
          throw new UnknownTileTypeException("The given tile type is unknown!");
      }
    });
    return objects;
  }

  // Extracts a position from a specific map.
  static Position _positionFromMap(final Map data) {
    return new Position.fromCoordinates(data["row"], data["col"]);
  }
}