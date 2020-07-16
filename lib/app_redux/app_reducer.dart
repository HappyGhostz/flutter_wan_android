import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/ui/author/redux/author_reducer.dart';
import 'package:flutterwanandroid/ui/collect/collect_article/reducer/collect_article_reducer.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_reducer.dart';
import 'package:flutterwanandroid/ui/home/redux/home_reducer.dart';
import 'package:flutterwanandroid/ui/integral/integra_private/reducer/integral_private_reducer.dart';
import 'package:flutterwanandroid/ui/integral/integral_rank/reducer/integral_rank_reducer.dart';
import 'package:flutterwanandroid/ui/login_signin/login_reducer.dart';
import 'package:flutterwanandroid/ui/my_page/redux/my_reducer.dart';
import 'package:flutterwanandroid/ui/navigation_page/redux/navigation_reducer.dart';
import 'package:flutterwanandroid/ui/project/reducer/project_reducer.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/redux/history_reducer.dart';
import 'package:flutterwanandroid/ui/public_account/redux/public_account_reducer.dart';
import 'package:flutterwanandroid/ui/search/redux/search_reducer.dart';
import 'package:flutterwanandroid/ui/splash/splash_reducer.dart';
import 'package:flutterwanandroid/ui/system/reducer/system_reducer.dart';
import 'package:flutterwanandroid/ui/system/system_list/reducer/system_list_reducer.dart';
import 'package:flutterwanandroid/ui/to_do_page/redux/to_do_reducer.dart';
import 'package:flutterwanandroid/ui/web/redux/web_reducer.dart';
import 'package:flutterwanandroid/ui/wen_da/reducer/wen_da_reducer.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is Function) return state;
  if (action is UpdateSplashImgAction) {
    return state.clone()
      ..splashImg = action.img
      ..famousSentence = action.famousSentence;
  } else if (action is DioErrorAction) {
    showDioErrorInfo(action.context, action.dioError);
    return state;
  } else if (action is UnKnowExceptionAction) {
    showExceptionInfo(action.context, action.error);
    return state;
  } else if (action is ApiErrorAction) {
    showApiError(action.context, action.errorMessage);
    return state;
  } else if (action is VerificationFailedAction) {
    Navigator.pushNamedAndRemoveUntil(action.context, AppRouter.loginRouterName, (route) => false);
    return state;
  }
  return state.clone()
    ..splashState = splashReducer(state.splashState, action)
    ..loginState = loginReducer(state.loginState, action)
    ..homeState = homeReducer(state.homeState, action)
    ..firstPageState = firstPageReducer(state.firstPageState, action)
    ..publicAccountPageState = publicAccountPageReducer(state.publicAccountPageState, action)
    ..publicAccountHistoryState = publicAccountHistoryPageReducer(state.publicAccountHistoryState, action)
    ..navigationState = navigationPageReducer(state.navigationState, action)
    ..myState = myPageReducer(state.myState, action)
    ..webState = webReducer(state.webState, action)
    ..todoState = todoReducer(state.todoState, action)
    ..authorState = authorReducer(state.authorState, action)
    ..searchState = searchReducer(state.searchState, action)
    ..projectState = projectReducer(state.projectState, action)
    ..systemState = systemReducer(state.systemState, action)
    ..systemListState = systemListReducer(state.systemListState, action)
    ..wendaState = wendaReducer(state.wendaState, action)
    ..integralRankState = integralRankReducer(state.integralRankState, action)
    ..integralPrivateState = integralPrivateReducer(state.integralPrivateState, action)
    ..collectArticleState = collectArticleReducer(state.collectArticleState, action);
}
