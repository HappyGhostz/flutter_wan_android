import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/commonly_websites_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class CommonlyUsedWebSitesPageStatusAction {
  CommonlyUsedWebSitesPageStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class CommonlyUsedWebSitesModuleAction {
  CommonlyUsedWebSitesModuleAction({
    this.commonlyUsedWebSitesDatas,
    this.dataLoadStatus,
  });

  List<CommonlyUsedWebSitesData> commonlyUsedWebSitesDatas;
  DataLoadStatus dataLoadStatus;
}

ThunkAction<AppState> initDataAction() {
  return (Store<AppState> store) async {
    try {
      var commonlyUsedWebSitesResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.COMMONLY_USED_WEBSITES);
      var commonlyUsedWebSitesData = CommonlyUsedWebSitesResponseModule.fromJson(commonlyUsedWebSitesResponse.data);
      if (commonlyUsedWebSitesData == null ||
          commonlyUsedWebSitesData.commonlyUsedWebSitesDatas == null ||
          commonlyUsedWebSitesData.commonlyUsedWebSitesDatas.isEmpty) {
        store.dispatch(CommonlyUsedWebSitesPageStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (commonlyUsedWebSitesData.errorCode < 0) {
        store.dispatch(CommonlyUsedWebSitesPageStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(CommonlyUsedWebSitesModuleAction(
          dataLoadStatus: DataLoadStatus.loadCompleted,
          commonlyUsedWebSitesDatas: commonlyUsedWebSitesData.commonlyUsedWebSitesDatas,
        ));
      }
    } catch (e) {
      store.dispatch(CommonlyUsedWebSitesPageStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}
