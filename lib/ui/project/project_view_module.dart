import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/project/project_tab_module.dart';
import 'package:redux/redux.dart';

class ProjectViewModule {
  ProjectViewModule({
    this.projectTabData,
  });

  List<ProjectTabData> projectTabData;

  static ProjectViewModule fromStore(Store<AppState> store) {
    var state = store.state.projectState;
    return ProjectViewModule()..projectTabData = state.projectTabData;
  }
}
