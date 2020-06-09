import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/public_account/tab_bar_module.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateTabBarDataAction extends AppHttpResponseAction {
  UpdateTabBarDataAction({this.module});

  PublicAccountTabBarModule module;
}

class PublicAccountTabBarDataErrorAction extends AppResponseErrorAction {
  PublicAccountTabBarDataErrorAction({this.context, this.showErrorDialog});

  BuildContext context;
  Function() showErrorDialog;
}

ThunkAction<AppState> initTabBarData(BuildContext context) {
  return (Store<AppState> store) async {
    try {
      var chapterDataResponse = await store.state.publicAccountPageState.publicAccountPageService.getWXChapters();
      var chapterModule = PublicAccountTabBarModule.fromJson(chapterDataResponse.data);
      store.dispatch(HttpAction(
          context: context,
          response: chapterDataResponse,
          action: UpdateTabBarDataAction(
            module: chapterModule,
          ),
          errorAction: PublicAccountTabBarDataErrorAction(
            context: context,
            showErrorDialog: () {
              showExceptionInfo(context, 'Api Error', onClick: () {
                initTabBarData(context);
              });
            },
          )));
    } on DioError catch (e) {
      store.dispatch(HttpAction(
          dioError: e,
          context: context,
          errorAction: PublicAccountTabBarDataErrorAction(
            context: context,
            showErrorDialog: () {
              showDioErrorInfo(context, e, onClick: () {
                initTabBarData(context);
              });
            },
          )));
    } catch (e) {
      store.dispatch(HttpAction(
          error: e.toString(),
          context: context,
          errorAction: PublicAccountTabBarDataErrorAction(
            context: context,
            showErrorDialog: () {
              showExceptionInfo(context, e.toString(), onClick: () {
                initTabBarData(context);
              });
            },
          )));
    }
  };
}
