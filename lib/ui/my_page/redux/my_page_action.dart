import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/my_page/article_collect_module.dart';
import 'package:flutterwanandroid/module/my_page/my_integral_module.dart';
import 'package:flutterwanandroid/module/my_page/my_share_module.dart';
import 'package:flutterwanandroid/module/my_page/web_collect_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateLoginStatusAction {
  UpdateLoginStatusAction({
    this.isLogin,
    this.name,
  });

  bool isLogin;
  String name;
}

class UpdateRefreshStatusAction {
  UpdateRefreshStatusAction({
    this.isRefresh,
  });

  bool isRefresh;
}

class UpdateIntegralAction {
  UpdateIntegralAction({
    this.integralModule,
  });

  IntegralModule integralModule;
}

class UpdateCollectDataAction {
  UpdateCollectDataAction({
    this.articleCollectModule,
  });

  ArticleCollectModule articleCollectModule;
}

class UpdateWebCollectDataAction {
  UpdateWebCollectDataAction({
    this.webCollectModule,
  });

  WebCollectModule webCollectModule;
}

class UpdateMyShareDataAction {
  UpdateMyShareDataAction({
    this.myShareModule,
  });

  MyShareModule myShareModule;
}

ThunkAction<AppState> upDateAccountDataAction() {
  return (Store<AppState> store) async {
    try {
      var cookies = store.state.cookJar.loadForRequest(Uri.parse('${NetPath.APP_BASE_URL}${NetPath.LOG_IN}'));
      if (cookies != null && cookies.length >= 2) {
        var cookie = cookies[1];
        var name = cookie.value;
        store.dispatch(UpdateLoginStatusAction(isLogin: true, name: name));
      } else {
        store.dispatch(UpdateLoginStatusAction(isLogin: false, name: '???'));
      }
    } catch (e) {
      store.dispatch(UpdateLoginStatusAction(isLogin: false, name: '???'));
    }
  };
}

ThunkAction<AppState> updateIntegralDataAction() {
  return (Store<AppState> store) async {
    try {
      var cookies = store.state.cookJar.loadForRequest(Uri.parse('${NetPath.APP_BASE_URL}${NetPath.LOG_IN}'));
      if (cookies != null && cookies.isNotEmpty) {
        var integralResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.INTEGRAL);
        var integralModule = IntegralModule.fromJson(integralResponse.data);
        store.dispatch(UpdateIntegralAction(integralModule: integralModule));
        store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
      } else {
        store.dispatch(UpdateIntegralAction(integralModule: null));
        store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
      }
    } on DioError {
      store.dispatch(UpdateIntegralAction(integralModule: null));
      store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
    } catch (e) {
      store.dispatch(UpdateIntegralAction(integralModule: null));
      store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
    }
  };
}

ThunkAction<AppState> updateCollectionDataAction() {
  return (Store<AppState> store) async {
    try {
      var cookies = store.state.cookJar.loadForRequest(Uri.parse('${NetPath.APP_BASE_URL}${NetPath.LOG_IN}'));
      if (cookies != null && cookies.isNotEmpty) {
        var articleCollectResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getArticleCollect(0));
        var articleCollectModule = ArticleCollectModule.fromJson(articleCollectResponse.data);
        store.dispatch(UpdateCollectDataAction(articleCollectModule: articleCollectModule));
        store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
      } else {
        store.dispatch(UpdateCollectDataAction(articleCollectModule: null));
        store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
      }
    } on DioError {
      store.dispatch(UpdateCollectDataAction(articleCollectModule: null));
      store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
    } catch (e) {
      store.dispatch(UpdateCollectDataAction(articleCollectModule: null));
      store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
    }
  };
}

ThunkAction<AppState> updateWebCollectionDataAction() {
  return (Store<AppState> store) async {
    try {
      var cookies = store.state.cookJar.loadForRequest(Uri.parse('${NetPath.APP_BASE_URL}${NetPath.LOG_IN}'));
      if (cookies != null && cookies.isNotEmpty) {
        var webCollectResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.WEB_COLLECT);
        var webCollectModule = WebCollectModule.fromJson(webCollectResponse.data);
        store.dispatch(UpdateWebCollectDataAction(webCollectModule: webCollectModule));
        store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
      } else {
        store.dispatch(UpdateWebCollectDataAction(webCollectModule: null));
        store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
      }
    } on DioError {
      store.dispatch(UpdateWebCollectDataAction(webCollectModule: null));
      store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
    } catch (e) {
      store.dispatch(UpdateWebCollectDataAction(webCollectModule: null));
      store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
    }
  };
}

ThunkAction<AppState> updateMyShareDataAction() {
  return (Store<AppState> store) async {
    try {
      var cookies = store.state.cookJar.loadForRequest(Uri.parse('${NetPath.APP_BASE_URL}${NetPath.LOG_IN}'));
      if (cookies != null && cookies.isNotEmpty) {
        var myShareResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getMyShare(0));
        var myShareModule = MyShareModule.fromJson(myShareResponse.data);
        store.dispatch(UpdateMyShareDataAction(myShareModule: myShareModule));
        store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
      } else {
        store.dispatch(UpdateMyShareDataAction(myShareModule: null));
        store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
      }
    } on DioError {
      store.dispatch(UpdateMyShareDataAction(myShareModule: null));
      store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
    } catch (e) {
      store.dispatch(UpdateMyShareDataAction(myShareModule: null));
      store.dispatch(UpdateRefreshStatusAction(isRefresh: false));
    }
  };
}

class LogoutAction extends AppHttpResponseAction {
  LogoutAction({
    this.context,
    this.showLogoutDialog,
  });

  BuildContext context;
  Function() showLogoutDialog;
}

ThunkAction<AppState> logoutAction(BuildContext context) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var logoutResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.LOGOUT);
      dismissDialog<void>(context);
      store.dispatch(HttpAction(
          context: context,
          response: logoutResponse,
          action: LogoutAction(
              context: context,
              showLogoutDialog: () {
                showInfoDialog(context, '太棒了!退出成功!', () {
                  store.dispatch(UpdateRefreshStatusAction(isRefresh: true));
                  store.dispatch(upDateAccountDataAction());
                  store.dispatch(updateIntegralDataAction());
                  store.dispatch(updateCollectionDataAction());
                  store.dispatch(updateWebCollectionDataAction());
                  store.dispatch(updateMyShareDataAction());
                });
              })));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
