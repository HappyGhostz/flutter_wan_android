import 'package:flutterwanandroid/ui/wen_da/reducer/wen_da_action.dart';
import 'package:flutterwanandroid/ui/wen_da/reducer/wen_da_state.dart';
import 'package:redux/redux.dart';

final wendaReducer = combineReducers<WendaState>([
  TypedReducer<WendaState, UpdateWendaListDataStatusAction>(_updateWendaListDataStatusActionReducer),
  TypedReducer<WendaState, UpdateWendaListDataAction>(_updateWendaListDataActionReducer),
  TypedReducer<WendaState, UpdateWendaIsPerformingRequestAction>(_updateWendaIsPerformingRequestActionReducer),
  TypedReducer<WendaState, UpdateWendaListLoadMoreDataAction>(_updateWendaListLoadMoreDataActionReducer),
  TypedReducer<WendaState, UpdateWendaListCollectsDataAction>(_updateWendaListCollectsDataActionReducer),
]);

WendaState _updateWendaListDataStatusActionReducer(WendaState state, UpdateWendaListDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

WendaState _updateWendaListDataActionReducer(WendaState state, UpdateWendaListDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..pageOffset = action.pageOffset
    ..wendaLists = action.wendaLists;
}

WendaState _updateWendaIsPerformingRequestActionReducer(WendaState state, UpdateWendaIsPerformingRequestAction action) {
  return state.clone()..isPerformingRequest = action.isPerformingRequest;
}

WendaState _updateWendaListLoadMoreDataActionReducer(WendaState state, UpdateWendaListLoadMoreDataAction action) {
  return state.clone()
    ..isPerformingRequest = action.isPerformingRequest
    ..wendaLists = action.wendaLists
    ..pageOffset = action.pageOffset;
}

WendaState _updateWendaListCollectsDataActionReducer(WendaState state, UpdateWendaListCollectsDataAction action) {
  if (state.collectIndexs == null) {
    return state.clone()..collectIndexs = action.isCollects;
  } else {
    state.collectIndexs.addAll(action.isCollects);
    return state.clone();
  }
}
