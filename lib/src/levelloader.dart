part of mazegame;

class LevelLoader {

  static void load(final int levelNo, final Function callback) {
    final String path = "assets/lvl/$levelNo.json";
    final Level level = null;
    HttpRequest.getString(path).then((lvlJson) {
      Map data = JSON.decode(lvlJson);
      print(data["name"]);
      callback(level);
    });
  }

}