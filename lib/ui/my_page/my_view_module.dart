import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/my_page/article_collect_module.dart';
import 'package:flutterwanandroid/module/my_page/my_integral_module.dart';
import 'package:flutterwanandroid/module/my_page/my_share_module.dart';
import 'package:flutterwanandroid/module/my_page/web_collect_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/ui/my_page/redux/my_page_action.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class MyViewModule {
  MyViewModule({
    this.isRefresh,
    this.isLogin,
    this.name,
    this.webCollectModule,
    this.articleCollectModule,
    this.myShareModule,
    this.integralModule,
    this.refresh,
    this.logout,
  });

  bool isRefresh;
  bool isLogin;
  String name;
  IntegralModule integralModule;
  WebCollectModule webCollectModule;
  ArticleCollectModule articleCollectModule;
  MyShareModule myShareModule;
  Function() refresh;
  Function(BuildContext context) logout;
  Function(BuildContext context, String routeName) pushPage;
  Function(BuildContext context, String routeName) pushIntegralPrivatePage;

  static MyViewModule fromStore(Store<AppState> store) {
    var state = store.state.myState;
    return MyViewModule()
      ..isRefresh = state.isRefresh ?? true
      ..isLogin = state.isLogin ?? false
      ..name = state.name ?? '???'
      ..integralModule = state.integralModule
      ..webCollectModule = state.webCollectModule
      ..articleCollectModule = state.articleCollectModule
      ..myShareModule = state.myShareModule
      ..refresh = () {
        store.dispatch(UpdateRefreshStatusAction(isRefresh: true));
        store.dispatch(upDateAccountDataAction());
        store.dispatch(updateIntegralDataAction());
        store.dispatch(updateCollectionDataAction());
        store.dispatch(updateWebCollectionDataAction());
        store.dispatch(updateMyShareDataAction());
      }
      ..logout = (context) {
        store.dispatch(logoutAction(context));
      }
      ..pushPage = RouterUtil.pushName
      ..pushIntegralPrivatePage = (context, name) {
        try {
          var cookies = store.state.cookJar.loadForRequest(Uri.parse('${NetPath.APP_BASE_URL}${NetPath.LOG_IN}'));
          if (cookies != null && cookies.length >= 2) {
            RouterUtil.pushName(context, name);
          } else {
            showLoginDialog(context);
          }
        } catch (e) {
          showLoginDialog(context);
        }
      };
  }
}
