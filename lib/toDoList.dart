import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'to_do_item.dart';
import 'AppState.dart';
import 'action.dart';

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.create(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          return Scaffold(
            appBar: AppBar(
              title: Text('AppBar'),
            ),
            body: ListView(
              children: viewModel.items
                  .map((_ItemViewModel item) => _createWidget(item))
                  .toList(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: viewModel.onAddItem,
              tooltip: viewModel.newItemToolTip,
              child: Icon(viewModel.newItemIcon),
            ),
          );
        },
      );
}

Widget _createWidget(_ItemViewModel item) {
  if (item is _EmptyItemViewModel) {
    return _createEmptyItemWidget(item);
  } else {
    return _createToDoItemWidget(item);
  }
}

Widget _createEmptyItemWidget(_EmptyItemViewModel item) => Column(
      children: <Widget>[
        TextField(
          onSubmitted: item.onCreateItem,
          autofocus: true,
          decoration: InputDecoration(hintText: item.hint),
        )
      ],
    );

Widget _createToDoItemWidget(_ToDoItemViewModel item) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Material(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(30.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  item.title,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                  onPressed: item.onDeleteItem,
                  child: Icon(
                    item.deleteItemIcon,
                    size: 30.0,
                    color: Colors.deepPurple,
                  )),
            )
          ],
        )),
  );
}

class _ViewModel {
  final String pageTitle;
  final List<_ItemViewModel> items;
  final Function() onAddItem;
  final String newItemToolTip;
  final IconData newItemIcon;

  _ViewModel(this.pageTitle, this.items, this.onAddItem, this.newItemToolTip,
      this.newItemIcon);

  factory _ViewModel.create(Store<AppState> store) {
    List<_ItemViewModel> item = store.state.toDos
        .map((ToDoItem item) => _ToDoItemViewModel(item.title, () {
              store.dispatch(RemoveItemAction(item));
              store.dispatch(SaveListAction());
            }, 'Delete', Icons.delete) as _ItemViewModel)
        .toList();

    if (store.state.listType == ListType.listWithNewItem) {
      item.add(_EmptyItemViewModel('Type The Next Item Here', (String title) {
        store.dispatch(DisplayListOnlyAction());
        store.dispatch(AddItemAction(ToDoItem(title)));
        store.dispatch(SaveListAction());
      }, 'Add Item'));
    }

    return _ViewModel(
        'To Do List',
        item,
        () => store.dispatch(DisplayListWithNewItemAction()),
        'Add new to-do item',
        Icons.add);
  }
}

abstract class _ItemViewModel {}

@immutable
class _EmptyItemViewModel extends _ItemViewModel {
  final String hint;
  Function(String) onCreateItem;
  final String createItemToolTip;

  _EmptyItemViewModel(this.hint, this.onCreateItem, this.createItemToolTip);
}

@immutable
class _ToDoItemViewModel extends _ItemViewModel {
  final String title;
  final Function() onDeleteItem;
  final String deleteItemToolTip;
  final IconData deleteItemIcon;

  _ToDoItemViewModel(this.title, this.onDeleteItem, this.deleteItemToolTip,
      this.deleteItemIcon);
}
