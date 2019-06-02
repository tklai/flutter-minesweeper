import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'Board.dart';

enum TileState { covered, blown, open, flagged, revealed }

class Minesweeper extends StatelessWidget {
  final String _title = "Minesweeper";
  final Board _board = Board();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return CupertinoApp(
      title: _title,
      home: _board,
    );
  }
}