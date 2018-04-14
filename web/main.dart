import 'dart:html';

void main() {
  generateGameField(8);
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

      table += "<td id='$pos' class='field'>X</td>";
    }
    table += "</tr>";
  }

  game.innerHtml = table;
}
