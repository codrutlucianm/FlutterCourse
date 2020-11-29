import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Currency Converter'),
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
  double initialSumEUR = 0;
  double convertedSumRON;
  bool emptyTextField = true;
  bool error = false;

  String request = 'https://api.exchangeratesapi.io/latest?symbols=RON';

  Future<Map> getData() async {
    final http.Response response = await http.get(request);
    return json.decode(response.body);
  }

  void _convertRONtoEUR(double EUR) {
    setState(() {
      if (emptyTextField) {
        convertedSumRON = 0;
        error = true;
      } else {
        convertedSumRON = initialSumEUR * EUR;
        error = false;
      }
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
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
        Image.network('https://www.valutx.com/image/img1.png'),
        Container(
            margin: const EdgeInsets.all(15.0),
            child: TextField(
                decoration: InputDecoration(
                    hintText: 'Enter sum in EUR',
                    hintStyle:
                        const TextStyle(fontSize: 14.0, color: Colors.white24),
                    errorText: error ? 'Enter a number' : null),
                style: const TextStyle(color: Colors.white60),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                ],
                onChanged: (String value) {
                  setState(() {
                    if (value.isEmpty) {
                      emptyTextField = true;
                    } else {
                      initialSumEUR = double.parse(value);
                      emptyTextField = false;
                    }
                  });
                })),
        Container(
            margin: const EdgeInsets.all(12.0),
            child: Column(children: <Widget>[
              SizedBox(
                  width: 120.0,
                  height: 50.0,
                  child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        return FlatButton(
                            onPressed: () {
                              _convertRONtoEUR(double.parse(
                                  snapshot.data['rates']['RON'].toString()));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23.0),
                            ),
                            color: Colors.blue,
                            textColor: Colors.white,
                            splashColor: Colors.blueGrey,
                            child: Row(
                              children: const <Widget>[
                                Icon(Icons.sync),
                                Text('Convert',
                                    style: TextStyle(fontSize: 16.0)),
                              ],
                            ));
                      }))
            ])),
        Text(
            convertedSumRON.toString() == 'null' || error
                ? ''
                : convertedSumRON.toString() + ' RON',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 24.0))
      ])),
    );
  }
}
