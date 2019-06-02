import 'package:flutter/cupertino.dart';

Widget buildTile(Widget child) {
  return Container(
    width: 30,
    height: 30,
    color: Color.fromARGB(255, 125, 125, 125),
    margin: EdgeInsets.all(2),
    child: child,
  );
}

Widget buildInnerTile(Widget child) {
  return Container(
    width: 25,
    height: 25,
    alignment: Alignment.center,
    child: child,
  );
}