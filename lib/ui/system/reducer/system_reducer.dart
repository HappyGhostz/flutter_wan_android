import 'package:flutterwanandroid/ui/system/reducer/system_action.dart';
import 'package:flutterwanandroid/ui/system/reducer/system_state.dart';
import 'package:redux/redux.dart';

var systemReducer = combineReducers<SystemState>([
  TypedReducer<SystemState, UpdateSystemTreeDatasAction>(_updateSystemTreeDatasActionReducer),
  TypedReducer<SystemState, UpdateSelectTabIndexAction>(_updateSelectTabIndexActionReducer),
]);

SystemState _updateSystemTreeDatasActionReducer(SystemState state, UpdateSystemTreeDatasAction action) {
  return state.clone()..systemTreeDatas = action.systemTreeDatas;
}

SystemState _updateSelectTabIndexActionReducer(SystemState state, UpdateSelectTabIndexAction action) {
  return state.clone()..selectTabIndex = action.index;
}
