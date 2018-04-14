import 'dart:html';

final HtmlElement startBtn = querySelector("#btn_start");
HtmlElement rabbit = querySelector("#field_7_0");

int row = 7;
int col = 0;

int betaOrientation = null;
int betaToggleUp = null;
int betaToggleDown = null;

int gammaOrientation = null;
int gammaToggleLeft = null;
int gammaToggleRight = null;

bool calibrated = false;
bool hasMoved = false;

void main() {
  generateGameField(8);

  startBtn.onClick.listen(onStartBtnClick);

  window.onDeviceOrientation.listen(onDeviceMove);
}

/// Generates the game field with the given size.
///
/// The [size] parameter defines the amount of
/// columns and rows.
void generateGameField(int size) {
  var game = querySelector("#game");
  String table = "";

  for (int row = 0; row < size; row++) {
    table += "<tr>";
    for (int col = 0; col < size; col++) {
      final pos = "field_${row}_${col}";
      var hedge = col % 2 == 0 ? " terrain" : " hedge";
      table += "<td id='$pos' class='field$hedge'></td>";
    }
    table += "</tr>";
  }

  game.innerHtml = table;
}

void onStartBtnClick(MouseEvent e) {
  print("Start button clicked!");
  startBtn.remove();

  rabbit.classes.toggle("rabbit");
  calibrated = true;
}

void onDeviceMove(DeviceOrientationEvent e) {
  if (e.alpha == null) return;

  final int beta = e.beta.toInt();
  final int gamma = e.gamma.toInt();

  if (!calibrated) {
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
     rabbit.classes.remove("rabbit");
     row -= 1;
     rabbit = querySelector("#field_${row}_${col}");
     rabbit.classes.add("rabbit");

     hasMoved = true;
    }
  } else {
    if (beta >= betaToggleUp) {
      hasMoved = false;
    }
  }
}
