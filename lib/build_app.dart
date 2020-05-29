import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_reducer.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/style/app_theme.dart';
import 'package:flutterwanandroid/ui/login_signin/log_in_page.dart';
import 'package:flutterwanandroid/ui/login_signin/login_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_page.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

Widget buildAppWidget() {
  timeDilation = 2;
  final navigatorKey = GlobalKey<NavigatorState>();
  var store = buildAppStore(navigatorKey);
  return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings routeSettings) {
          switch (routeSettings.name) {
            case AppRouter.splashRouterName:
              return MaterialPageRoute<void>(builder: (context) {
                return SplashPage();
              });
            case AppRouter.loginRouterName:
              return MaterialPageRoute<void>(builder: (context) {
                return LoginPage();
              });
            default:
              return MaterialPageRoute<void>(builder: (context) {
                return SplashPage();
              });
          }
        },
        navigatorKey: navigatorKey,
      ));
}

Store<AppState> buildAppStore(GlobalKey<NavigatorState> navigatorKey) {
  return Store<AppState>(
    appReducer,
    initialState: AppState(splashState: SplashState(), loginState: LoginState(), navigatorKey: navigatorKey),
    middleware: [thunkMiddleware],
  );
}
