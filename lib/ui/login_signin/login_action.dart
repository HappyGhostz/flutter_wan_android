import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class ChangeThePageTypeAction {
  ChangeThePageTypeAction({this.isLoggedIn});

  bool isLoggedIn;
}

class ChangeTheRememberPasswordStatusAction {
  ChangeTheRememberPasswordStatusAction({this.isRememberPassword});

  bool isRememberPassword;
}

class ChangeThePasswordShowStatusAction {
  ChangeThePasswordShowStatusAction();
}

class ShowErrorInfoAction {
  ShowErrorInfoAction({this.isShowErrorInfo});

  bool isShowErrorInfo;
}

class SignInResponseAction extends AppHttpResponseAction {
  SignInResponseAction({
    this.signResponse,
    this.context,
    this.showSignInDialog,
  });

  Response signResponse;
  BuildContext context;
  Function() showSignInDialog;
}

class LoginResponseAction extends AppHttpResponseAction {
  LoginResponseAction({
    this.context,
    this.successLogin,
  });

  BuildContext context;
  Function() successLogin;
}

ThunkAction<AppState> appSignInAction(BuildContext context, String username, String password, String repassword) {
  showLoadingDialog<void>(context);
  var formData = FormData.fromMap(<String, dynamic>{'username': username, 'password': password, 'repassword': repassword});
  return (Store<AppState> store) async {
    try {
      var response = await store.state.dio.post<Map<String, dynamic>>(NetPath.REGISTER, data: formData);
      dismissDialog<void>(context);
      store.dispatch(HttpAction(
          context: context,
          response: response,
          action: SignInResponseAction(
              context: context,
              showSignInDialog: () {
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.homeRouterName, (route) => false);
//                showInfoDialog(context, '太棒了!注册成功', () {
//                  store.dispatch(ChangeThePageTypeAction(isLoggedIn: true));
//                });
              })));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}

ThunkAction<AppState> appLogin(BuildContext context, String username, String password) {
  showLoadingDialog<void>(context);
  var formData = FormData.fromMap(<String, dynamic>{'username': username, 'password': password});
  return (Store<AppState> store) async {
    try {
      var response = await store.state.dio.post<Map<String, dynamic>>(NetPath.LOG_IN, data: formData);
      dismissDialog<void>(context);
      store.dispatch(HttpAction(
          context: context,
          response: response,
          action: LoginResponseAction(
              context: context,
              successLogin: () {
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.homeRouterName, (route) => false);
              })));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
