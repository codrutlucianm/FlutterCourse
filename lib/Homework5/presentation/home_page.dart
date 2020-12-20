import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_homework/Homework5/containers/movies_container.dart';
import 'package:flutter_homework/Homework5/models/movie.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MoviesContainer(
      builder: (BuildContext context, List<Movie> movies) {
        return Scaffold(
          appBar: AppBar(),
          body: GridView.builder(
            padding: const EdgeInsets.all(8.0).copyWith(bottom: 56.0),
            itemCount: movies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Movie movie = movies[index];

              return GridTile(
                child: Image.network(movie.mediumCover),
                footer: GridTileBar(
                  title: Text(movie.title),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
