import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/flushbar/flushbar.dart';
import 'package:flutterwanandroid/module/collect/collect_web_module.dart';
import 'package:flutterwanandroid/ui/collect/collect_web/reducer/collect_web_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:flutterwanandroid/utils/toast_message.dart';
import 'package:redux/redux.dart';

class CollectWebViewModule {
  CollectWebViewModule({
    this.dataLoadStatus,
    this.refreshData,
    this.pushWebPage,
    this.cancelCollect,
    this.showPromptInfo,
    this.collectWebs,
    this.editCollectWeb,
    this.addCollectWeb,
  });
  DataLoadStatus dataLoadStatus;
  Function() refreshData;
  Function(BuildContext context) showPromptInfo;
  Function(BuildContext context, CollectWeb collectWeb) pushWebPage;
  Function(BuildContext context, CollectWeb collectWeb) cancelCollect;
  Function(BuildContext context, CollectWeb collectWeb, Map<String, String> params) editCollectWeb;
  Function(BuildContext context, Map<String, String> params) addCollectWeb;
  List<CollectWeb> collectWebs;
  static CollectWebViewModule fromStore(Store<AppState> store) {
    var state = store.state.collectWebState;
    return CollectWebViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..collectWebs = state.collectWebs
      ..refreshData = () {
        store.dispatch(UpdateCollectWebListDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadCollectWebListDataAction());
      }
      ..pushWebPage = (context, collectWeb) {
        var params = <String, dynamic>{};
        params[webTitle] = collectWeb.name;
        params[webUrlKey] = collectWeb.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..cancelCollect = (context, collectWeb) {
        store.dispatch(cancelCollectAction(context, collectWeb));
      }
      ..showPromptInfo = (context) async {
        var isFirstEnterCollectWeb = await store.state.appDependency.sharedPreferences.getBool(isFirstEnterCollectWebKey);
        if (isFirstEnterCollectWeb == null || !isFirstEnterCollectWeb) {
          await showSuccessFlushBarMessage('左右滑动，删除或编辑收藏哦！', context, position: FlushbarPosition.BOTTOM);
        }
      }
      ..editCollectWeb = (context, collectWeb, params) {
        store.dispatch(editCollectAction(context, collectWeb, params));
      }
      ..addCollectWeb = (context, params) {
        store.dispatch(addCollectAction(context, params));
      };
  }
}
