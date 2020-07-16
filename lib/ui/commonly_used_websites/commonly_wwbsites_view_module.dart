import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/module/commonly_websites_module.dart';
import 'package:flutterwanandroid/ui/commonly_used_websites/reducer/commonly_websites_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class CommonlyUsedWebSitesViewModule {
  CommonlyUsedWebSitesViewModule({
    this.dataLoadStatus,
    this.pushWebPage,
    this.refresh,
    this.commonlyUsedWebSitesDatas,
  });

  DataLoadStatus dataLoadStatus;
  Function refresh;
  Function(BuildContext context, CommonlyUsedWebSitesData commonlyUsedWebSitesData) pushWebPage;
  List<CommonlyUsedWebSitesData> commonlyUsedWebSitesDatas;

  static CommonlyUsedWebSitesViewModule fromStore(Store<AppState> store) {
    var state = store.state.commonlyUsedWebSitesState;
    return CommonlyUsedWebSitesViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..commonlyUsedWebSitesDatas = state.commonlyUsedWebSitesDatas
      ..refresh = () {
        store.dispatch(CommonlyUsedWebSitesPageStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(initDataAction());
      }
      ..pushWebPage = (context, commonlyUsedWebSitesData) {
        var params = <String, dynamic>{};
        params[webTitle] = commonlyUsedWebSitesData.name;
        params[webUrlKey] = commonlyUsedWebSitesData.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      };
  }
}
