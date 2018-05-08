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

  }

}