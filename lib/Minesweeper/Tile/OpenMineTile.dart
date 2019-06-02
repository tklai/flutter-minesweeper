import 'package:flutter/cupertino.dart';

import '../Minesweeper.dart';
import '../Widget.dart';

class OpenMineTile extends StatelessWidget {
  final TileState state;
  final int count;

  OpenMineTile({this.state, this.count});

  final List textColor = [
    Color.fromARGB(255, 0, 0, 255),   // Blue
    Color.fromARGB(255, 0, 255, 0),   // Green
    Color.fromARGB(255, 255, 0, 0),   // Red
    Color.fromARGB(255, 128, 0, 128), // Purple
    Color.fromARGB(255, 0, 255, 255), // Cyan
    Color.fromARGB(255, 255, 191, 0), // Amber
    Color.fromARGB(255, 150, 75, 0),  // Brown
    Color.fromARGB(255, 0, 0, 0),     // Black
  ];

  @override
  Widget build(BuildContext context) {
    Widget text;
    if (state == TileState.open) {
      if (count != 0) {
        text = RichText(
          text: TextSpan(
            text: '$count',
            style: TextStyle(
              color: textColor[count - 1],
              fontWeight: FontWeight.bold,
              fontFamily: 'Press Start 2P',
            ),
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      text = RichText(
        text: TextSpan(
          text: '\u2739',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 0, 0),
            fontWeight: FontWeight.bold,
            fontFamily: 'Press Start 2P',
          ),
        ),
        textAlign: TextAlign.center,
      );
    }
    return buildTile(buildInnerTile(text));
  }
}