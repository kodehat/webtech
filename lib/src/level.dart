part of mazegame;

class Level {

  String name;
  String nameClean;
  String description;
  int time;
  int possibleGoals;
  int rows;
  int cols;
  bool gameOver = false;
  bool done = false;
  List<List<GameObject>> objects;

}