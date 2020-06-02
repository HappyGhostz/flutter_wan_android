import 'package:flutter/material.dart';
import 'package:flutterwanandroid/type/clone.dart';

class LoginState implements Cloneable<LoginState> {
  bool isLoggedIn;
  bool isShowPassword;
  bool confirmPasswordIsError;
  bool isRememberPassword;
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassWord = TextEditingController();
  TextEditingController controllerConfirmPassWord = TextEditingController();
  TextEditingController controllerSignInPassWord = TextEditingController();
  TextEditingController controllerSignInUsername = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode usernameSignInFocusNode = FocusNode();
  FocusNode editPasswordFocusNode = FocusNode();
  FocusNode editConfirmPasswordFocusNode = FocusNode();
  FocusNode editConfirmSignInPasswordFocusNode = FocusNode();
  String userName;
  String userPassword;

  @override
  LoginState clone() {
    return LoginState()
      ..userName = userName
      ..userPassword = userPassword
      ..isLoggedIn = isLoggedIn
      ..isRememberPassword = isRememberPassword
      ..confirmPasswordIsError = confirmPasswordIsError
      ..controllerUsername = controllerUsername
      ..controllerPassWord = controllerPassWord
      ..controllerConfirmPassWord = controllerConfirmPassWord
      ..controllerSignInPassWord = controllerSignInPassWord
      ..controllerSignInUsername = controllerSignInUsername
      ..usernameFocusNode = usernameFocusNode
      ..usernameSignInFocusNode = usernameSignInFocusNode
      ..editPasswordFocusNode = editPasswordFocusNode
      ..editConfirmPasswordFocusNode = editConfirmPasswordFocusNode
      ..editConfirmSignInPasswordFocusNode = editConfirmSignInPasswordFocusNode
      ..isShowPassword = isShowPassword;
  }
}
