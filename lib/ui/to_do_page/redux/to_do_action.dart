import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/to_do_add_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/ui/to_do_page/to_do_menu_widget.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateMenuOptionsStatusAction {
  UpdateMenuOptionsStatusAction({
    this.todoMenuOptions,
    this.todoTitle,
    this.toDoType,
  });

  TodoMenuOptions todoMenuOptions;
  int toDoType;
  String todoTitle;
}

class AddTodoSuccessAction extends AppHttpResponseAction {
  AddTodoSuccessAction();
}

ThunkAction<AppState> addTodoAction(BuildContext context, Map<String, String> params, int type) {
  showLoadingDialog<void>(context);
  var formData = FormData.fromMap(<String, dynamic>{
    'title': params[editTitleKey],
    'content': params[editContentKey],
    'date': params[editTimeKey],
    'type': type,
  });
  return (Store<AppState> store) async {
    try {
      var addResponse = await store.state.dio.post<Map<String, dynamic>>(NetPath.ADD_TODO, data: formData);
      var todoAddModule = TodoAddResponseModule.fromJson(addResponse.data);
      if (todoAddModule.errorCode == 0) {
        dismissDialog<void>(context);
        store.dispatch(HttpAction(context: context, response: addResponse, action: AddTodoSuccessAction()));
      }
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
