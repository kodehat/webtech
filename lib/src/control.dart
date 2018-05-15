part of mazegame;

class MazeGameController {

  MazeGameModel game = new MazeGameModel();

  MazeGameView view = new MazeGameView();

  MazeGameController() {
    // Listen to new level given into level-stream
    game.levelStream.listen(onStreamNewLevel);

    // Listen to mouse clicks on the overlay's close button
    view.overlayCloseButton.onClick.listen(onClickOverlayCloseButton);

    // Listen to mouse clicks on start button
    view.startButton.onClick.listen(onClickStartButton);
  }

  void onClickStartButton(MouseEvent e) {
    print("Start button clicked!");
    view.startButton.text = "Restart?!";
    view.tutorialButton.classes.toggle("invisible");
    querySelectorAll(".button-wrapper > .button:not([id='btn_start'])").classes.toggle("invisible", true);

    view.subtitle.classes.toggle("invisible");
    view.title.text = game.level.nameClean;
    view.progressbarContainer.classes.toggle("invisible");
    view.gameField.classes.toggle("invisible");

  }

  void onStreamNewLevel(Level level) {
    view.generateField(game);
  }

  void onClickOverlayCloseButton(MouseEvent e) {
    print("Overlay close button clicked!");
    view.closeOverlay();
  }

}