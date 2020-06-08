import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_dependencies.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_state.dart';
import 'package:flutterwanandroid/ui/home/redux/home_state.dart';
import 'package:flutterwanandroid/ui/login_signin/login_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';

class AppState implements Cloneable<AppState> {
  AppState({
    this.splashState,
    this.loginState,
    this.navigatorKey,
    this.cookJar,
    this.appDependency,
    this.homeState,
    this.firstPageState,
  }) {
    var options = BaseOptions(
      baseUrl: NetPath.APP_BASE_URL,
      connectTimeout: 5000,
      receiveTimeout: 5000,
    );
    dio = Dio(options);
    dio.interceptors.add(CookieManager(cookJar));
  }

  SplashState splashState;
  LoginState loginState;
  HomeState homeState;
  String splashImg;
  List<String> famousSentence;
  GlobalKey<NavigatorState> navigatorKey;
  Dio dio;
  PersistCookieJar cookJar;
  AppDependency appDependency;
  FirstPageState firstPageState;

  @override
  AppState clone() {
    return AppState()
      ..splashState = splashState
      ..loginState = loginState
      ..homeState = homeState
      ..firstPageState = firstPageState
      ..splashImg = splashImg
      ..navigatorKey = navigatorKey
      ..dio = dio
      ..cookJar = cookJar
      ..appDependency = appDependency
      ..famousSentence = famousSentence;
  }
}
