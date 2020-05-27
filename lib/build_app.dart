import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_reducer.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/custom_page_route/material_no_animation_page_route.dart';
import 'package:flutterwanandroid/ui/login/log_in_page.dart';
import 'package:flutterwanandroid/ui/splash/splash_page.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

Widget buildAppWidget() {
  final navigatorKey = GlobalKey<NavigatorState>();
  var store = buildAppStore();
  return StoreProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings routeSettings) {
          switch (routeSettings.name) {
            case AppRouter.splashRouterName:
              return MaterialPageRouteNoAnimation<void>(builder: (context) {
                return SplashPage();
              });
            case AppRouter.loginRouterName:
              return MaterialPageRouteNoAnimation<void>(builder: (context) {
                return LoginPage();
              });
            default:
              return MaterialPageRouteNoAnimation<void>(builder: (context) {
                return SplashPage();
              });
          }
        },
        navigatorKey: navigatorKey,
      ));
}

Store<AppState> buildAppStore() {
  return Store<AppState>(
    appReducer,
    initialState: AppState(splashState: SplashState()),
    middleware: [thunkMiddleware],
  );
}
