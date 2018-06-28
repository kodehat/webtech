part of mazegame;

const miniInfoDur = const Duration(seconds: 3);

const deviceMotionToggleVerticalValue = 16;
const deviceMotionToggleHorizontalValue = 18;

/// Represents the game controller.
/// Handles various input and touch events as well as mouse events.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class MazeGameController {

  /// The model instance.
  MazeGameModel game = new MazeGameModel();

  /// The view instance.
  MazeGameView view = new MazeGameView();

  Timer miniInfoTrigger;
  Timer rabbitMoveTrigger;

  int betaOrientation = null;
  int betaToggleUp = null;
  int betaToggleDown = null;

  int gammaOrientation = null;
  int gammaToggleLeft = null;
  int gammaToggleRight = null;

  bool calibrated = false;
  bool hasMoved = false;

  int savedLevelNo = null;

  NoSleep noSleep = new NoSleep();

  /// Creates a new "Maze Game Controller" instance.
  MazeGameController() {
    // Listen to mouse clicks on the overlay's close button
    view.overlayCloseButton.onClick.listen(onClickOverlayCloseButton);

    // Listen to mouse clicks on next level button
    view.overlayNextLevelButton.onClick.listen(onClickOverlayNextLevel);

    // Listen to mouse clicks on menu button
    view.overlayMainMenuButton.onClick.listen(onClickOverlayMenuButton);

    // Listen to mouse clicks on start button
    view.startButton.onClick.listen(onClickStartButton);

    // Listen to mouse clicks on continue button
    view.continueButton.onClick.listen(onClickContinueButton);

    // If the device is oriented
    window.onDeviceOrientation.listen(onDeviceMove);

    view.title.onTouchEnd.listen(inDevAddTimeCheat);

    view.title.onMouseDown.listen(inDevAddTimeCheat);

    window.onTouchEnd.listen(onTouchDisplay);

    window.screen.orientation.onChange.listen(onOrientationChange);

    // Listen to keyboard to control the rabbit
    window.onKeyDown.listen((KeyboardEvent e) {
      if (game.stopped) return;
      switch (e.keyCode) {
        case KeyCode.LEFT:
          game._rabbit.moveLeft();
          querySelector(".rabbit").classes.toggle("rabbit-left");
          new Timer(rabbitMoveCountdown, () => view.update(game));
          //view.update(game);
          break;
        case KeyCode.RIGHT:
          game._rabbit.moveRight();
          querySelector(".rabbit").classes.toggle("rabbit-right");
          new Timer(rabbitMoveCountdown, () => view.update(game));
          //view.update(game);
          break;
        case KeyCode.UP:
          game._rabbit.moveUp();
          querySelector(".rabbit").classes.toggle("rabbit-up");
          new Timer(rabbitMoveCountdown, () => view.update(game));
          //view.update(game);
          break;
        case KeyCode.DOWN:
          game._rabbit.moveDown();
          querySelector(".rabbit").classes.toggle("rabbit-down");
          new Timer(rabbitMoveCountdown, () => view.update(game));
          //view.update(game);
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
      betaToggleUp = betaOrientation - deviceMotionToggleVerticalValue;
      betaToggleDown = betaOrientation + deviceMotionToggleVerticalValue;

      gammaOrientation = gamma;
      gammaToggleLeft = gammaOrientation - deviceMotionToggleHorizontalValue;
      gammaToggleRight = gammaOrientation + deviceMotionToggleHorizontalValue;

      if (game.stopped || game.level.gameOver || game.level.done) {
        return;
      } else {
        calibrated = true;
      }
    }

    if (!hasMoved) {
      if (beta <= betaToggleUp) { // Move UP
        game._rabbit.moveUp();
        querySelector(".rabbit").classes.toggle("rabbit-up");
        new Timer(rabbitMoveCountdown, () => view.update(game));
        //view.update(game);

        rabbitMoveTrigger = new Timer(rabbitMoveCountdown, resetRabbitMove);
        hasMoved = true;
      } else if(beta >= betaToggleDown){ //Move Down
        game._rabbit.moveDown();
        querySelector(".rabbit").classes.toggle("rabbit-down");
        new Timer(rabbitMoveCountdown, () => view.update(game));
        //view.update(game);

        rabbitMoveTrigger = new Timer(rabbitMoveCountdown, resetRabbitMove);
        hasMoved = true;
      } else if(gamma <= gammaToggleLeft) { //Move Left
        game._rabbit.moveLeft();
        querySelector(".rabbit").classes.toggle("rabbit-left");
        new Timer(rabbitMoveCountdown, () => view.update(game));
        //view.update(game);

        rabbitMoveTrigger = new Timer(rabbitMoveCountdown, resetRabbitMove);
        hasMoved = true;
      } else if(gamma >= gammaToggleRight) { //Move Right
        game._rabbit.moveRight();
        querySelector(".rabbit").classes.toggle("rabbit-right");
        new Timer(rabbitMoveCountdown, () => view.update(game));
        //view.update(game);

        rabbitMoveTrigger = new Timer(rabbitMoveCountdown, resetRabbitMove);
        hasMoved = true;
      }
    }
  }

  onClickStartButton(MouseEvent e) async {
    noSleep.enable();
    fullscreenWorkaround(querySelector("body"));

    if (game.running) return;
    //Needed to choose the right level, after continuing a previous game and after that starting a new game.
    game.levelNr = savedLevelNo ?? 1;
    await game.loadLevel(game.levelNumber);

    view.generateGameField(game);

    //querySelector(".button-group").classes.toggle("invisible", true);
    querySelectorAll(".button-wrapper > .button").classes.toggle("invisible", true);

    view.subtitle.text = game.level.description;
    view.title.text = game.level.name;
    view.progressbarContainer.classes.toggle("invisible");
    view.gameWrapper.classes.toggle("invisible");

    game.start();

    calibrated = true;

    levelCountdownTrigger = new Timer.periodic(levelCountdown, (_) {
      if (game.level.done || game.level.gameOver) {
        levelCountdownTrigger.cancel();
        enemyMoveTrigger.cancel();
        return;
      }
      game.level.timeLeft -= 0.2;
      if (game.level.timeLeft.floor() <= 0) {
        game.level.gameOver = true;
        levelCountdownTrigger.cancel();
        enemyMoveTrigger.cancel();
        game.stop();
      }
      view.update(game, true);
    });

    enemyMoveTrigger = new Timer.periodic(enemyMoveCountdown, (_) {
      game._enemies.forEach((e) => e.move());
      view.update(game);
    });
  }

  void onClickOverlayMenuButton(MouseEvent e) {
    game.stop();
    game._enemies.clear();
    game._rabbit = null;
    enemyMoveTrigger.cancel();
    querySelectorAll(".button-wrapper > .button").classes.toggle("invisible", false);

    view.closeOverlay();
    view.title.text = "RabbitRinth";
    view.subtitle.text = "Guide the rabbit through the maze to find its hole.";
    view.progressbarContainer.classes.toggle("invisible");
    view.gameWrapper.classes.toggle("invisible");
  }

  Future onClickContinueButton(MouseEvent e) async {
    savedLevelNo = int.parse(window.localStorage['savedLevel']);
    await onClickStartButton(e);
    savedLevelNo = null;
    print("Continue-Button clicked!");
  }

  void onClickOverlayCloseButton(MouseEvent e) {
    print("Overlay close button clicked!");
    view.closeOverlay();
  }

  Future onClickOverlayNextLevel(MouseEvent e) async {
    if (game.running || !game.level.done) return;
    game._enemies.clear();
    view.closeOverlay();
    game.levelNumber++;
    window.localStorage['savedLevel'] = game.levelNumber.toString();
    await game.loadLevel(game.levelNumber);

    view.generateGameField(game);

    view.title.text = game.level.name;
    view.subtitle.text = game.level.description;
    view.progressbar.style.width = "100%";

    game.start();

    calibrated = true;

    levelCountdownTrigger = new Timer.periodic(levelCountdown, (_) {
      if (game.level.done || game.level.gameOver) {
        levelCountdownTrigger.cancel();
        enemyMoveTrigger.cancel();
        return;
      }
      game.level.timeLeft -= 0.2;
      if (game.level.timeLeft.floor() <= 0) {
        game.level.gameOver = true;
        levelCountdownTrigger.cancel();
        enemyMoveTrigger.cancel();
        game.stop();
      }
      view.update(game, true);
    });

    enemyMoveTrigger = new Timer.periodic(enemyMoveCountdown, (_) {
      game._enemies.forEach((e) => e.move());
      view.update(game);
    });
  }

  void onOrientationChange(Event e) {
    String type = window.screen.orientation.type;

    if (type.contains("landscape")) {
      view.landscapeWarning.classes.toggle("invisible", false);
    } else if (type.contains("portrait")) {
      view.landscapeWarning.classes.toggle("invisible", true);
    }
  }

  void updateMiniInfo() {
    if (miniInfoTrigger == null) {
      miniInfoTrigger = new Timer(miniInfoDur, () => view.miniInfo.text = "");
    } else {
      miniInfoTrigger.cancel();
      miniInfoTrigger = new Timer(miniInfoDur, () => view.miniInfo.text = "");
    }
  }

  void resetRabbitMove() {
    hasMoved = false;
  }

  void fullscreenWorkaround(Element element) {
    var elem = new JsObject.fromBrowserObject(element);

    if (elem.hasProperty("requestFullscreen")) {
      elem.callMethod("requestFullscreen");
    }
    else {
      List<String> vendors = ['moz', 'webkit', 'ms', 'o'];
      for (String vendor in vendors) {
        String vendorFullscreen = "${vendor}RequestFullscreen";
        if (vendor == 'moz') {
          vendorFullscreen = "${vendor}RequestFullScreen";
        }
        if (elem.hasProperty(vendorFullscreen)) {
          elem.callMethod(vendorFullscreen);
          return;
        }
      }
    }
  }

  void inDevAddTimeCheat(Event e) {
    if (game.running) {
      game.level.timeTotal += 10.0;
      game.level.timeLeft += 10.0;
    }
  }
}