import 'dart:html';
import 'package:rabbitrun/mazegame.dart';

final HtmlElement startBtn = querySelector("#btn_start");
final HtmlElement tutorialBtn = querySelector("#btn_tutorial");
final HtmlElement aboutBtn = querySelector("#btn_about");

void main() {

  window.onLoad.listen((e) {
    print("Finished converting Dart to JS!");

    new MazeGameController();

    startBtn.text = "Start";
    startBtn.attributes.remove("disabled");
    tutorialBtn.classes.toggle("invisible");
    tutorialBtn.attributes.remove("disabled");
    aboutBtn.classes.toggle("invisible");
    aboutBtn.attributes.remove("disabled");
  });
}
