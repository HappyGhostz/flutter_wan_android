import 'package:flutterwanandroid/ui/project/reducer/project_action.dart';
import 'package:flutterwanandroid/ui/project/reducer/project_state.dart';
import 'package:redux/redux.dart';

var projectReducer = combineReducers<ProjectState>([
  TypedReducer<ProjectState, UpdateProjectTabsAction>(_updateProjectTabsActionReducer),
]);

ProjectState _updateProjectTabsActionReducer(ProjectState state, UpdateProjectTabsAction action) {
  return state.clone()..projectTabData = action.projectTabData;
}
