part of mazegame;

class MazeGameView {

  final miniInfo = querySelector("#mini_info");

  final overlay = querySelector("#overlay");

  final overlayTitle = querySelector("#overlay h2");

  final overlayDescription = querySelector("#overlay p");

  final title = querySelector("#title");

  final subtitle = querySelector("#subtitle");
  
  final progressbarTitle = querySelector("#progress .label");

  final progressbarContainer = querySelector("#progress");

  final progressbar = querySelector("#progressbar > div");

  final gameField = querySelector("#game_field");

  final gameTable = querySelector("#game");

  HtmlElement get startButton => querySelector("#btn_start");

  HtmlElement get tutorialButton => querySelector("#btn_tutorial");

  HtmlElement get aboutButton => querySelector("#btn_about");

  HtmlElement get overlayCloseButton => querySelector("#btn_close_modal");

  HtmlElement get overlayNextLevelButton => querySelector("#btn_next_level");

  List<List<HtmlElement>> fields;

  void update(MazeGameModel game, [bool timerOnly = false]) {
    if (timerOnly) {
      progressbarTitle.text = "${game.timeLeft} sec";
      int timeInPerc = ((game.timeLeft / game.level.time) * 100).floor();
      progressbar.style.width = "$timeInPerc%";
      querySelectorAll(".field").style.filter = "brightness(${max(timeInPerc, 15)}%)";
      return;
    }

    print("Update field!");

    // Update the field
    final level = game.level;
    for (int row = 0; row < level.rows; row++) {
      for (int col = 0; col < level.cols; col++) {
        final GameObject go = level.objects[row][col];
        String type = GameObject.getType(go);

        final td = fields[row][col];
        if (td != null) {
          td.classes.clear();
          td.classes.addAll(["field", type.toLowerCase()]);
        }
      }
    }
  }

  void generateField(MazeGameModel game) {
    final Level level = game.level;
    String table = "";

    print("Level rows: ${level.rows}, cols: ${level.cols}");
    for (int row = 0; row < level.rows; row++) {
      table += "<tr>";
      for (int col = 0; col < level.cols; col++) {
        final String pos = "field_${row}_${col}";
        final GameObject go = level.objects[row][col];
        String type = GameObject.getType(go);

        table += "<td id='$pos' class='field ${type.toLowerCase()}'></td>";
      }
      table += "</tr>";
    }

    gameTable.innerHtml = table;


    fields = new List<List<HtmlElement>>(level.rows);
    for (int row = 0; row < level.rows; row++) {
      fields[row] = [];
      for (int col = 0; col < level.cols; col++) {
        fields[row].add(querySelector("#field_${row}_${col}"));
      }
    }
  }

  closeOverlay() => overlay.classes.toggle("invisible", true);

}