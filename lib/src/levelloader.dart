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
      ..description = data["description"]
      ..time = data["time"]
      ..rows = data["rows"]
      ..cols = data["cols"]
      ..objects = _tilesFromMap(data["tiles"], data["rows"], data["cols"], game);

    return level;
  }

  static List<List<GameObject>> _tilesFromMap(List<Map> data, int rows, int cols, final MazeGameModel game) {
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

  static Position _positionFromMap(Map data) => new Position.fromCoordinates(data["row"], data["col"]);

}