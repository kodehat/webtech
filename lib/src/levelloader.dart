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
      ..tiles = _tilesFromMap(data["tiles"]);

    return level;
  }

  static List<Tile> _tilesFromMap(List<Map> data) {
    List<Tile> tiles = new List();
    data.forEach((p) {
      Tile tile = new Tile()
        ..position = _positionFromMap(p["position"])
        ..type = TileType.values.firstWhere((t) {
          print(t.toString());
          return t.toString().substring(t.toString().indexOf(".") + 1) == p["type"];
        });
      tiles.add(tile);
    });
    return tiles;
  }

  static Position _positionFromMap(Map data) => new Position.fromCoordinates(data["row"], data["col"]);

}