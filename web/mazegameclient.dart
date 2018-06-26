import 'dart:html';
import 'package:rabbitrinth/mazegame.dart';

/// Main method instantiating the controller.
void main() {
  // Listener waiting for the completion of rewriting Dart to JavaScript.
  window.onLoad.listen((e) {
    print("Finished rewriting Dart to JS!");

    MazeGameController mgc = new MazeGameController();

    // Hide the loading text and make the main menu buttons visible.
    mgc.view.invisible(mgc.view.loadingDiv);
    mgc.view.visible(mgc.view.mainMenuButtonGroup);

    // Show the continue button if progress was saved in local storage.
    if (mgc.game.local.isNotEmpty) {
      mgc.view.visible(mgc.view.continueButton);
    }
  });
}
