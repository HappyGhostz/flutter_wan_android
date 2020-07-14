import 'package:flutterwanandroid/ui/system/system_list/reducer/system_list_action.dart';
import 'package:flutterwanandroid/ui/system/system_list/reducer/system_list_state.dart';
import 'package:redux/redux.dart';

var systemListReducer = combineReducers<SystemListState>([
  TypedReducer<SystemListState, UpdateSystemListDataStatusAction>(_updateSystemListDataStatusActionReducer),
  TypedReducer<SystemListState, UpdateSystemListDataAction>(_updateSystemListDataActionReducer),
  TypedReducer<SystemListState, UpdateIsPerformingRequestAction>(_updateIsPerformingRequestActionReducer),
  TypedReducer<SystemListState, UpdateSystemListLoadMoreDataAction>(_updateSystemListLoadMoreDataActionReducer),
  TypedReducer<SystemListState, UpdateSystemListCollectsDataAction>(_updateSystemListCollectsDataActionReducer),
]);

SystemListState _updateSystemListDataStatusActionReducer(SystemListState state, UpdateSystemListDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

SystemListState _updateSystemListDataActionReducer(SystemListState state, UpdateSystemListDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..systemLists = action.systemLists
    ..pageOffset = action.pageOffset;
}

SystemListState _updateIsPerformingRequestActionReducer(SystemListState state, UpdateIsPerformingRequestAction action) {
  return state.clone()..isPerformingRequest = action.isPerformingRequest;
}

SystemListState _updateSystemListLoadMoreDataActionReducer(SystemListState state, UpdateSystemListLoadMoreDataAction action) {
  return state.clone()
    ..systemLists = action.systemLists
    ..isPerformingRequest = action.isPerformingRequest
    ..pageOffset = action.pageOffset;
}

SystemListState _updateSystemListCollectsDataActionReducer(SystemListState state, UpdateSystemListCollectsDataAction action) {
  if (state.collectIndexs == null) {
    return state.clone()..collectIndexs = action.isCollects;
  } else {
    state.collectIndexs.addAll(action.isCollects);
    return state.clone();
  }
}
