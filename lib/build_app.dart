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
import 'package:flutterwanandroid/ui/author/auther_page.dart';
import 'package:flutterwanandroid/ui/author/redux/author_state.dart';
import 'package:flutterwanandroid/ui/collect/collect_article/collect_article_screen.dart';
import 'package:flutterwanandroid/ui/collect/collect_article/reducer/collect_article_state.dart';
import 'package:flutterwanandroid/ui/collect/collect_web/collect_web_screen.dart';
import 'package:flutterwanandroid/ui/collect/collect_web/reducer/collect_web_state.dart';
import 'package:flutterwanandroid/ui/commonly_used_websites/commonly_websites_screen.dart';
import 'package:flutterwanandroid/ui/commonly_used_websites/reducer/commonly_websites_state.dart';
import 'package:flutterwanandroid/ui/community/community_screen.dart';
import 'package:flutterwanandroid/ui/community/reducer/community_state.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_state.dart';
import 'package:flutterwanandroid/ui/home/home_page.dart';
import 'package:flutterwanandroid/ui/home/redux/home_state.dart';
import 'package:flutterwanandroid/ui/integral/integra_private/integral_private_screen.dart';
import 'package:flutterwanandroid/ui/integral/integra_private/reducer/integral_private_state.dart';
import 'package:flutterwanandroid/ui/integral/integral_rank/integral_rank.dart';
import 'package:flutterwanandroid/ui/integral/integral_rank/reducer/integral_rank_state.dart';
import 'package:flutterwanandroid/ui/login_signin/log_in_page.dart';
import 'package:flutterwanandroid/ui/login_signin/login_state.dart';
import 'package:flutterwanandroid/ui/my_page/redux/my_state.dart';
import 'package:flutterwanandroid/ui/navigation_page/redux/navigation_state.dart';
import 'package:flutterwanandroid/ui/project/project_page.dart';
import 'package:flutterwanandroid/ui/project/reducer/project_state.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/redux/history_state.dart';
import 'package:flutterwanandroid/ui/public_account/redux/public_account_state.dart';
import 'package:flutterwanandroid/ui/search/redux/search_state.dart';
import 'package:flutterwanandroid/ui/search/search_page.dart';
import 'package:flutterwanandroid/ui/share/share_other/reducer/share_other_state.dart';
import 'package:flutterwanandroid/ui/share/share_other/share_other_screen.dart';
import 'package:flutterwanandroid/ui/share/share_private/reducer/share_private_state.dart';
import 'package:flutterwanandroid/ui/share/share_private/share_private_screen.dart';
import 'package:flutterwanandroid/ui/splash/splash_page.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';
import 'package:flutterwanandroid/ui/system/reducer/system_state.dart';
import 'package:flutterwanandroid/ui/system/system_list/reducer/system_list_state.dart';
import 'package:flutterwanandroid/ui/system/system_list/system_list_screen.dart';
import 'package:flutterwanandroid/ui/system/system_page.dart';
import 'package:flutterwanandroid/ui/to_do_page/redux/to_do_state.dart';
import 'package:flutterwanandroid/ui/web/redux/web_state.dart';
import 'package:flutterwanandroid/ui/web/web_view_widget.dart';
import 'package:flutterwanandroid/ui/wen_da/reducer/wen_da_state.dart';
import 'package:flutterwanandroid/ui/wen_da/wen_da_screen.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
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
            case AppRouter.webRouterName:
              var params = routeSettings.arguments as Map<String, dynamic>;
              return SlideRightRoute<void>(
                  page: WebViewScreen(
                url: params[webUrlKey] as String,
                title: params[webTitle] as String,
              ));
            case AppRouter.authorArticleRouterName:
              var params = routeSettings.arguments as Map<String, dynamic>;
              return SlideRightRoute<void>(
                  page: AuthorPage(
                author: params[authorKey] as String,
              ));
            case AppRouter.shareOtherArticle:
              var params = routeSettings.arguments as Map<String, dynamic>;
              return SlideRightRoute<void>(
                  page: ShareOtherScreen(
                shareOtherName: params[shareUserNameKey] as String,
                userId: params[shareUserIdKey] as int,
              ));
            case AppRouter.project:
              return SlideRightRoute<void>(page: ProjectPage());
            case AppRouter.system:
              return SlideRightRoute<void>(page: SystemPage());
            case AppRouter.collectWeb:
              return SlideRightRoute<void>(page: CollectWebScreen());
            case AppRouter.shareArticle:
              return SlideRightRoute<void>(page: SharePrivateScreen());
            case AppRouter.wenda:
              return SlideRightRoute<void>(page: WendaScreen());
            case AppRouter.commonlyUsedWebSites:
              return SlideRightRoute<void>(page: CommonlyUsedWebSitesScreen());
            case AppRouter.collectArticle:
              return SlideRightRoute<void>(page: CollectArticleScreen());
            case AppRouter.integralRank:
              return SlideRightRoute<void>(page: IntegralRankScreen());
            case AppRouter.communityArticle:
              return SlideRightRoute<void>(page: CommunityScreen());
            case AppRouter.integralPrivate:
              var params = routeSettings.arguments as Map<String, dynamic>;
              int userId;
              if (params != null) {
                userId = params[integralPrivateId] as int;
              }
              return SlideRightRoute<void>(
                  page: IntegralPrivateScreen(
                userId: userId,
              ));
            case AppRouter.systemList:
              var params = routeSettings.arguments as Map<String, dynamic>;
              return SlideRightRoute<void>(
                  page: SystemListScreen(id: params[systemListIdKey] as int, title: params[systemListTitleKey] as String));
            case AppRouter.search:
              var params = routeSettings.arguments as Map<String, dynamic>;
              return MaterialPageRoute<void>(builder: (context) {
                return SearchPage(
                  currentIndex: params[homeCurrentIndexKey] as int,
                );
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
      myState: MyState(),
      webState: WebState(),
      todoState: TodoState(),
      authorState: AuthorState(),
      navigationState: NavigationState(),
      searchState: SearchState(),
      projectState: ProjectState(),
      systemState: SystemState(),
      systemListState: SystemListState(),
      wendaState: WendaState(),
      integralRankState: IntegralRankState(),
      integralPrivateState: IntegralPrivateState(),
      collectArticleState: CollectArticleState(),
      collectWebState: CollectWebState(),
      commonlyUsedWebSitesState: CommonlyUsedWebSitesState(),
      shareOtherState: ShareOtherState(),
      sharePrivateState: SharePrivateState(),
      communityState: CommunityState(),
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
