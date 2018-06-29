part of mazegame;

/// Represents the game view.
/// Contains the relevant HTML elements in the browser
/// and the view-update-logic.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class MazeGameView {

  /// A warning element, which is shown, if the mobile is held in
  /// landscape mode.
  final landscapeWarning = querySelector("#landscape_warning");

  /// The loading div element shown on start of the game.
  final loadingDiv = querySelector(".loading");

  /// A little info box on the bottom of the screen (footer).
  final miniInfo = querySelector("#mini_info");

  /// The overlay element.
  final overlay = querySelector("#overlay");

  /// The heading of the overlay.
  final overlayTitle = querySelector("#overlay h2");

  /// The text inside of the overlay.
  final overlayDescription = querySelector("#overlay p");

  /// The title on top of the screen (header).
  final title = querySelector("#title");

  /// The subtitle below the [title].
  final subtitle = querySelector("#subtitle");

  /// The title of the progressbar.
  final progressbarTitle = querySelector("#progress .label");

  /// The container containing the progressbar.
  final progressbarContainer = querySelector("#progress");

  /// The progressbar itself.
  final progressbar = querySelector("#progressbar > div");

  /// The div around the game field.
  final gameWrapper = querySelector("#game_wrapper");

  /// The game field represented by a table.
  final gameTable = querySelector("#game");

  /// The div element around all main menu buttons.
  final mainMenuButtonGroup = querySelector(".button-group");

  /// Returns the start button.
  HtmlElement get startButton => querySelector("#btn_start");

  /// Returns the continue button.
  HtmlElement get continueButton => querySelector("#btn_continue");

  /// Returns the tutorial button.
  HtmlElement get tutorialButton => querySelector("#btn_tutorial");

  /// Returns the about button.
  HtmlElement get aboutButton => querySelector("#btn_about");

  /// Returns the next level button in the overlay.
  HtmlElement get overlayNextLevelButton => querySelector("#btn_next_level");

  /// Returns the main menu button in the overlay.
  HtmlElement get overlayMainMenuButton => querySelector("#btn_main_menu");

  /// Goes to the next tutorial page in the overlay.
  HtmlElement get overlayNextTutorialPageButton =>
      querySelector("#btn_next_page");

  /// Goes to the previous tutorial page in the overlay.
  HtmlElement get overlayPreviousTutorialPageButton =>
      querySelector("#btn_previous_page");

  /// A list of lists containing all game fields.
  List<List<HtmlElement>> fields;

  /// Represents the current tutorial page;
  int currentTutorialPage = 0;

  /// True, if the rabbit animation has finished. False, if not.
  bool viewAnimationEnded = true;

  /// Generates the game field in the browser based on the level game field.
  void generateGameField(final Level level) {
    String table = "";

    print("Generating level in browser. Rows: ${level.rows},"
        " Columns: ${level.cols}");

    // Iterate each row.
    for (int row = 0; row < level.rows; row++) {

      // Add the start HTML tag of the table row.
      table += "<div class='table-row'>";

      // Iterate each column.
      for (int col = 0; col < level.cols; col++) {

        // The position of the field. Set as id attribute.
        final String positionId = "field_${row}_${col}";

        // The game object at the current position.
        final GameObject gameObject = level.getGameObjectAtRowAndCol(row, col);

        // Add the game object as table cell to the table.
        table +=
        "<div class='table-cell'>"
            "<div id='$positionId' class='${gameObject.type.toLowerCase()}'></div>"
            "<div class='field'></div>"
        "</div>";
      }

      // At the close tag to the table row.
      table += "</div>";
    }

    // Set the game table in the DOM tree.
    gameTable.innerHtml = table;

    // Set the cache list to the size of rows.
    this.fields = new List<List<HtmlElement>>(level.rows);

    // Iterate each row.
    for (int row = 0; row < level.rows; row++) {

      // Create a new list in the row.
      this.fields[row] = [];

      // Iterate each column.
      for (int col = 0; col < level.cols; col++) {

        // Save each field in the cache list for quicker access
        // and to save some iteration time.
        this.fields[row].add(querySelector("#field_${row}_${col}"));
      }
    }
  }

  void updateRabbit(Rabbit rabbit) {
    //print("View: Updating rabbit!");

    _updateElementInGameFieldWithPosition(rabbit.position);
    _updateElementInGameFieldWithPosition(rabbit.belowGameObject.position);
    _updateElementInGameFieldWithPosition(rabbit.previousPosition);
  }

  /// Updates the positions of all enemies in the view.
  void updateEnemies(final MazeGameModel game) {
    //print("View: Updating all enemies!");

    // Iterate each enemy and update its position in view.
    game.enemies.forEach((final Enemy enemy) {
      _updateElementInGameFieldWithPosition(enemy.position);

      if (enemy.belowGameObject.position != null&&enemy.belowGameObject.type!=TileType.RABBIT) {
        _updateElementInGameFieldWithPosition(enemy.belowGameObject.position);
      }

      if (enemy.previousPosition != null&&MazeGameModel.level.getGameObjectAtPosition(enemy.previousPosition).type!=TileType.RABBIT) {
        _updateElementInGameFieldWithPosition(enemy.previousPosition);
      }
    });
  }

  // Updates the positions of all power-ups in the view.
  void updatePowerups(final MazeGameModel game) {

    // Iterate each power-up and update its position in view.
    game.speedPowerups.forEach((final Powerup powerup) {
      _updateElementInGameFieldWithPosition(powerup.position);
    });
  }

  ///TODO: Corrupts the rabbit's animation.
  /// Update all not living tiles in view. For instance hedge and terrain.
  void updateNotLivingTiles() {
    //print("View: Updating not living tiles!");

    // Level reference for quicker access.
    final level = MazeGameModel.level;

    // Iterate each row.
    for (int row = 0; row < level.rows; row++) {
      // Iterate each column.
      for (int col = 0; col < level.cols; col++) {

        // The current game object.
        final GameObject gameObject = level.getGameObjectAtRowAndCol(row, col);

        // Just update the tile if it's not a living tile.
        if (gameObject.type != TileType.RABBIT
            && gameObject.type != TileType.FOX) {
          _updateElementInGameField(row, col);
        }
      }
    }
  }

  /// Updates the title and the subtitle.
  void updateTitleAndSubtitle() {
    // Update the title and the subtitle.
    this.title.text = MazeGameModel.level.name;
    this.subtitle.text = MazeGameModel.level.description;
  }

  /// Updates the timer (the progressbar).
  void updateTimerAndBrightness() {
    //print("View: Updating timer and brightness!");

    // The time left in percent.
    int timeLeftInPercent =
      ((MazeGameModel.level.timeLeft / MazeGameModel.level.timeTotal) * 100)
          .floor();

    // Update progressbar title and width.
    this.progressbarTitle.text = "${MazeGameModel.level.timeLeft.floor()} sec";
    this.progressbar.style.width = "$timeLeftInPercent%";

    // Update progressbar color based on remaining time in percent.
    if (timeLeftInPercent < 15) {
      this.progressbar.style.backgroundColor = "#9e0404"; // Red tone.
    } else if (timeLeftInPercent < 40) {
      this.progressbar.style.backgroundColor = "#b1ad54"; // Yellow tone.
    } else {
      this.progressbar.style.backgroundColor = "#58B19F"; // Blue tone.
    }

    // Update the brightness of all required fields.

    // Rabbit only.
    querySelectorAll(".rabbit").style.filter =
    "brightness(${max(timeLeftInPercent, 60)}%)";

    // Goal only.
    querySelectorAll(".goal").style.filter =
    "brightness(${max(timeLeftInPercent, 60)}%)";

    // Everything, but rabbit and goal.
    querySelectorAll(".table-cell div:not(.rabbit):not(.goal)").style.filter =
      "brightness(${max(timeLeftInPercent, 35)}%)";
  }

  /// Shows the game over overlay with a given [levelReached].
  void showGameOverOverlay(final int levelReached) {

    // Set overlay heading and description.
    this.overlayTitle.text = "Game Over!";
    this.overlayDescription.innerHtml =
      "You reached level <strong>$levelReached</strong>!";

    // Make the overlay buttons visible/invisible.
    invisible(this.overlayNextLevelButton);
    visible(this.overlayMainMenuButton);

    // Open the overlay.
    this.openOverlay();
  }

  /// Shows the overlay after a level has been finished, this includes the
  /// game completed overlay screen.
  void showLevelFinishedOverlay(final int timeLeft, final int levelCompleted) {

    // Check if the game has been finished.
    if (levelCompleted != Constants.MAX_LEVEL) {
      // Set overlay heading and description.
      this.overlayTitle.text = "Level Completed!";
      this.overlayDescription.innerHtml =
      "You completed level <strong>$levelCompleted</strong>"
          " with <strong>$timeLeft</strong> sec left!";

      // Make the overlay buttons visible/invisible.
      visible(this.overlayMainMenuButton);
      visible(this.overlayNextLevelButton);
    } else {
      // Set overlay heading and description.
      overlayTitle.text = "Game Finished!";
      overlayDescription.innerHtml =
        "You completed level <strong>$levelCompleted</strong>"
            " with <strong>$timeLeft</strong> sec left!"
            "<br>Congratulations!<br>You finished the game!";

      // Make the overlay buttons visible/invisible.
      visible(this.overlayMainMenuButton);
      invisible(this.overlayNextLevelButton);
    }

    // Open the overlay.
    this.openOverlay();
  }

  /// Shows a current tutorial page in the overlay.
  void showTutorialOverlay() {
    print(this.currentTutorialPage);

    // Set title and description.
    this.overlayTitle.text =
        Constants.TUTORIAL_MESSAGES[this.currentTutorialPage][0];
    this.overlayDescription.innerHtml =
        Constants.TUTORIAL_MESSAGES[this.currentTutorialPage][1];

    // Ensure next level button is invisible.
    invisible(this.overlayNextLevelButton);

    // If not the last and the first tutorial page,
    // show next and previous button.
    if (this.currentTutorialPage != (Constants.MAX_TUTORIAL_PAGES - 1)
        && this.currentTutorialPage != 0) {
      visible(this.overlayPreviousTutorialPageButton);
      visible(this.overlayNextTutorialPageButton);
      invisible(this.overlayMainMenuButton);

      // If it's the first page, don't show the previous page button.
    } else if (this.currentTutorialPage == 0) {
      invisible(this.overlayPreviousTutorialPageButton);
      visible(this.overlayNextTutorialPageButton);
      invisible(this.overlayMainMenuButton);

      // Otherwise only show the previous page and the main menu button.
    } else {
      visible(this.overlayPreviousTutorialPageButton);
      invisible(this.overlayNextTutorialPageButton);
      visible(this.overlayMainMenuButton);
    }

    // Open the overlay.
    this.openOverlay();
  }

  /// Shows the about overlay, which contains some information about the game.
  void showAboutOverlay() {
    // Set title and description.
    this.overlayTitle.text = "About";
    this.overlayDescription.innerHtml = "This game was developed by<br>"
        "Bengt Claas Rhodgeß and Marc-Niclas Harm.<br><br>"
        "It was written in Dartlang for a web technologies project.<br>"
        "All graphics are painted by ourselves.";

    // Show main menu button.
    visible(this.overlayMainMenuButton);

    // Hide next level button.
    invisible(this.overlayNextLevelButton);

    // Open the overlay.
    this.openOverlay();
  }

  /// Updates a specific game object in the DOM game field
  /// with the given position.
  void _updateElementInGameFieldWithPosition(final Position position) {
    this._updateElementInGameField(position.row, position.col);
  }

  /// Updates a specific game object in the DOM game field.
  void _updateElementInGameField(final int row, final int col) {

    // Get the game object at the given position.
    final GameObject gameObject =
      MazeGameModel.level.getGameObjectAtRowAndCol(row, col);

    // Get the table cell element at the given position.
    final Element tableCell = this.fields[row][col];

    // Check if table cell exists.
    if (tableCell != null) {

      // Clear previous classes.
      tableCell.classes.clear();
      // Add new classes.
      tableCell.classes.addAll([gameObject.type.toLowerCase()]);
    }
  }

  /// Resets the title, the subtitle and the game containers to
  /// the initial state.
  void resetToMainMenu() {
    // Hide the progressbar.
    this.invisible(this.progressbarContainer);

    // Hide and clear the game field.
    this.invisible(this.gameWrapper);
    this.gameTable.innerHtml = "";

    // Show the main menu buttons.
    this.visible(this.mainMenuButtonGroup);

    // Show continue button, if progress has been saved.
    if (window.localStorage["savedLevel"] != null) {
      visible(this.continueButton);
    }

    // Reset the title and subtitle.
    this.title.text = "RabbitRinth";
    this.subtitle.innerHtml = "Guide the rabbit "
        "<span><img src='assets/img/rabbit.png' alt='Rabbit'></span>"
        " through the maze "
        "<span><img src='assets/img/hedge.png' alt='Hedge'></span>"
        " to find its hole "
        "<span><img src='assets/img/goal.png' alt='Hole'></span>"
        " .";

    // Hide the tutorial page buttons.
    invisible(this.overlayPreviousTutorialPageButton);
    invisible(this.overlayNextTutorialPageButton);

    // Reset the tutorial page.
    this.currentTutorialPage = 0;
  }

  /// Animates the rabbit based on its direction.
  void animateRabbit(Rabbit rabbit, Function afterAnimation) {

    // Get div table cell with the rabbit.
    final Element rabbitElement = querySelector(".rabbit");

    // Play animation based on rabbit's direction.
    switch(rabbit.direction) {
      case Direction.LEFT:
        rabbitElement.animate([
          {"transform": "translateX(0) translateY(0)"},
          {"transform": "translateX(${ -1 * (rabbitElement.clientWidth / 2)}px) translateY(${-1 * (rabbitElement.clientWidth * 10 / 100 * 2)}px)"},
          {"transform": "translateX(${ -1 * (rabbitElement.clientWidth)}px) translateY(0)"},
        ], rabbit.speed);
        break;
      case Direction.RIGHT:
        rabbitElement.animate([
          {"transform": "translateX(0) translateY(0)"},
          {"transform": "translateX(${rabbitElement.clientWidth / 2}px) translateY(${-1 * (rabbitElement.clientWidth * 10 / 100 * 2)}px)"},
          {"transform": "translateX(${rabbitElement.clientWidth}px) translateY(0)"},
        ], rabbit.speed);
        break;
      case Direction.UP:
        rabbitElement.animate([
          {"transform": "translateY(0)"},
          {"transform": "translateY(${-1 * (rabbitElement.clientWidth * 10 / 100 * 2)}px)"},
          {"transform": "translateY(${ -1 * (rabbitElement.clientWidth)}px)"},
        ], rabbit.speed);
        break;
      case Direction.DOWN:
        rabbitElement.animate([
          {"transform": "translateY(0)"},
          {"transform": "translateY(${rabbitElement.clientWidth * 10 / 100 * 2}px)"},
          {"transform": "translateY(${rabbitElement.clientWidth}px)"},
        ], rabbit.speed);
        break;
      default:
        throw new UnknownDirectionException("The direction of the rabbit"
            " is unknown.");
    }

    // Set the timer, which updates the view, when finished.
    new Timer(new Duration(milliseconds: rabbit.speed - 25),
        afterAnimation);
  }

  /// Increments the current tutorial page in a cyclic behavior.
  void incrementTutorialPage() {
    this.currentTutorialPage =
      (this.currentTutorialPage + 1) % Constants.MAX_TUTORIAL_PAGES;
  }

  /// Decrements the current tutorial page in a cyclic behavior.
  void decrementTutorialPage() {
    this.currentTutorialPage =
      (this.currentTutorialPage - 1) % Constants.MAX_TUTORIAL_PAGES;
  }

  /// Toggles the visibility of an element.
  void _visibility(Element element, bool shouldAdd) {
    element.classes.toggle("invisible", shouldAdd);
  }

  /// Makes the given [element] visible.
  void visible(Element element) {
    _visibility(element, false);
  }

  /// Makes the given [element] invisible.
  void invisible(Element element) {
    _visibility(element, true);
  }

  /// Closes the overlay.
  closeOverlay() => this.invisible(this.overlay);

  /// Opens the overlay.
  openOverlay() => this.visible(this.overlay);

}