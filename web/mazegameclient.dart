import 'dart:html';
import 'package:rabbitrinth/mazegame.dart';

final HtmlElement startBtn = querySelector("#btn_start");
final HtmlElement continueBtn = querySelector("#btn_continue");
final HtmlElement tutorialBtn = querySelector("#btn_tutorial");
final HtmlElement aboutBtn = querySelector("#btn_about");

void main() {

  window.onLoad.listen((e) {
    print("Finished converting Dart to JS!");

   MazeGameController mgc = new MazeGameController();

    startBtn.text = "Start";
    startBtn.attributes.remove("disabled");
    if(mgc.game.local.isNotEmpty) continueBtn.classes.toggle("invisible");
    continueBtn.attributes.remove("disabled");
    tutorialBtn.classes.toggle("invisible");
    tutorialBtn.attributes.remove("disabled");
    aboutBtn.classes.toggle("invisible");
    aboutBtn.attributes.remove("disabled");
  });
}
