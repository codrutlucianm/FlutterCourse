import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Shape',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Number Shape'),
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
  int inputNumber;
  String outputText;
  bool isEmpty = true;
  TextEditingController nameHolder = TextEditingController();
  String dialogTitle;

  bool _isSquare(int inputNumber) {
    for (int i = 0; i < inputNumber / 2; i++) {
      if (i * i == inputNumber) {
        return true;
      }
    }
    return false;
  }

  bool _isCube(int inputNumber) {
    for (int i = 0; i < inputNumber / 2; i++) {
      if (i * i * i == inputNumber) {
        return true;
      }
    }
    return false;
  }

  void _checkNumberShape() {
    setState(() {
      if (isEmpty) {
        outputText = 'Enter a number';
        dialogTitle = 'No number entered';
      } else if (inputNumber == 1) {
        outputText = 'Number $inputNumber is both a SQUARE and a CUBE';
      } else {
        if (_isSquare(inputNumber) && _isCube(inputNumber)) {
          outputText = 'Number $inputNumber is both a SQUARE and a CUBE';
        } else if (_isSquare(inputNumber)) {
          outputText = 'Number $inputNumber is a SQUARE';
        } else if (_isCube(inputNumber)) {
          outputText = 'Number $inputNumber is a CUBE';
        } else {
          outputText = 'Number $inputNumber is neither a SQUARE nor a CUBE';
        }
      }
      nameHolder.clear();
      isEmpty = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/Math.png'),
            Container(
                margin: const EdgeInsets.all(15.0),
                child: Column(children: <Widget>[
                  const Text('Enter a number:', style: TextStyle(fontSize: 22.0, color: Colors.white60)),
                  TextField(
                      controller: nameHolder,
                      style: const TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: '0', hintStyle: TextStyle(fontSize: 18.0, color: Colors.white54)),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter> [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (String value) {
                        setState(() {
                          if (value.isEmpty) {
                            isEmpty = true;
                          } else {
                            inputNumber = int.parse(value);
                            dialogTitle = value;
                            isEmpty = false;
                          }
                        });
                      })
                ])),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _checkNumberShape();
          showDialog<AlertDialog>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(dialogTitle, style: const TextStyle(color: Colors.teal)),
                  content: Text(outputText, style: const TextStyle(color: Colors.white54)),
                  backgroundColor: Colors.white24,
                );
              });
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
