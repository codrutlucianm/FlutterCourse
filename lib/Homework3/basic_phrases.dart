import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Phrases',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Basic Phrases'),
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
  AudioPlayer audioPlayer = AudioPlayer();

  final List<String> _phrases = <String>[
    'Hallo! 👋',
    '¡Hola! 👋',
    'Wie geht\'s? 💬',
    '¿Cómo estás? 💬',
    'Ich bin hungrig. 🍔',
    'Tengo hambre. 🍔',
    'Ich habe Durst.🥤',
    'Estoy sediento.🥤',
    'Gehen wir ein Bier trinken!🍻',
    '¡Vamos a tener una cerveza!🍻',
  ];

  void _playSound(int index) {
    setState(() {
      switch (index) {
        case 0:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=Hallo&tl=de&total=1&idx=0&textlen=20');
          break;
        case 1:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=Hola&tl=es&total=1&idx=0&textlen=20');
          break;
        case 2:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=wie%20gehts&tl=de&total=1&idx=0&textlen=20');
          break;
        case 3:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=como%20estas&tl=es&total=1&idx=0&textlen=20');
          break;
        case 4:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=ich%20bin%20hungrig&tl=de&total=1&idx=0&textlen=20');
          break;
        case 5:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=tengo%20hambre&tl=es&total=1&idx=0&textlen=20');
          break;
        case 6:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=ich%20%20habe%20Durst&tl=de&total=1&idx=0&textlen=20');
          break;
        case 7:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=estoy%20sediento&tl=es&total=1&idx=0&textlen=20');
          break;
        case 8:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=gehen%20%20wir%20ein%20bier%20trinken&tl=de&total=1&idx=0&textlen=20');
          break;
        case 9:
          audioPlayer.play(
              'https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&q=vamos%20a%20tener%20una%20cerveza&tl=es&total=1&idx=0&textlen=20');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title + ' 🇩🇪 & 🇪🇸',
            style: GoogleFonts.lobster(fontSize: 28)),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Colors.red,
                      Colors.pink,
                      Colors.pink[700],
                      Colors.pink[900],
                      Colors.purple
                    ]),
                boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.pink[900].withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ])),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Material(
                    color: Colors.transparent,
                    child: Ink(
                        child: GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _phrases.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 32.0,
                              crossAxisSpacing: 32.0,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  _playSound(index);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: <Color>[
                                            Colors.red[900],
                                            Colors.pink[700],
                                          ]),
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _phrases.elementAt(index),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    )),
                              );
                            })))),
          ],
        ),
      ),
    );
  }
}
