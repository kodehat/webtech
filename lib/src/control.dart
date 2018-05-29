part of mazegame;

const levelCountdown = const Duration(milliseconds: 200);
const miniInfoDur = const Duration(seconds: 3);
const deviceMotionToggleValue = 22;

class MazeGameController {

  MazeGameModel game = new MazeGameModel();

  MazeGameView view = new MazeGameView();

  Timer levelCountdownTrigger;
  Timer miniInfoTrigger;

  int betaOrientation = null;
  int betaToggleUp = null;
  int betaToggleDown = null;

  int gammaOrientation = null;
  int gammaToggleLeft = null;
  int gammaToggleRight = null;

  bool calibrated = false;
  bool hasMoved = false;

  int savedLevelNo = null;

  MazeGameController() {
    // Listen to mouse clicks on the overlay's close button
    view.overlayCloseButton.onClick.listen(onClickOverlayCloseButton);

    // Listen to mouse clicks on next level button
    view.overlayNextLevelButton.onClick.listen(onClickOverlayNextLevel);

    // Listen to mouse clicks on start button
    view.startButton.onClick.listen(onClickStartButton);

    // Listen to mouse clicks on continue button
    view.continueButton.onClick.listen(onClickContinueButton);

    // If the device is oriented
    window.onDeviceOrientation.listen(onDeviceMove);

    window.onTouchEnd.listen(onTouchDisplay);

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

  void onTouchDisplay(TouchEvent e) {
    if (game.stopped) return;
    view.miniInfo.text = "Device orientation re-calibrated!";
    updateMiniInfo();
    calibrated = false;
    hasMoved = false;
  }

  void onDeviceMove(DeviceOrientationEvent e) {
    if (e.beta == null || e.gamma == null) return;

    final int beta = e.beta.toInt();
    final int gamma = e.gamma.toInt();

    if (!calibrated) {
      betaOrientation = beta;
      betaToggleUp = betaOrientation - deviceMotionToggleValue;
      betaToggleDown = betaOrientation + deviceMotionToggleValue;

      gammaOrientation = gamma;
      gammaToggleLeft = gammaOrientation - deviceMotionToggleValue;
      gammaToggleRight = gammaOrientation + deviceMotionToggleValue;

      if (game.stopped) {
        return;
      } else {
        calibrated = true;
      }
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
      // Adding a fixed value to prevent moving very fast at a certain position of the mobile.
      if (beta >= betaToggleUp + 2
          && beta <= betaToggleDown - 2
          && gamma >= gammaToggleLeft + 2
          && gamma <= gammaToggleRight - 2) {
        hasMoved = false;
      }
    }
  }

  onClickStartButton(MouseEvent e) async {
    if (game.running) return;
    //Needed to choose the right level, after continuing a previous game and after that starting a new game.
    game.levelNr = savedLevelNo ?? 1;
    await game.loadLevel(game.levelNo);

    view.generateField(game);

    querySelectorAll(".button-wrapper > .button").classes.toggle("invisible", true);

    view.subtitle.text = game.level.description;
    view.title.text = game.level.nameClean;
    view.progressbarContainer.classes.toggle("invisible");
    view.gameField.classes.toggle("invisible");

    game.start();

    calibrated = true;

    levelCountdownTrigger = new Timer.periodic(levelCountdown, (_) {
      if (game.level.done) {
        levelCountdownTrigger.cancel();
        return;
      }
      game.timeLeft -= 0.2;
      if (game.timeLeft.floor() <= 0) {
        game.level.gameOver = true;
        levelCountdownTrigger.cancel();
        game.stop();
      }
      view.update(game, true);
    });
  }

  void onClickContinueButton(MouseEvent e) {
    savedLevelNo = int.parse(game.local['level']);
    onClickStartButton(e);
  }

  void onClickOverlayCloseButton(MouseEvent e) {
    print("Overlay close button clicked!");
    view.closeOverlay();
  }

  Future onClickOverlayNextLevel(MouseEvent e) async {
    if (game.running || !game.level.done) return;
    view.closeOverlay();
    game.levelNo++;
    game.local['level'] = game.levelNo.toString();
    await game.loadLevel(game.levelNo);

    view.subtitle.text = game.level.description;
    view.title.text = game.level.nameClean;
    //view.progressbarTitle.text = "${game.level.time} sec";
    view.progressbar.style.width = "100%";

    game.start();

    calibrated = true;

    levelCountdownTrigger = new Timer.periodic(levelCountdown, (_) {
      if (game.level.done) {
        levelCountdownTrigger.cancel();
        return;
      }
      game.timeLeft -= 0.2;
      if (game.timeLeft.floor() <= 0) {
        game.level.gameOver = true;
        levelCountdownTrigger.cancel();
        game.stop();
      }
      view.update(game, true);
    });
  }

  void updateMiniInfo() {
    if (miniInfoTrigger == null) {
      miniInfoTrigger = new Timer(miniInfoDur, () => view.miniInfo.text = "");
    } else {
      miniInfoTrigger.cancel();
      miniInfoTrigger = new Timer(miniInfoDur, () => view.miniInfo.text = "");
    }
  }

}