import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/ui/login_signin/login_action.dart';
import 'package:redux/redux.dart';

class LoginModuleView {
  LoginModuleView({
    this.icon,
    this.famousSentence,
    this.usernameFocusNode,
    this.editPasswordFocusNode,
    this.editConfirmPasswordFocusNode,
    this.controllerUsername,
    this.controllerPassWord,
    this.controllerConfirmPassWord,
    this.isShowPassword,
    this.isLoggedIn,
    this.changeTheScreenType,
    this.exitApp,
  });

  String icon;
  final List<String> famousSentence;
  final TextEditingController controllerUsername;
  final TextEditingController controllerPassWord;
  final TextEditingController controllerConfirmPassWord;
  final FocusNode usernameFocusNode;
  final FocusNode editPasswordFocusNode;
  final FocusNode editConfirmPasswordFocusNode;
  final bool isShowPassword;
  final bool isLoggedIn;
  final Function(bool isLoggedIn) changeTheScreenType;
  final Function() exitApp;

  static LoginModuleView fromStore(Store<AppState> store) {
    var loginState = store.state.loginState;
    return LoginModuleView(
      icon: store.state.splashImg,
      famousSentence: store.state.famousSentence,
      usernameFocusNode: FocusNode(),
      editPasswordFocusNode: FocusNode(),
      editConfirmPasswordFocusNode: FocusNode(),
      controllerUsername: TextEditingController(),
      controllerPassWord: TextEditingController(),
      controllerConfirmPassWord: TextEditingController(),
      isShowPassword: false,
      isLoggedIn: loginState.isLoggedIn ?? true,
      changeTheScreenType: (isLoggedIn) {
        store.dispatch(ChangeThePageTypeAction(isLoggedIn: isLoggedIn));
      },
      exitApp: SystemNavigator.pop,
    );
  }
}
