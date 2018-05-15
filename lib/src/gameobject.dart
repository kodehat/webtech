part of mazegame;

abstract class GameObject {

  Position position;

  GameObject(int row, int col) {
    position = new Position.fromCoordinates(row, col);
  }

  GameObject.fromPosition(this.position);

}