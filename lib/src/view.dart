part of mazegame;

class MazeGameView {

  final overlay = querySelector("#overlay");

  final overlayTitle = querySelector("#overlay h2");

  final overlayDescription = querySelector("#overlay p");

  final title = querySelector("title");

  final subtitle = querySelector("subtitle");
  
  final progressbarTitle = querySelector("#progress .label");

  final progressbar = querySelector("#progressbar > div");

  final gameField = querySelector("#game_field");

  final gameTable = querySelector("#game");

  HtmlElement get startButton => querySelector("#btn_start");

  HtmlElement get tutorialButton => querySelector("#btn_tutorial");

  HtmlElement get aboutButton => querySelector("#btn_about");

  HtmlElement get overlayCloseButton => querySelector("#btn_close_modal");

  List<List<HtmlElement>> fields;

  void update(MazeGameModel game) {

  }

  void generateField(MazeGameModel game) {
    final Level level = game.level;
    String table = "";

    print("Level rows: ${level.rows}, cols: ${level.cols}");
    for (int row = 0; row < level.rows; row++) {
      table += "<tr>";
      for (int col = 0; col < level.cols; col++) {
        final String pos = "field_${row}_${col}";
        final Tile tile = level.tiles.firstWhere((t) {
          return t.position.row == row && t.position.col == col;
        });

        table += "<td id='$pos' class='field ${tile.type.toLowerCase()}'></td>";
      }
      table += "</tr>";
    }

    gameTable.innerHtml = table;
  }

  closeOverlay() => overlay.classes.toggle("invisible", true);

}