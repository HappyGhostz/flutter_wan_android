import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/project/project_tab_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateProjectTabsAction {
  UpdateProjectTabsAction({
    this.projectTabData,
  });

  List<ProjectTabData> projectTabData;
}

ThunkAction<AppState> initTabBarData() {
  return (Store<AppState> store) async {
    try {
      var projectTabResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.PROJECT_TAB);
      var projectTabResponseModule = ProjectTabResponseModule.fromJson(projectTabResponse.data);
      if (projectTabResponseModule.errorCode == 0) {
        store.dispatch(UpdateProjectTabsAction(projectTabData: projectTabResponseModule.projectTabData));
      } else {
        store.dispatch(UpdateProjectTabsAction(projectTabData: null));
      }
    } catch (e) {
      store.dispatch(UpdateProjectTabsAction(projectTabData: null));
    }
  };
}
