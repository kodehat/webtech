part of mazegame;

const levelCountdown = const Duration(seconds: 1);

class MazeGameController {

  MazeGameModel game = new MazeGameModel();

  MazeGameView view = new MazeGameView();

  Timer levelCountdownTrigger;

  MazeGameController() {
    // Listen to new level given into level-stream
    game.levelStream.listen(onStreamNewLevel);

    // Listen to mouse clicks on the overlay's close button
    view.overlayCloseButton.onClick.listen(onClickOverlayCloseButton);

    // Listen to mouse clicks on start button
    view.startButton.onClick.listen(onClickStartButton);
  }

  void onClickStartButton(MouseEvent e) {
    if (game.running) {

    } else {
      querySelectorAll(".button-wrapper > .button").classes.toggle("invisible", true);

      view.subtitle.text = "RUN!!!";
      view.title.text = game.level.nameClean;
      view.progressbarContainer.classes.toggle("invisible");
      view.gameField.classes.toggle("invisible");

      game.start();

      levelCountdownTrigger = new Timer.periodic(levelCountdown, (_) {
        game.timeLeft -= 1;
        view.update(game, true);
      });
    }
  }

  void onStreamNewLevel(Level level) {
    view.generateField(game);
  }

  void onClickOverlayCloseButton(MouseEvent e) {
    print("Overlay close button clicked!");
    view.closeOverlay();
  }

}