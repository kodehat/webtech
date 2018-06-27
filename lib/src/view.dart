part of mazegame;

class MazeGameView {

  final loadingDiv = querySelector(".loading");

  final miniInfo = querySelector("#mini_info");

  final overlay = querySelector("#overlay");

  final overlayTitle = querySelector("#overlay h2");

  final overlayDescription = querySelector("#overlay p");

  final title = querySelector("#title");

  final subtitle = querySelector("#subtitle");
  
  final progressbarTitle = querySelector("#progress .label");

  final progressbarContainer = querySelector("#progress");

  final progressbar = querySelector("#progressbar > div");

  final gameWrapper = querySelector("#game_wrapper");

  final gameTable = querySelector("#game");

  final landscapeWarning = querySelector("#landscape_warning");

  final mainMenuButtonGroup = querySelector(".button-group");

  HtmlElement get startButton => querySelector("#btn_start");

  HtmlElement get tutorialButton => querySelector("#btn_tutorial");

  HtmlElement get aboutButton => querySelector("#btn_about");

  HtmlElement get overlayCloseButton => querySelector("#btn_close_modal");

  HtmlElement get overlayNextLevelButton => querySelector("#btn_next_level");

  HtmlElement get overlayMainMenuButton => querySelector("#btn_main_menu");

  HtmlElement get continueButton => querySelector("#btn_continue");

  List<List<HtmlElement>> fields;

  void update(MazeGameModel game, [bool timerOnly = false]) {
    if (game.level.gameOver) {
      overlayTitle.text = "Game Over!";
      overlayDescription.innerHtml = "You reached level <strong>${game.levelNo}</strong>!";
      overlayMainMenuButton.classes.toggle("invisible", false);
      overlayNextLevelButton.classes.toggle("invisible", true);

      openOverlay();
    }

    if (game.level.done) {
        if (game.levelNo == LevelLoader.MAX_LEVEL) {
          overlayTitle.text = "Game Finished!";
          overlayDescription.innerHtml = "You completed level <strong>${game.levelNo}</strong> with <strong>${game.timeLeft.floor()}</strong> sec left!<br>Congratulations!<br>You finished the game!";
          overlayNextLevelButton.classes.toggle("invisible", true);
        } else {
          overlayTitle.text = "Level Completed!";
          overlayDescription.innerHtml = "You completed level <strong>${game.levelNo}</strong> with <strong>${game.timeLeft.floor()}</strong> sec left!";
          overlayNextLevelButton.classes.toggle("invisible", false);
        }
        openOverlay();
    }

    if (timerOnly) {
      progressbarTitle.text = "${game.timeLeft.floor()} sec";
      int timeInPerc = ((game.timeLeft / game.level.time) * 100).floor();
      progressbar.style.width = "$timeInPerc%";
      //querySelectorAll(".field:not(.rabbit)").style.filter = "brightness(${max(timeInPerc, 35)}%)";
      querySelectorAll(".table-cell div:not(.rabbit):not(.goal)").style.filter = "brightness(${max(timeInPerc, 35)}%)";
      querySelectorAll(".rabbit").style.filter = "brightness(${max(timeInPerc, 60)}%)";
      querySelectorAll(".goal").style.filter = "brightness(${max(timeInPerc, 60)}%)";
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
          //if (td.classes.contains(type.toLowerCase())) return;

          td.classes.clear();
          td.classes.addAll([type.toLowerCase()]);
        }
      }
    }
  }

  void generateField(MazeGameModel game) {
    final Level level = game.level;
    String table = "";

    print("Level rows: ${level.rows}, cols: ${level.cols}");
    for (int row = 0; row < level.rows; row++) {
      //table += "<tr>";
      table += "<div class='table-row'>";
      for (int col = 0; col < level.cols; col++) {
        final String pos = "field_${row}_${col}";
        final GameObject go = level.objects[row][col];
        String type = go.type;

        //table += "<td id='$pos' class='field ${type.toLowerCase()}'></td>"; "<div id='$pos' class='${type.toLowerCase()}'></div>"
        table +=
            "<div class='table-cell'>"
                "<div id='$pos' class='${type.toLowerCase()}'></div>"
                "<div class='field'></div>"
            "</div>";
      }
      table += "</div>";
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

  void _visibility(Element element, bool shouldAdd) {
    element.classes.toggle("invisible", shouldAdd);
  }

  void visible(Element element) {
    _visibility(element, false);
  }

  void invisible(Element element) {
    _visibility(element, true);
  }

  closeOverlay() => overlay.classes.toggle("invisible", true);
  openOverlay() => overlay.classes.toggle("invisible", false);

}