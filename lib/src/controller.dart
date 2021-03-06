part of mazegame;

/// Countdown how often the view is updated-
const viewUpdateCountdown =
const Duration(milliseconds: Constants.VIEW_UPDATE_COUNTDOWN);

/// Countdown how long the mini info is shown.
const miniInfoCountdown =
  const Duration(seconds: Constants.MINI_INFO_COUNTDOWN);

/// Represents the game controller.
/// Handles various input and touch events as well as mouse events.
///
/// => Authors: Bengt Claas Rhodgeß, Marc-Niclas Harm
class MazeGameController {

  /// The model instance.
  MazeGameModel game = new MazeGameModel();

  /// The view instance.
  MazeGameView view = new MazeGameView();

  /// The mobile sleep prevention instance.
  NoSleep noSleep = new NoSleep();

  /// The timer, when the view is updated.
  Timer _viewTimer;

  /// The timer, when the mini info is hidden.
  Timer _miniInfoTimer;

  /// Gamma orientation value of the mobile, saved for calibration.
  /// Used for LEFT, RIGHT movement.
  int _gammaOrientation;

  /// Gamma orientation, when the LEFT movement is done.
  int _gammaToggleLeft;

  /// Gamma orientation, when the RIGHT movement is done.
  int _gammaToggleRight;

  /// Beta orientation value of the mobile, saved for calibration.
  /// Used for UP, DOWN movement.
  int _betaOrientation;

  /// Beta orientation, when the UP movement is done.
  int _betaToggleUp;

  /// Beta orientation, when the DOWN movement is done.
  int _betaToggleDown;

  /// Boolean showing, if the mobile has been calibrated.
  bool _calibrated = false;

  /// The saved level number. Only used by the start and continue button.
  int savedLevelNumber;

  /// Creates a new [MazeGameController] instance.
  MazeGameController() {

    // Listen to mouse clicks on the continue button.
    view.continueButton.onClick.listen(onClickContinueButton);

    // Listen to mouse clicks on the start button.
    view.startButton.onClick.listen(onClickStartButton);

    // Listen to mouse clicks on the about button.
    view.aboutButton.onClick.listen((_) => view.showAboutOverlay());

    // Listen to mouse clicks on the tutorial button.
    view.tutorialButton.onClick.listen((_) => view.showTutorialOverlay());

    // Listen to mouse clicks on next level button.
    view.overlayNextLevelButton.onClick.listen(onClickOverlayNextLevel);

    // Listen to mouse clicks on menu button
    view.overlayMainMenuButton.onClick.listen(onClickOverlayMainMenuButton);

    // Listen to mouse clicks on the previous tutorial page button.
    view.overlayPreviousTutorialPageButton.onClick.listen((_) {
      view.decrementTutorialPage();
      view.showTutorialOverlay();
    });

    // Listen to mouse clicks on the next tutorial page button.
    view.overlayNextTutorialPageButton.onClick.listen((_) {
      view.incrementTutorialPage();
      view.showTutorialOverlay();
    });

    // Listen to 3D orientation movement of the mobile to move the rabbit.
    window.onDeviceOrientation.listen(handleMobileDeviceMovement);

    // Listen on touch events to recalibrate the movement on mobiles.
    window.onTouchEnd.listen(handleTouchOnGameScreen);

    // Listen to orientation changes to show the landscape warning.
    window.screen.orientation.onChange.listen(handleLandscapeOrientationChange);

    // Listen to keyboard events on PC to control the rabbit.
    window.onKeyDown.listen(handleKeyboardMovement);
  }

  /// Handles the movement via keyboard.
  /// Uses the arrow keys (LEFT, RIGHT, UP and DOWN).
  void handleKeyboardMovement(KeyboardEvent event) {

    // If game is stopped, return.
    if (game.stopped) return;

    if (this.game.rabbit.isAbleToMove && this.view.viewAnimationEnded) {
      // Switch all possible key codes (LEFT, RIGHT, UP, DOWN).
      switch (event.keyCode) {
        case KeyCode.LEFT:
          this._moveRabbit(Direction.LEFT);
          break;
        case KeyCode.RIGHT:
          this._moveRabbit(Direction.RIGHT);
          break;
        case KeyCode.UP:
          this._moveRabbit(Direction.UP);
          break;
        case KeyCode.DOWN:
          this._moveRabbit(Direction.DOWN);
      }
    }
  }

  /// Handles the movement on mobiles.
  /// Uses the orientation sensor of the mobile.
  void handleMobileDeviceMovement(DeviceOrientationEvent event) {

    // If the device doesn't support device orientation, return.
    if (event.beta == null || event.gamma == null) return;

    // Get the current beta value.
    final int beta = event.beta.toInt();
    // Get the current gamma value.
    final int gamma = event.gamma.toInt();

    // Calibrate until the game is calibrated and the game starts.
    if (!_calibrated) {

      // Update the saved calibrated values.
      _calibrate(gamma, beta);

      // Only calibrate if the game is not running.
      if (game.stopped || MazeGameModel.level.gameOver
          || MazeGameModel.level.done) {
        return;

        // Otherwise stop the calibration.
      } else {
        _calibrated = true;
      }
    }

    // Check the rabbit is able to move. Checks if the rabbit timer
    // has reset this boolean.
    if (this.game.rabbit.isAbleToMove && this.view.viewAnimationEnded) {

      // Move the rabbit UP.
      if (beta <= this._betaToggleUp) {
        this._moveRabbit(Direction.UP);

        // Move the rabbit down.
      } else if (beta >= this._betaToggleDown) {
        this._moveRabbit(Direction.DOWN);

        // Move the rabbit LEFT.
      } else if (gamma <= this._gammaToggleLeft) {
        this._moveRabbit(Direction.LEFT);

        // Move the rabbit RIGHT.
      } else if (gamma >= this._gammaToggleRight) {
          this._moveRabbit(Direction.RIGHT);
      }
    }
  }

  /// Re-calibrates the device toggle values, if the screen is touched while
  /// playing.
  void handleTouchOnGameScreen(TouchEvent event) {

    // Return, if the game is stopped.
    if (game.stopped) return;

    // Set mini info text.
    view.miniInfo.text = "Device orientation re-calibrated!";

    // Update the mini info timer.
    updateMiniInfoTimer();

    // Reset the calibration state.
    _calibrated = false;
  }

  /// Handles the change of the screen orientation and shows a warning in
  /// landscape mode.
  void handleLandscapeOrientationChange(final Event event) {
    // Get the current screen orientation.
    final String type = window.screen.orientation.type;

    // If type is landscape, show the landscape warning.
    if (type.contains("landscape")) {
      view.visible(view.landscapeWarning);

      // Otherwise if type is portrait, hide the landscape warning.
    } else if (type.contains("portrait")) {
      view.invisible(view.landscapeWarning);
    }
  }

  /// Handles the start of the game.
  /// Called by clicking on the start button in the main menu.
  void onClickStartButton(MouseEvent event) {

    // If the game is already running, return.
    if (game.running) return;

    // Toggle calibration state to calibrated.
    this._calibrated = true;

    // Enable the mobile screen sleep prevention.
    // Can only be activated by a user gesture (e.g. button click).
    this.noSleep.enable();
    // Request full-screen for the body HTML element.
    this.fullscreenWorkaround(querySelector("body"));

    // Needed to choose the right level,
    // after continuing a previous game and after that starting a new game.
    this.game.levelNumber = savedLevelNumber ?? 1;

    // Load and start the level.
    this._startLevel();
  }

  Future onClickOverlayNextLevel(MouseEvent event) async {
    // If the game is already running, return.
    if (game.running) return;

    // Close the overlay.
    view.closeOverlay();

    // Toggle calibration state to calibrated.
    this._calibrated = true;

    // Enable the mobile screen sleep prevention.
    // Can only be activated by a user gesture (e.g. button click).
    this.noSleep.enable();

    // Increase level number.
    this.game.levelNumber += 1;

    // Load and start the level.
    this._startLevel();
  }

  /// Called, if the main menu button in the overlay is clicked.
  void onClickOverlayMainMenuButton(MouseEvent event) {
    // Reset elements.
    view.resetToMainMenu();

    // Close the overlay.
    view.closeOverlay();
  }

  // Called, when the main menu continue button is clicked.
  void onClickContinueButton(MouseEvent event) {

    // Get the saved level number (can be null).
    this.savedLevelNumber = int.parse(window.localStorage['savedLevel']);

    // Call the start button's callback method.
    onClickStartButton(event);

    // Reset the saved level number reference.
    this.savedLevelNumber = null;
  }

  /// Sets or updates the mini info timer.
  /// The timer removes the text of the mini info.
  void updateMiniInfoTimer() {
    // If timer is null, create a new one.
    if (_miniInfoTimer == null) {
      _miniInfoTimer = new Timer(miniInfoCountdown, () => view.miniInfo.text = "");

      // Otherwise cancel the current one and then create a new one.
    } else {
      _miniInfoTimer.cancel();
      _miniInfoTimer = new Timer(miniInfoCountdown, () => view.miniInfo.text = "");
    }
  }

  /// Requests full-screen.
  /// Found on "Stack Overflow": https://stackoverflow.com/a/29715395
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

  Future _startLevel() async {
    // Set and show the loading text.
    view.loadingDiv.text = "Loading level ${this.game.levelNumber}...";
    view.visible(view.loadingDiv);

    // Set rabbit animation ended state to true.
    this.view.viewAnimationEnded = true;

    // Hide the main menu buttons.
    view.invisible(view.mainMenuButtonGroup);

    // Wait until the level is loaded.
    await this.game.loadCurrentLevel();

    // Generate the game field.
    view.generateGameField(MazeGameModel.level);

    // Update the title, subtitle progressbar and time.
    view.updateTitleAndSubtitle();
    view.updateTimerAndBrightness();

    // Start the level countdown.
    MazeGameModel.level.start();

    // Start rabbit (player) movement.
    this.game.rabbit.startTimer(this.game);

    // Start enemy movement
    this.game.enemies.forEach((final Enemy enemy) => enemy.startMoving(game));

    // Set the view update timer.
    this._viewTimer = new Timer.periodic(viewUpdateCountdown,
        _updateViewTrigger);

    // Start the game routine.
    game.start();

    // Hide the loading text.
    view.invisible(view.loadingDiv);

    // Show the progressbar and the game field.
    view.visible(view.progressbarContainer);
    view.visible(view.gameWrapper);
  }

  /// Trigger for the view update timer.
  /// Updates the view periodically.
  void _updateViewTrigger(Timer timer) {
    // Update all required elements.
    this.view.updateTitleAndSubtitle();
    this.view.updateTimerAndBrightness();
    this.game.speedPowerups.removeWhere((final Powerup powerup) => powerup.used || !powerup.mayAppear);
    this.view.updatePowerups(this.game);
    this.view.updateEnemies(this.game);

    // Check for game over or level done.
    if (MazeGameModel.level.gameOver
      || MazeGameModel.level.done) {
      // Stop the game.
      this.game.stop();

      // Stop all timers.
      this._viewTimer.cancel();
      MazeGameModel.level.stop();
      this.game.rabbit.stopTimer();
      this.game.enemies.forEach((final Enemy enemy) => enemy.stopMoving());
      this.game.speedPowerups.forEach((final Powerup powerup) => powerup.timeOnFieldTimer.cancel());

      // Reset the played level.
      LevelLoader.resetInCache(this.game.levelNumber);

      // Show the correct overlay.
      if (MazeGameModel.level.gameOver) {
        view.showGameOverOverlay(this.game.levelNumber);
      } else if (MazeGameModel.level.done) {
        // Save the level.
        window.localStorage['savedLevel'] =
            min(this.game.levelNumber + 1, Constants.MAX_LEVEL).toString();

        view.showLevelFinishedOverlay(MazeGameModel.level.timeLeft.floor(),
            this.game.levelNumber);
      }
    }
  }

  /// Moves the rabbit into the given [direction].
  void _moveRabbit(final String direction) {

    // Don't let the rabbit move again, until the rabbit timer has completed.
    this.game.rabbit.isAbleToMove = false;

    // Actually move the rabbit.
    GameObject collisionObject = this.game.rabbit.move(direction);

    // Skip animation, if collision with wall or hedge.
    if (collisionObject.type == TileType.WALL
      || collisionObject.type == TileType.HEDGE) {
      this.game.rabbit.isAbleToMove = true;
      view.updateRabbit(this.game.rabbit);
      return;
    }

    // Start the timer until it's allowed to move again.
    this.game.rabbit.startTimer(this.game);

    // Wait, while the rabbit animation is played.
    this.view.viewAnimationEnded = false;

    // Play rabbit's animation and update view after the animation.
    view.animateRabbit(this.game.rabbit, () {
      // Update rabbit in view.
      view.updateRabbit(this.game.rabbit);
      // Reset animation ended boolean.
      view.viewAnimationEnded = true;
    });
  }

  /// Sets the calibrated values based on the current values.
  void _calibrate(final int gamma, final int beta) {
    // Set the gamma values.
    this._gammaOrientation = gamma;
    this._gammaToggleLeft = this._gammaOrientation - Constants.DEVICE_MOTION_TOGGLE_HORIZONTAL;
    this._gammaToggleRight = this._gammaOrientation + Constants.DEVICE_MOTION_TOGGLE_HORIZONTAL;

    // Set the beta values.
    this._betaOrientation = beta;
    this._betaToggleUp = this._betaOrientation - Constants.DEVICE_MOTION_TOGGLE_VERTICAL;
    this._betaToggleDown = this._betaOrientation + Constants.DEVICE_MOTION_TOGGLE_VERTICAL;
  }
}