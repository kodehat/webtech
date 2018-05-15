part of mazegame;

const levelCountdown = const Duration(seconds: 1);

class MazeGameController {

  MazeGameModel game = new MazeGameModel();

  MazeGameView view = new MazeGameView();

  Timer levelCountdownTrigger;

  int betaOrientation = null;
  int betaToggleUp = null;
  int betaToggleDown = null;

  int gammaOrientation = null;
  int gammaToggleLeft = null;
  int gammaToggleRight = null;

  bool hasMoved = false;

  MazeGameController() {
    // Listen to new level given into level-stream
    game.levelStream.listen(onStreamNewLevel);

    game.loadLevel(game.levelNo);

    // Listen to mouse clicks on the overlay's close button
    view.overlayCloseButton.onClick.listen(onClickOverlayCloseButton);

    // Listen to mouse clicks on start button
    view.startButton.onClick.listen(onClickStartButton);

    // If the device is oriented
    window.onDeviceOrientation.listen(onDeviceMove);

    // Listen to keyboard to control the rabbit
    window.onKeyDown.listen((KeyboardEvent e) {
      if (game.stopped) return;
      switch (e.keyCode) {
        case KeyCode.LEFT:
          game.rabbit.moveLeft();
          view.update(game);
          break;
        case KeyCode.RIGHT:
          game.rabbit.moveRight();
          view.update(game);
          break;
        case KeyCode.UP:
          game.rabbit.moveUp();
          view.update(game);
          break;
        case KeyCode.DOWN:
          game.rabbit.moveDown();
          view.update(game);
      }
    });
  }

  void onDeviceMove(DeviceOrientationEvent e) {
    if (e.beta == null || e.gamma == null) return;

    final int beta = e.beta.toInt();
    final int gamma = e.gamma.toInt();

    if (game.stopped) {
      betaOrientation = beta;
      betaToggleUp = betaOrientation - 20;
      betaToggleDown = betaOrientation + 20;

      gammaOrientation = gamma;
      gammaToggleLeft = gammaOrientation - 20;
      gammaToggleRight = gammaOrientation + 20;

      return;
    }

    if (!hasMoved) {
      if (beta <= betaToggleUp) { // Move UP
        game.rabbit.moveUp();
        view.update(game);

        hasMoved = true;
      }
      else if(beta >= betaToggleDown){ //Move Down
        game.rabbit.moveDown();
        view.update(game);

        hasMoved = true;
      }
      else if(gamma <= gammaToggleLeft) { //Move Left
        game.rabbit.moveLeft();
        view.update(game);

        hasMoved = true;
      }
      else if(gamma >= gammaToggleRight) { //Move Right
        game.rabbit.moveRight();
        view.update(game);

        hasMoved = true;
      }
    } else {
      if (beta >= betaToggleUp) {
        hasMoved = false;
      }
      else if(beta <= betaToggleDown) {
        hasMoved = false;
      }
      else if(gamma >= gammaToggleLeft) {
        hasMoved = false;
      }
      else {
        //hasMoved = false;
      }
    }
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