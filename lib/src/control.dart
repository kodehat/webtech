part of mazegame;

class MazeGameController {

  MazeGameController() {
    LevelLoader.load(1, (Level level) {
      print("Level name is: ${level.nameClean}");
      print(level.tiles);
    });
  }

}