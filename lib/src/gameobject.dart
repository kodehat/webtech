part of mazegame;

abstract class GameObject {

  Position position;
  String _type;

  GameObject(this._type, int row, int col) {
    position = new Position.fromCoordinates(row, col);
  }

  GameObject.fromPosition(this.position);

  set type(String newType) {
    if (!TileType.types.contains(newType)) {
      throw new UnknownTileTypeException("The tile type $newType isn't a valid tile type!");
    }
    _type = newType;
  }

  String get type => _type;
}