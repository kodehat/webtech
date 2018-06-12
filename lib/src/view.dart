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

  final landscapeWarning = querySelector("#landscape_warning");

  HtmlElement get startButton => querySelector("#btn_start");

  HtmlElement get tutorialButton => querySelector("#btn_tutorial");

  HtmlElement get aboutButton => querySelector("#btn_about");

  HtmlElement get overlayCloseButton => querySelector("#btn_close_modal");

  HtmlElement get overlayNextLevelButton => querySelector("#btn_next_level");

  HtmlElement get overlayMainMenuButton => querySelector("#btn_main_menu");

  HtmlElement get continueButton => querySelector("#btn_continue");

  HtmlElement get fullscreenButton => querySelector("#btn_fullscreen");

  List<List<HtmlElement>> fields;

  void update(MazeGameModel game, [bool timerOnly = false]) {
    if (game.level.gameOver) {
      overlayTitle.text = "Game Over!";
      overlayDescription.innerHtml = "You reached level <strong>${game.levelNo}</strong>!";
      overlayMainMenuButton.classes.toggle("invisible", false);

      openOverlay();
    }

    if (game.level.done) {
      overlayTitle.text = "Level Completed!";
      overlayDescription.innerHtml = "You completed level <strong>${game.levelNo}</strong> with <strong>${game.timeLeft.floor()}</strong> sec left!";
      overlayNextLevelButton.classes.toggle("invisible", false);

      openOverlay();
    }

    if (timerOnly) {
      progressbarTitle.text = "${game.timeLeft.floor()} sec";
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
        String type = go.type;

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
        String type = go.type;

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
  openOverlay() => overlay.classes.toggle("invisible", false);

}