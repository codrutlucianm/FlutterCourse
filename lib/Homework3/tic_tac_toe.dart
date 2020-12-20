import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _listX = <int>[];
  List<int> _listO = <int>[];
  bool _isXsTurn = true, _gameOver = false, _tryAgainPressed = false;

  void _addToList(int index) {
    setState(() {
      _tryAgainPressed = false;
      if (!_gameOver && _placeMarked(index)) {
        if (_isXsTurn) {
          _listX.add(index);
          if (_listX.length == 5) {
            _gameOver = true;
          } else if (_checkWin(_listX) != null) {
            _gameOver = true;
            _listO.clear();
            _listX = _listX.where((int element) => _checkWin(_listX).contains(element)).toList();
          }
          _isXsTurn = false;
        } else {
          _listO.add(index);
          if (_checkWin(_listO) != null) {
            _gameOver = true;
            _listX.clear();
            _listO = _listO.where((int element) => _checkWin(_listO).contains(element)).toList();
          }
          _isXsTurn = true;
        }
      }
    });
  }

  void _tryAgain() {
    setState(() {
      _gameOver = false;
      _tryAgainPressed = true;
      _listX.clear();
      _listO.clear();
      _isXsTurn = true;
    });
  }

  bool _placeMarked(int index) {
    return !_listX.contains(index) && !_listO.contains(index);
  }

  List<int> _checkWin(List<int> _listIndexes) {
    final List<List<int>> _winningPositionsList = <List<int>>[
      <int>[0, 1, 2],
      <int>[3, 4, 5],
      <int>[6, 7, 8],
      <int>[0, 3, 6],
      <int>[1, 4, 7],
      <int>[2, 5, 8],
      <int>[0, 4, 8],
      <int>[2, 4, 6]
    ];
    for (final List<int> _winningPositions in _winningPositionsList) {
      if (_winningCombo(_listIndexes, _winningPositions)) {
        return _winningPositions;
      }
    }
    return null;
  }

  bool _winningCombo(List<int> _listIndexes, List<int> _indexes) {
    return _listIndexes.contains(_indexes.elementAt(0)) &&
        _listIndexes.contains(_indexes.elementAt(1)) &&
        _listIndexes.contains(_indexes.elementAt(2));
  }

  Border _determineBorder(int index) {
    Border determinedBorder = Border.all();
    const BorderSide _borderSide = BorderSide(width: 7, color: Colors.deepOrange);
    switch (index) {
      case 0:
        determinedBorder = const Border(bottom: _borderSide, right: _borderSide);
        break;
      case 1:
        determinedBorder = const Border(left: _borderSide, bottom: _borderSide, right: _borderSide);
        break;
      case 2:
        determinedBorder = const Border(left: _borderSide, bottom: _borderSide);
        break;
      case 3:
        determinedBorder = const Border(bottom: _borderSide, right: _borderSide, top: _borderSide);
        break;
      case 4:
        determinedBorder = const Border(left: _borderSide, bottom: _borderSide, right: _borderSide, top: _borderSide);
        break;
      case 5:
        determinedBorder = const Border(left: _borderSide, bottom: _borderSide, top: _borderSide);
        break;
      case 6:
        determinedBorder = const Border(right: _borderSide, top: _borderSide);
        break;
      case 7:
        determinedBorder = const Border(left: _borderSide, top: _borderSide, right: _borderSide);
        break;
      case 8:
        determinedBorder = const Border(left: _borderSide, top: _borderSide);
        break;
    }

    return determinedBorder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title, style: GoogleFonts.lobster(fontSize: 28)),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.red, Colors.deepOrange, Colors.amber]))),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  height: 400.0,
                  child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: 9,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () => _addToList(index),
                          child: Container(
                            decoration: BoxDecoration(
                              border: _determineBorder(index),
                            ),
                            child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: _tryAgainPressed
                                    ? const TextStyle(color: Colors.black)
                                    : _listX.contains(index)
                                        ? const TextStyle(
                                            color: Colors.amber,
                                            fontFamily: 'NerkoOne',
                                            fontSize: 100,
                                          )
                                        : _listO.contains(index)
                                            ? TextStyle(
                                                color: Colors.red[900],
                                                fontFamily: 'NerkoOne',
                                                fontSize: 100,
                                              )
                                            : const TextStyle(color: Colors.black),
                                child: _tryAgainPressed
                                    ? const Text('')
                                    : _listX.contains(index)
                                        ? const Text('X', textAlign: TextAlign.center)
                                        : _listO.contains(index)
                                            ? const Text('O', textAlign: TextAlign.center)
                                            : const Text('')),
                            //duration: const Duration(milliseconds: 350),
                          ),
                        );
                      })),
              if (_gameOver)
                Material(
                  color: Colors.transparent,
                  child: Ink(
                      width: 135.0,
                      height: 50.0,
                      child: FlatButton(
                          onPressed: _tryAgain,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(23.0),
                          ),
                          color: Colors.pink,
                          textColor: Colors.white,
                          splashColor: Colors.blueGrey,
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.sync),
                              Text('Try again', style: TextStyle(fontSize: 16.0), textAlign: TextAlign.center),
                            ],
                          ))),
                )
            ],
          ),
        ),
      ),
    );
  }
}
