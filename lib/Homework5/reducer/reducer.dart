import 'package:flutter_homework/Homework5/actions/get_movies.dart';
import 'package:flutter_homework/Homework5/models/app_state.dart';

AppState reducer(AppState state, dynamic action) {
  if (action is GetMoviesSuccessful) {
    final AppStateBuilder builder = state.toBuilder();
    builder.movies.addAll(action.movies);
    return builder.build();
  }

  return state;
}
