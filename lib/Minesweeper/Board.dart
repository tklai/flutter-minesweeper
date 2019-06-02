import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'Minesweeper.dart';
import 'Tile/CoveredMineTile.dart';
import 'Tile/OpenMineTile.dart';

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  final int _rows = 10;
  final int _columns = 10;
  final int _numberOfMines = 10;

  List<List<TileState>> uiState;
  List<List<bool>> tiles;

  bool alive = true;
  bool wonGame = false;
  int minesFound = 0;
  Timer timer;
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    resetBoard();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void resetBoard() {
    alive = true;
    wonGame = false;
    minesFound = 0;
    stopwatch.stop();
    stopwatch.reset();

    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {});
    });

    uiState = new List<List<TileState>>.generate(_rows, (row) {
      return new List<TileState>.filled(_columns, TileState.covered);
    });

    tiles = new List<List<bool>>.generate(_rows, (row) {
      return new List<bool>.filled(_columns, false);
    });

    Random random = Random();
    int remainingMines = _numberOfMines;
    while (remainingMines > 0) {
      int position = random.nextInt(_rows * _columns);
      int row = position ~/ _rows;
      int column = position % _columns;

      if (! tiles[row][column]) {
        tiles[row][column] = true;
        remainingMines--;
      }
    }
  }

  Widget buildBoard() {
    bool hasCoveredCell = false;
    List<Row> boardRow = <Row>[];
    for (var y = 0; y < _rows; y++) {
      List<Widget> rowChildren = <Widget>[];
      for (var x = 0; x < _columns; x++) {
        TileState state = uiState[y][x];
        int count = mineCount(x, y);

        if (! alive) {
          if (state != TileState.blown) {
            state = tiles[y][x] ? TileState.revealed : state;
          }
        }

        if (state == TileState.covered || state == TileState.flagged) {
          rowChildren.add(GestureDetector(
            onLongPress: () {
              flag(x, y);
            },
            onTap: () {
              if (state == TileState.covered) probe(x, y);
            },
            child: Listener(
              child: CoveredMineTile(
                flagged: state == TileState.flagged,
                positionX: x,
                positionY: y,
              ),
            ),
          ));
          if (state == TileState.covered) {
            hasCoveredCell = true;
          }
        } else {
          rowChildren.add(OpenMineTile(
            state: state,
            count: count,
          ));
        }
      }
      boardRow.add(Row(
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.center,
        key: ValueKey<int>(y),
      ));
    }
    if (! hasCoveredCell) {
      if ((minesFound == _numberOfMines) && alive) {
        timer.cancel();
        stopwatch.stop();
        _showDialog('You have won!', 'Congratulations');
      }
    }
    return Container(
      color: Color.fromARGB(255, 175, 175, 175),
      padding: EdgeInsets.all(10),
      child: Column(
        children: boardRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int timeElapsed = stopwatch.elapsedMilliseconds ~/ 1000;
    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(255, 175, 175, 175),
      navigationBar: CupertinoNavigationBar(
        middle: Text("Minesweeper"),
        trailing: CupertinoButton(
          child: Icon(CupertinoIcons.refresh),
          padding: EdgeInsets.all(0),
          onPressed: () => resetBoard(),
        ),
      ),
      child: SafeArea(
        // minimum: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
              Container(
                color: Color.fromARGB(255, 175, 175, 175),
                height: 40,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Mines Found: $minesFound',
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Total Mines: $_numberOfMines",
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: '$timeElapsed seconds',
                      ),
                    ),
                  ],
                ),
              ),
            Center(
              child: buildBoard(),
            ),
          ],
        ),
      ),
    );
  }

  void probe(int x, int y) {
    if (! alive) return;
    if (uiState[y][x] == TileState.flagged) return;
    setState(() {
      if (tiles[y][x]) {
        uiState[y][x] = TileState.blown;
        alive = false;
        timer.cancel();
        stopwatch.stop();
        _showDialog('Boom!', 'You have lost! Please try again.');
      } else {
        open(x, y);
        if (! stopwatch.isRunning) stopwatch.start();
      }
    });
  }

  void open(int x, int y) {
    if (! inBoard(x,y )) return;
    if (uiState[y][x] == TileState.open) return;
    uiState[y][x] = TileState.open;

    if (mineCount(x, y) > 0) return;

    open(x - 1, y);
    open(x + 1, y);
    open(x, y - 1);
    open(x, y + 1);
    open(x - 1, y - 1);
    open(x + 1, y + 1);
    open(x - 1, y + 1);
    open(x + 1, y - 1);
  }

  void flag(int x, int y) {
    if (! alive) return;
    setState(() {
      if (uiState[y][x] == TileState.flagged) {
        uiState[y][x] = TileState.covered;
        --minesFound;
      } else {
        uiState[y][x] = TileState.flagged;
        ++minesFound;
      }
    });
  }

  int mineCount(int x, int y) {
    int count = 0;
    count += mines(x - 1, y);
    count += mines(x + 1, y);
    count += mines(x, y - 1);
    count += mines(x, y + 1);
    count += mines(x - 1, y - 1);
    count += mines(x + 1, y + 1);
    count += mines(x - 1, y + 1);
    count += mines(x + 1, y - 1);
    return count;
  }

  int mines(int x, int y) {
    return inBoard(x, y) && tiles[y][x] ? 1 : 0;
  }

  bool inBoard(int x, int y) {
    return
      x >= 0
      && y >= 0
      && x < _columns
      && y < _rows;
  }

  void _showDialog(_title, _text) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(_title),
          content: new Text(_text),
          actions: <Widget>[
            new CupertinoDialogAction(
              child: new Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}