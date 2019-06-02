import 'package:flutter/cupertino.dart';

import '../Widget.dart';

class CoveredMineTile extends StatelessWidget {
  final bool flagged;
  final int positionX;
  final int positionY;

  CoveredMineTile({this.flagged, this.positionX, this.positionY});

  @override
  Widget build(BuildContext context) {
    Widget text;
    if (flagged) {
      text = buildInnerTile(RichText(
        text: TextSpan(
          text: "\u2691",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
      ));
    }

    Widget innerTile = Container(
      width: 20,
      height: 20,
      color: Color.fromARGB(255, 180, 180, 180),
      margin: EdgeInsets.all(2),
      padding: EdgeInsets.all(1),
      child: text,
    );
    return buildTile(innerTile);
  }
}