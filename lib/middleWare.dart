import 'AppState.dart';
import 'action.dart';
import 'package:redux/redux.dart';
import 'dart:async';

List<Middleware<AppState>> createMiddleWare() => [
      TypedMiddleware<AppState, SaveListAction>(_saveList),
    ];

Future _saveList(
    Store<AppState> store, SaveListAction action, NextDispatcher next) async {
  await Future.sync(() => Duration(seconds: 3));
  next(action);
}
