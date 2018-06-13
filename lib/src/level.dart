part of mazegame;

class Level {

  String name;
  String description;
  double time;
  int rows;
  int cols;
  bool gameOver = false;
  bool done = false;
  List<List<GameObject>> objects;

}