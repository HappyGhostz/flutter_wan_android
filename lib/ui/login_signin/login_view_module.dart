import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/dialog.dart';
import 'package:flutterwanandroid/custom_widget/dialog/info_dialog.dart';
import 'package:flutterwanandroid/ui/login_signin/login_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';

class LoginModuleView {
  LoginModuleView({
    this.userName,
    this.userPassword,
    this.icon,
    this.famousSentence,
    this.usernameFocusNode,
    this.usernameSignInFocusNode,
    this.editPasswordFocusNode,
    this.editConfirmPasswordFocusNode,
    this.editConfirmSignInPasswordFocusNode,
    this.controllerUsername,
    this.controllerPassWord,
    this.controllerConfirmPassWord,
    this.controllerSignInPassWord,
    this.controllerSignInUsername,
    this.isShowPassword,
    this.confirmPasswordIsError,
    this.isLoggedIn,
    this.isRememberPassword,
    this.changeTheScreenType,
    this.exitApp,
    this.changeThePasswordShowStatus,
    this.isShowErrorInfo,
    this.signIn,
    this.changeTheRememberPasswordStatus,
    this.forgetPassword,
    this.login,
  });

  String userName;
  String userPassword;
  String icon;
  final List<String> famousSentence;
  final TextEditingController controllerUsername;
  final TextEditingController controllerPassWord;
  final TextEditingController controllerConfirmPassWord;
  final TextEditingController controllerSignInPassWord;
  final TextEditingController controllerSignInUsername;
  final FocusNode usernameFocusNode;
  final FocusNode usernameSignInFocusNode;
  final FocusNode editPasswordFocusNode;
  final FocusNode editConfirmPasswordFocusNode;
  final FocusNode editConfirmSignInPasswordFocusNode;
  final bool isShowPassword;
  final bool confirmPasswordIsError;
  final bool isLoggedIn;
  final bool isRememberPassword;
  final Function(bool isLoggedIn) changeTheScreenType;
  final Function() exitApp;
  final Function() changeThePasswordShowStatus;
  final Function(bool isShowError) isShowErrorInfo;
  final Function(bool isRememberPassword) changeTheRememberPasswordStatus;
  final Function(BuildContext context, String username, String password, String repassword) signIn;
  final Function(BuildContext context) forgetPassword;
  final Function(BuildContext context, String username, String password, bool isRemember) login;

  static LoginModuleView fromStore(Store<AppState> store) {
    var loginState = store.state.loginState;
    return LoginModuleView(
      userName: loginState.userName,
      userPassword: loginState.userPassword,
      icon: store.state.splashImg,
      famousSentence: store.state.famousSentence,
      usernameFocusNode: loginState.usernameFocusNode,
      usernameSignInFocusNode: loginState.usernameSignInFocusNode,
      editPasswordFocusNode: loginState.editPasswordFocusNode,
      editConfirmPasswordFocusNode: loginState.editConfirmPasswordFocusNode,
      editConfirmSignInPasswordFocusNode: loginState.editConfirmSignInPasswordFocusNode,
      controllerUsername: loginState.controllerUsername..text = loginState.userName,
      controllerPassWord: loginState.controllerPassWord..text = loginState.userPassword,
      controllerConfirmPassWord: loginState.controllerConfirmPassWord,
      controllerSignInPassWord: loginState.controllerSignInPassWord,
      controllerSignInUsername: loginState.controllerSignInUsername,
      isShowPassword: loginState.isShowPassword ?? false,
      confirmPasswordIsError: loginState.confirmPasswordIsError ?? false,
      isLoggedIn: loginState.isLoggedIn ?? true,
      isRememberPassword: loginState.isRememberPassword ?? false,
      changeTheScreenType: (isLoggedIn) {
        store.dispatch(ChangeThePageTypeAction(isLoggedIn: isLoggedIn));
      },
      exitApp: SystemNavigator.pop,
      changeThePasswordShowStatus: () {
        store.dispatch(ChangeThePasswordShowStatusAction());
      },
      isShowErrorInfo: (isShowError) {
        store.dispatch(ShowErrorInfoAction(isShowErrorInfo: isShowError));
      },
      signIn: (BuildContext context, String username, String password, String repassword) {
        store.dispatch(appSignInAction(context, username, password, repassword));
      },
      changeTheRememberPasswordStatus: (isRememberPassword) {
        store.dispatch(ChangeTheRememberPasswordStatusAction(isRememberPassword: isRememberPassword));
      },
      forgetPassword: (context) {
        showAppDialog<void>(context: context, child: InfoDialog(content: '暂不支持，可以私信轰炸鸿神来找回-o-', onClick: null));
      },
      login: (context, name, password, isRemember) {
        if (isRemember) {
          store.state.appDependency.sharedPreferences.setString(userNameKey, name);
          store.state.appDependency.sharedPreferences.setString(userPasswordKey, password);
        } else {
          store.state.appDependency.sharedPreferences.remove(userPasswordKey);
          store.state.appDependency.sharedPreferences.remove(userNameKey);
        }
        store.dispatch(appLogin(context, name, password));
      },
    );
  }
}
