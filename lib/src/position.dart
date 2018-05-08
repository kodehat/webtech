part of mazegame;

class Position {

  int row;
  int col;

  Position();

  Position.fromCoordinates(this.row, this.col);

  String toString() {
    return "Pos{ row: $row, col: $col }";
  }
}