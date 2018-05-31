part of mazegame;

class LevelLoader {

  static Future<Level> load(final int levelNo, final MazeGameModel game) async {
    final String path = "assets/lvl/$levelNo.json";

    var req = await HttpRequest.getString(path);
    Map data = JSON.decode(req);
    Level level = _levelFromMap(data, game);
    return level;
  }

  static Level _levelFromMap(final Map data, final MazeGameModel game) {
    Level level = new Level()
      ..name = data["name"]
      ..nameClean = data["nameClean"]
      ..description = data["description"]
      ..time = data["time"]
      ..possibleGoals = data["possibleGoals"]
      ..rows = data["rows"]
      ..cols = data["cols"]
      ..objects = _tilesFromMap(data["tiles"], data["possibleGoals"], data["rows"], data["cols"], game);

    return level;
  }

  static List<List<GameObject>> _tilesFromMap(List<Map> data, int possibleGoals, int rows, int cols, final MazeGameModel game) {
    List<List<GameObject>> objects = new Iterable.generate(rows, (row) {
      return new Iterable.generate(cols, (col) => null).toList();
    }).toList();

    data.forEach((t) {
      Position position = _positionFromMap(t["position"]);
      String type = t["type"];

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
        case TileType.START:
          Rabbit rabbit = new Rabbit(game, position.row, position.col);
          game.rabbit = rabbit;
          print("Found rabbit at: ${rabbit.position}");
          objects[position.row][position.col] = rabbit;
          break;
        case TileType.FOX:
          Fox fox = new Fox(game, position.row, position.col, t["movementType"]);
          game.enemies.add(fox);
          objects[position.row][position.col] = fox;
          break;
      }
    });
    _chooseRandomGoal(objects, possibleGoals);

    return objects;
  }

  static Position _positionFromMap(Map data) => new Position.fromCoordinates(data["row"], data["col"]);

  static void _chooseRandomGoal(List<List<GameObject>> objects, int possibleGoals) {
    bool hasGoalFound = false;
    int seenGoals = 0;
    var rnd = new Random();

    // Iterate through the entire field an find all possible goals.
    objects.forEach((go) => go.where((g) => g.type == TileType.GOAL).forEach((goal) {
    //objects.forEach((gl) => gl.where((g) => g is Tile).map((g) => g as Tile).where((t) => t.type == TileType.GOAL).forEach((goal) {
      if (!hasGoalFound && (seenGoals + 1) < possibleGoals) {
        if (rnd.nextInt(2) == 0) { // 50% chance
          hasGoalFound = true;
        } else {
          seenGoals++;
          goal.type = TileType.TERRAIN;
        }
      } else if (hasGoalFound) {
        goal.type = TileType.TERRAIN;
      } else if(!hasGoalFound && (seenGoals + 1) == possibleGoals) {
        hasGoalFound = true;
      }
    }));
  }

}