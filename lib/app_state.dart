import 'package:flutter/material.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/ui/login_signin/login_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';

class AppState implements Cloneable<AppState> {
  AppState({this.splashState, this.loginState, this.navigatorKey});
  SplashState splashState;
  LoginState loginState;
  String splashImg;
  List<String> famousSentence;
  GlobalKey<NavigatorState> navigatorKey;

  @override
  AppState clone() {
    return AppState()
      ..splashState = splashState
      ..loginState = loginState
      ..splashImg = splashImg
      ..navigatorKey = navigatorKey
      ..famousSentence = famousSentence;
  }
}
