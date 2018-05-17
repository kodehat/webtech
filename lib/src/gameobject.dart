part of mazegame;

abstract class GameObject {

  Position position;

  GameObject(int row, int col) {
    position = new Position.fromCoordinates(row, col);
  }

  GameObject.fromPosition(this.position);

  static String getType(GameObject go) {
    if (go is Tile) {
      return go.type;
    } else if(go is Rabbit) {
      return TileType.START;
    } else if (go is Fox) {
      return TileType.FOX;
    }
    return null;
  }
}