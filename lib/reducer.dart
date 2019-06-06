import 'to_do_item.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'action.dart';
import 'AppState.dart';

List<ToDoItem> _addItem(List<ToDoItem> todo, AddItemAction action) =>
    List.unmodifiable(List.from(todo)..add(action.item));

List<ToDoItem> _removeItem(List<ToDoItem> todo, RemoveItemAction action) =>
    List.unmodifiable(List.from(todo)..remove(action.item));

final Reducer<List<ToDoItem>> todoReducer = combineReducers([
  TypedReducer<List<ToDoItem>, AddItemAction>(_addItem),
  TypedReducer<List<ToDoItem>, RemoveItemAction>(_removeItem)
]);

ListType _displayListOnly(ListType listType, DisplayListOnlyAction action) =>
    ListType.listOnly;

ListType _displayListWithNewItem(
        ListType listType, DisplayListWithNewItemAction action) =>
    ListType.listWithNewItem;

final Reducer<ListType> listTypeReducer = combineReducers([
  TypedReducer<ListType, DisplayListOnlyAction>(_displayListOnly),
  TypedReducer<ListType, DisplayListWithNewItemAction>(_displayListWithNewItem)
]);

AppState appReducer(AppState appState, action) => AppState(
    todoReducer(appState.toDos, action),
    listTypeReducer(appState.listType, action));
