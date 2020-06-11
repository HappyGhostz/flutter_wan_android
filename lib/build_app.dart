import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_dependencies.dart';
import 'package:flutterwanandroid/app_redux/app_reducer.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_middleware/http_middleware.dart';
import 'package:flutterwanandroid/custom_page_route/slide_route.dart';
import 'package:flutterwanandroid/style/app_theme.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_state.dart';
import 'package:flutterwanandroid/ui/home/home_page.dart';
import 'package:flutterwanandroid/ui/home/redux/home_state.dart';
import 'package:flutterwanandroid/ui/login_signin/log_in_page.dart';
import 'package:flutterwanandroid/ui/login_signin/login_state.dart';
import 'package:flutterwanandroid/ui/navigation_page/redux/navigation_state.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/redux/history_state.dart';
import 'package:flutterwanandroid/ui/public_account/redux/public_account_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_page.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> buildAppWidget() async {
  timeDilation = 2;
  final navigatorKey = GlobalKey<NavigatorState>();
  var store = await buildAppStore(navigatorKey);
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
            case AppRouter.homeRouterName:
              return SlideRightRoute<void>(page: HomePage());
//              return MaterialPageRoute<void>(builder: (context) {
//                return HomePage();
//              });
            default:
              return MaterialPageRoute<void>(builder: (context) {
                return SplashPage();
              });
          }
        },
        navigatorKey: navigatorKey,
      ));
}

Future<Store<AppState>> buildAppStore(GlobalKey<NavigatorState> navigatorKey) async {
  var cookJar = await buildCookJar();
  var sharedPerences = await initSharedPerences();
  return Store<AppState>(
    appReducer,
    initialState: AppState(
      splashState: SplashState(),
      loginState: LoginState(),
      homeState: HomeState(),
      firstPageState: FirstPageState(),
      publicAccountPageState: PublicAccountState(),
      publicAccountHistoryState: PublicAccountHistoryState(),
      navigationState: NavigationState(),
      navigatorKey: navigatorKey,
      cookJar: cookJar,
      appDependency: AppDependency(sharedPreferences: sharedPerences),
    ),
    middleware: [thunkMiddleware]..addAll([httpMiddleware]),
  );
}

Future<PersistCookieJar> buildCookJar() async {
  var appDocDir = await getApplicationDocumentsDirectory();
  var appDocPath = appDocDir.path;
  var cookieJar = PersistCookieJar(dir: '$appDocPath/.cookies/');
  return cookieJar;
}

Future<SharedPreferences> initSharedPerences() async {
  var sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences;
}
