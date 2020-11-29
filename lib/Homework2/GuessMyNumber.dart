import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess My Number',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Guess My Number'),
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

  int option, inputNumber, generatedNumber;
  String result, dialogTitle, buttonText = 'Guess';
  bool isEmpty = true, guessPressed = false, okPressed = false;
  TextEditingController nameHolder = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      generatedNumber = _generateRandomNumber();
    });
  }

  int _generateRandomNumber() {
    final Random random = Random();
    final int returned = random.nextInt(101) + 1;
    print(returned);
      return returned;
  }

  void _compareNumber(int inputNumber) {
    setState(() {
      if (isEmpty == false) {
        guessPressed = true;
        if (inputNumber < generatedNumber) {
          result = 'You tried ${inputNumber.toString()}.\n Go higher!' '';
        } else if (inputNumber > generatedNumber) {
          result = '''You tried ${inputNumber.toString()}.\n Go lower!''';
        } else {
          result =
              '''You tried ${inputNumber.toString()}.\n You guessed right!''';
        }
      }
      nameHolder.clear();
      isEmpty = true;
    });
  }

  void _tryAgain() {
    if(!okPressed) {
      Navigator.of(context).pop();
    }
    nameHolder.clear();
    setState(() {
      guessPressed = false;
      inputNumber = null;
      buttonText = 'Guess';
      okPressed = false;
    });
    generatedNumber = _generateRandomNumber();
  }

  void _ok() {
    Navigator.of(context).pop();
    setState(() {
      okPressed = true;
      buttonText = 'Reset';
    });
    nameHolder.clear();
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
            Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(children: const <Widget>[
                  Text(
                    'I\'m thinking of a number between 1 and 100.',
                    style: TextStyle(
                      fontSize: 24.0,
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ])),
            Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(children: <Widget>[
                  const Text(
                    'It\' s your turn to guess it!',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white60,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (guessPressed)
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Text(
                        result,
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                ])),
            Container(
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 230,
                        child: Card(
                          color: Colors.deepOrange[300],
                          semanticContainer: true,
                          child: Column(children: <Widget>[
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                child: const Text('Try a number:',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 22.0))),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Colors.white,
                                child: TextField(
                                    controller: nameHolder,
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.hdr_strong)),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
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
                                    })),
                            Container(
                                margin: const EdgeInsets.all(11.0),
                                child: SizedBox(
                                    width: 120.0,
                                    height: 50.0,
                                    child: FlatButton(
                                        onPressed: () {
                                          if (okPressed == true) {
                                            _tryAgain();
                                          } else {
                                            _compareNumber(inputNumber);
                                            if (generatedNumber == inputNumber) {
                                              showDialog<AlertDialog>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'You guessed right!',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .deepOrange)),
                                                      content: Row(
                                                          children: <Widget>[
                                                            Text(
                                                                'It was ${generatedNumber.toString()}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black))
                                                          ]),
                                                      actions: <Widget>[
                                                        FlatButton(
                                                            child: const Text(
                                                                'Try Again!'),
                                                            onPressed: () {
                                                              _tryAgain();
                                                            }),
                                                        FlatButton(
                                                            child: const Text(
                                                                'OK'),
                                                            onPressed: () {
                                                              _ok();
                                                            })
                                                      ],
                                                      backgroundColor:
                                                          Colors.white,
                                                    );
                                                  });
                                            }
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(23.0),
                                        ),
                                        color: Colors.red,
                                        textColor: Colors.white,
                                        splashColor: Colors.deepOrange[900],
                                        child: Container(
                                            margin: const EdgeInsets.all(4.0),
                                            child: Column(children: <Widget>[
                                              Text(buttonText,
                                                  style: const TextStyle(
                                                      fontSize: 16.0)),
                                              if (buttonText == 'Guess')
                                                const Icon(
                                                    FontAwesomeIcons.dice,
                                                    size: 16)
                                              else
                                                const Icon(Icons.sync, size: 16)
                                            ])))))
                          ]),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          elevation: 10,
                          margin: const EdgeInsets.all(15),
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
