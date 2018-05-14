part of mazegame;

class MazeGameController {

  MazeGameModel game = new MazeGameModel();

  MazeGameView view = new MazeGameView();

  MazeGameController() {
    game.levelStream.listen((Level level) {
      view.generateField(game);
    });

    // Listen to mouse clicks on the overlay's close button
    view.overlayCloseButton.onClick.listen((event) {
      print("Overlay close button clicked!");
      view.closeOverlay();
    });

    void onStartBtnClick(MouseEvent e) {
      print("Start button clicked!");
      view.startButton.remove();
      view.subtitle.classes.toggle("invisible");
      view.title.text = game.level.nameClean;
      view.progressbar.classes.toggle("invisible");
      view.gameField.classes.toggle("invisible");

     // rabbit.classes.toggle("rabbit");
     // rabbit.classes.remove("terrain");
     // calibrated = true;
    }

  }

}