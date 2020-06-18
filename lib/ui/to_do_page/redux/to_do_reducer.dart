import 'package:flutterwanandroid/ui/to_do_page/redux/to_do_action.dart';
import 'package:flutterwanandroid/ui/to_do_page/redux/to_do_state.dart';
import 'package:redux/redux.dart';

final todoReducer = combineReducers<TodoState>([
  TypedReducer<TodoState, UpdateMenuOptionsStatusAction>(_updateMenuOptionsStatusActionReducer),
  TypedReducer<TodoState, AddTodoSuccessAction>(_addTodoSuccessActionReducer),
]);

TodoState _updateMenuOptionsStatusActionReducer(TodoState state, UpdateMenuOptionsStatusAction action) {
  return state.clone()
    ..currentOptions = action.todoMenuOptions
    ..currentOptionType = action.toDoType
    ..currentOptionTitle = action.todoTitle;
}

TodoState _addTodoSuccessActionReducer(TodoState state, AddTodoSuccessAction action) {
  var newNum = state.addNum ?? 0 + 1;
  return state.clone()..addNum = newNum;
}
