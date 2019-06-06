import 'package:redux/redux.dart';
import 'to_do_item.dart';

class AppState {
  final List<ToDoItem> toDos;
  final ListType listType;

  AppState(this.toDos, this.listType);

  factory AppState.initial() =>
      AppState(List.unmodifiable([]), ListType.listOnly);
}

enum ListType { listOnly, listWithNewItem }
