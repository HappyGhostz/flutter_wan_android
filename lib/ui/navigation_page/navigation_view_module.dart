import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/navigation/navigation_module.dart';
import 'package:flutterwanandroid/ui/navigation_page/redux/navigation_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';

class NavigationViewModule {
  NavigationViewModule({
    this.dataLoadStatus,
    this.navigationModule,
  });

  DataLoadStatus dataLoadStatus;
  NavigationModule navigationModule;
  Function() refresh;

  static NavigationViewModule fromStore(Store<AppState> store) {
    var state = store.state.navigationState;
    return NavigationViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..navigationModule = state.navigationModule
      ..refresh = () {
        store.dispatch(NavigationPageStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(initNavigationDataAction());
      };
  }
}
