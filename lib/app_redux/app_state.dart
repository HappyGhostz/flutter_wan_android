import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_dependencies.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/ui/author/redux/author_state.dart';
import 'package:flutterwanandroid/ui/collect/collect_article/reducer/collect_article_state.dart';
import 'package:flutterwanandroid/ui/collect/collect_web/reducer/collect_web_state.dart';
import 'package:flutterwanandroid/ui/commonly_used_websites/reducer/commonly_websites_state.dart';
import 'package:flutterwanandroid/ui/community/reducer/community_state.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_state.dart';
import 'package:flutterwanandroid/ui/home/redux/home_state.dart';
import 'package:flutterwanandroid/ui/integral/integra_private/reducer/integral_private_state.dart';
import 'package:flutterwanandroid/ui/integral/integral_rank/reducer/integral_rank_state.dart';
import 'package:flutterwanandroid/ui/login_signin/login_state.dart';
import 'package:flutterwanandroid/ui/my_page/redux/my_state.dart';
import 'package:flutterwanandroid/ui/navigation_page/redux/navigation_state.dart';
import 'package:flutterwanandroid/ui/project/reducer/project_state.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/redux/history_state.dart';
import 'package:flutterwanandroid/ui/public_account/redux/public_account_state.dart';
import 'package:flutterwanandroid/ui/search/redux/search_state.dart';
import 'package:flutterwanandroid/ui/share/share_other/reducer/share_other_state.dart';
import 'package:flutterwanandroid/ui/share/share_private/reducer/share_private_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';
import 'package:flutterwanandroid/ui/system/reducer/system_state.dart';
import 'package:flutterwanandroid/ui/system/system_list/reducer/system_list_state.dart';
import 'package:flutterwanandroid/ui/to_do_page/redux/to_do_state.dart';
import 'package:flutterwanandroid/ui/web/redux/web_state.dart';
import 'package:flutterwanandroid/ui/wen_da/reducer/wen_da_state.dart';

class AppState implements Cloneable<AppState> {
  AppState({
    this.splashState,
    this.loginState,
    this.navigatorKey,
    this.cookJar,
    this.appDependency,
    this.homeState,
    this.firstPageState,
    this.publicAccountPageState,
    this.publicAccountHistoryState,
    this.myState,
    this.navigationState,
    this.webState,
    this.todoState,
    this.authorState,
    this.searchState,
    this.publicAccountSearchId,
    this.publicAccountTabIndex,
    this.publicAccountSearchName,
    this.projectState,
    this.systemState,
    this.systemListState,
    this.wendaState,
    this.integralRankState,
    this.integralPrivateState,
    this.collectArticleState,
    this.collectWebState,
    this.commonlyUsedWebSitesState,
    this.shareOtherState,
    this.sharePrivateState,
    this.communityState,
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
  PublicAccountState publicAccountPageState;
  PublicAccountHistoryState publicAccountHistoryState;
  NavigationState navigationState;
  MyState myState;
  WebState webState;
  TodoState todoState;
  AuthorState authorState;
  SearchState searchState;
  int publicAccountSearchId;
  int publicAccountTabIndex;
  String publicAccountSearchName;
  ProjectState projectState;
  SystemState systemState;
  SystemListState systemListState;
  WendaState wendaState;
  IntegralRankState integralRankState;
  IntegralPrivateState integralPrivateState;
  CollectArticleState collectArticleState;
  CollectWebState collectWebState;
  CommonlyUsedWebSitesState commonlyUsedWebSitesState;
  ShareOtherState shareOtherState;
  SharePrivateState sharePrivateState;
  CommunityState communityState;

  @override
  AppState clone() {
    return AppState()
      ..splashState = splashState
      ..loginState = loginState
      ..homeState = homeState
      ..firstPageState = firstPageState
      ..publicAccountPageState = publicAccountPageState
      ..publicAccountHistoryState = publicAccountHistoryState
      ..navigationState = navigationState
      ..myState = myState
      ..splashImg = splashImg
      ..navigatorKey = navigatorKey
      ..dio = dio
      ..cookJar = cookJar
      ..appDependency = appDependency
      ..famousSentence = famousSentence
      ..webState = webState
      ..todoState = todoState
      ..searchState = searchState
      ..publicAccountSearchId = publicAccountSearchId
      ..publicAccountTabIndex = publicAccountTabIndex
      ..publicAccountSearchName = publicAccountSearchName
      ..authorState = authorState
      ..projectState = projectState
      ..systemState = systemState
      ..systemListState = systemListState
      ..wendaState = wendaState
      ..integralRankState = integralRankState
      ..integralPrivateState = integralPrivateState
      ..collectArticleState = collectArticleState
      ..collectWebState = collectWebState
      ..commonlyUsedWebSitesState = commonlyUsedWebSitesState
      ..shareOtherState = shareOtherState
      ..sharePrivateState = sharePrivateState
      ..communityState = communityState;
  }
}
