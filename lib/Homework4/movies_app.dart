import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Movie {
  Movie(
      {@required this.id,
      @required this.title,
      @required this.year,
      @required this.runTime,
      @required this.rating,
      @required this.cover});

  factory Movie.fromJson(dynamic item) {
    return Movie(
      id: item['id'],
      title: item['title'],
      year: item['year'],
      runTime: item['runtime'],
      rating: item['rating'],
      cover: item['small_cover_image'],
    );
  }

  final int id;
  final String title;
  final int year;
  final int runTime;
  final num rating;
  final String cover;

  @override
  String toString() {
    return 'Movie{id: $id, title: $title, year: $year, runTime: $runTime, '
        'rating: $rating, cover: $cover}';
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoviesApp 🎬',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'MoviesApp 🎬'),
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
  List<Movie> _movies = <Movie>[];
  List<String> filterOptions = <String>[
    'Default',
    'Rating ↗️',
    'Rating ↘️',
    'Runtime ↗️',
    'Runtime ↘️',
    'Year ↗️',
    'Year ↘️',
  ];
  bool error = false, filtered = false;
  TextEditingController nameHolder = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _movies.clear();
    int pageNumber = 1;
    getMovies(1);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        pageNumber++;
        getMovies(pageNumber);
      }
    });
  }

  Future<void> getMovies(int pageNumber) async {
    final Response response = await get('https://yts.mx/api/v2/list_movies.json/?page=$pageNumber');
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final Map<String, dynamic> data = responseData['data'];
    final List<dynamic> movies = data['movies'];
    for (int i = 0; i < movies.length; i++) {
      final Map<String, dynamic> item = movies[i];
      final Movie movie = Movie(
        id: item['id'],
        title: item['title'],
        year: item['year'],
        runTime: item['runtime'],
        rating: item['rating'],
        cover: item['medium_cover_image'],
      );
      _movies.add(movie);
    }
    setState(() {
      // movies changed
    });
  }

  void sortItems(String value) {
    switch (value) {
      case 'Rating ↗️':
        _movies.sort((Movie first, Movie second) => first.rating.compareTo(second.rating));
        break;
      case 'Rating ↘️':
        _movies.sort((Movie first, Movie second) => second.rating.compareTo(first.rating));
        break;
      case 'Runtime ↗️':
        _movies.sort((Movie first, Movie second) => first.runTime.compareTo(second.runTime));
        break;
      case 'Runtime ↘️':
        _movies.sort((Movie first, Movie second) => second.runTime.compareTo(first.runTime));
        break;
      case 'Year ↗️':
        _movies.sort((Movie first, Movie second) => first.year.compareTo(second.year));
        break;
      case 'Year ↘️':
        _movies.sort((Movie first, Movie second) => second.year.compareTo(first.year));
        break;
      case 'Default':
        _movies.sort((Movie first, Movie second) => second.id.compareTo(first.id));
        break;
    }
  }

  void filter() {
    setState(() {
      if (nameHolder.text.isEmpty) {
        error = true;
      } else {
        _movies = _movies.where((Movie movie) => movie.year == int.parse(nameHolder.text)).toList();
        filtered = true;
        nameHolder.clear();
        error = false;
      }
    });
  }

  void resetFilter() {
    _movies.clear();
    getMovies(1);
    filtered = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.title, style: GoogleFonts.lobster(fontSize: 28)),
              DropdownButton<String>(
                  dropdownColor: Colors.black,
                  icon: const Icon(Icons.sort, color: Colors.black),
                  items: filterOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() {
                      sortItems(value);
                    });
                  })
            ],
          ),
          flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.amberAccent, Colors.amber, Colors.yellow]))),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Stack(children: <Widget>[
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Find a movie by year',
                hintStyle: const TextStyle(fontSize: 14.0, color: Colors.white54),
                errorText: error ? 'Enter a valid year' : null,
              ),
              controller: nameHolder,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
            ),
            Positioned(
              left: 340,
              child: IconButton(
                  onPressed: !filtered ? filter : resetFilter,
                  icon: !filtered ? const Icon(Icons.search) : const Icon(Icons.sync),
                  color: !filtered ? Colors.orange : Colors.blue),
            )
          ]),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        leading: Container(
                            height: 800.0,
                            width: 150.0,
                            child: Image.network('${_movies[index].cover}', fit: BoxFit.fitWidth)),
                        title: Text(
                          _movies[index].title,
                          style: const TextStyle(fontSize: 16.0, color: Colors.amber, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Year: ${_movies[index].year.toString()}, '
                            'Runtime: ${_movies[index].runTime.toString()}, '
                            'Rating ${_movies[index].rating.toString()}',
                            style: const TextStyle(fontSize: 16.0, color: Colors.white54)));
                  }))
        ]));
  }
}
