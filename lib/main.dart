import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'AppState.dart';
import 'reducer.dart';
import 'middleWare.dart';
import 'toDoList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(appReducer,
      initialState: AppState.initial(), middleware: createMiddleWare());

  @override
  Widget build(BuildContext context) => StoreProvider(
      store: this.store,
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: ToDoList(),
      ));
}
