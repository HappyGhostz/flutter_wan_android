import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/ui/to_do_page/redux/to_do_action.dart';
import 'package:flutterwanandroid/ui/to_do_page/to_do_menu_widget.dart';
import 'package:redux/redux.dart';

var toDoTabData = <String>['待办', '已完成'];

class TodoViewModule {
  TodoViewModule({
    this.itemSelectCallBack,
    this.currentOptions,
    this.currentOptionTitle,
    this.currentOptionType,
    this.addTodo,
    this.addNum,
  });

  MenuItemSelectCallBack itemSelectCallBack;
  TodoMenuOptions currentOptions;
  String currentOptionTitle;
  int currentOptionType;
  Function(BuildContext context, Map<String, String> params, int type) addTodo;
  int addNum;

  static TodoViewModule fromStore(Store<AppState> store) {
    var todoState = store.state.todoState;
    return TodoViewModule()
      ..currentOptions = todoState.currentOptions ?? TodoMenuOptions.todoDefault
      ..currentOptionTitle = todoState.currentOptionTitle ?? '默认'
      ..currentOptionType = todoState.currentOptionType ?? 0
      ..addNum = todoState.addNum ?? 0
      ..itemSelectCallBack = (menuOptions) {
        if (store.state.todoState.currentOptions == menuOptions) {
          return;
        }
        switch (menuOptions) {
          case TodoMenuOptions.todoDefault:
            store.dispatch(UpdateMenuOptionsStatusAction(todoMenuOptions: menuOptions, todoTitle: '默认', toDoType: 0));
            break;
          case TodoMenuOptions.todoWork:
            store.dispatch(UpdateMenuOptionsStatusAction(todoMenuOptions: menuOptions, todoTitle: '工作', toDoType: 1));
            break;
          case TodoMenuOptions.todoStudy:
            store.dispatch(UpdateMenuOptionsStatusAction(todoMenuOptions: menuOptions, todoTitle: '学习', toDoType: 2));
            break;
          case TodoMenuOptions.todoLife:
            store.dispatch(UpdateMenuOptionsStatusAction(todoMenuOptions: menuOptions, todoTitle: '生活', toDoType: 3));
            break;
        }
      }
      ..addTodo = (context, params, currentOptionType) {
        store.dispatch(addTodoAction(context, params, currentOptionType));
      };
  }
}
