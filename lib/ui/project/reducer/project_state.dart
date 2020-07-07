import 'package:flutterwanandroid/module/project/project_tab_module.dart';
import 'package:flutterwanandroid/type/clone.dart';

class ProjectState extends Cloneable<ProjectState> {
  List<ProjectTabData> projectTabData;

  @override
  ProjectState clone() {
    return ProjectState()..projectTabData = projectTabData;
  }
}
