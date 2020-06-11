import 'package:dio/dio.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/navigation/navigation_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class NavigationPageStatusAction {
  NavigationPageStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateNavigationModuleAction {
  UpdateNavigationModuleAction({
    this.navigationModule,
    this.dataLoadStatus,
  });

  NavigationModule navigationModule;
  DataLoadStatus dataLoadStatus;
}

ThunkAction<AppState> initNavigationDataAction() {
  return (Store<AppState> store) async {
    try {
      var navigationResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.NAVIGATION);
      if (navigationResponse == null) {
        store.dispatch(NavigationPageStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        var navigationModule = NavigationModule.fromJson(navigationResponse.data);
        if (navigationModule == null || navigationModule.navigationData == null || navigationModule.navigationData.isEmpty) {
          store.dispatch(NavigationPageStatusAction(dataLoadStatus: DataLoadStatus.empty));
        } else {
          store.dispatch(UpdateNavigationModuleAction(navigationModule: navigationModule, dataLoadStatus: DataLoadStatus.loadCompleted));
        }
      }
    } on DioError catch (e) {
      store.dispatch(NavigationPageStatusAction(dataLoadStatus: DataLoadStatus.failure));
    } catch (e) {
      store.dispatch(NavigationPageStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}
