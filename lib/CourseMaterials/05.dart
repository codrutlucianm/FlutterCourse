import 'package:http/http.dart';

import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countries',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Countries'),
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
  final List<String> countries = <String>[];

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  Future<void> getCountries() async {
    final Response response = await get('https://worldometers.info/geography/flags-of-the-world/');
    final String data = response.body;
    final List<String> parts = data.split('<a href="/img/flags/').skip(1).toList();
    for (final String part in parts) {
      countries.add(part.split('10px">')[1].split('<')[0]);
    }
    setState(() {
      // countries changed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: countries.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 32.0,
                  crossAxisSpacing: 32.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Text(
                            countries.elementAt(index),
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Image.network('https://www.worldometers.info/img/flags/${countries[index]}')
                        ],
                      )
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
