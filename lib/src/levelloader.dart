part of mazegame;

class LevelLoader {

  static void load(final int levelNo, final Function callback) {
    final String path = "assets/lvl/$levelNo.json";

    HttpRequest.getString(path).then((lvlJson) {
      Map data = JSON.decode(lvlJson);
      Level level = _levelFromMap(data);
      callback(level);
    });
  }

  static Level _levelFromMap(Map data) {
    Level level = new Level()
      ..name = data["name"]
      ..nameClean = data["nameClean"]
      ..time = data["time"]
      ..possibleGoals = data["possibleGoals"]
      ..rows = data["rows"]
      ..cols = data["cols"]
      ..tiles = _tilesFromMap(data["tiles"], data["possibleGoals"]);

    return level;
  }

  static List<Tile> _tilesFromMap(List<Map> data, int possibleGoals) {
    List<Tile> tiles = new List();
    bool hasGoalFound = false;
    int seenGoals = 0;
    var rnd = new Random();

    data.forEach((p) {
      Tile tile = new Tile()
        ..position = _positionFromMap(p["position"])
        ..type = p["type"];

      if (tile.type == TileType.GOAL && !hasGoalFound && (seenGoals + 1) < possibleGoals) {
        print("Possible goal!");
        if (rnd.nextInt(4) >= 2) { // ~ 50% chance
          hasGoalFound = true;
        } else {
          seenGoals++;
          tile.type = TileType.TERRAIN;
        }
      } else if (tile.type == TileType.GOAL && hasGoalFound) {
        tile.type = TileType.TERRAIN;
      } else if (tile.type == TileType.GOAL && !hasGoalFound && (seenGoals + 1) == possibleGoals) {
        hasGoalFound = true;
      }

      tiles.add(tile);
    });
    return tiles;
  }

  static Position _positionFromMap(Map data) => new Position.fromCoordinates(data["row"], data["col"]);

}