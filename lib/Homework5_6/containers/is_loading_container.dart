import 'package:flutter/widgets.dart';
import 'package:flutter_homework/Homework5_6/models/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/src/store.dart';

class IsLoadingContainer extends StatelessWidget {
  const IsLoadingContainer({Key key, @required this.builder}) : super(key: key);

  final ViewModelBuilder<bool> builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (Store<AppState> store) => store.state.isLoading,
      builder: builder,
    );
  }
}