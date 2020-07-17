import 'package:flutterwanandroid/ui/share/share_other/reducer/share_other_action.dart';
import 'package:flutterwanandroid/ui/share/share_other/reducer/share_other_state.dart';
import 'package:redux/redux.dart';

final shareOtherReducer = combineReducers<ShareOtherState>([
  TypedReducer<ShareOtherState, UpdateShareOtherDataStatusAction>(_updateShareOtherDataStatusActionReducer),
  TypedReducer<ShareOtherState, UpdateShareOtherDataAction>(_updateShareOtherDataActionReducer),
  TypedReducer<ShareOtherState, UpdateShareOtherIsPerformingRequestAction>(_updateShareOtherIsPerformingRequestActionReducer),
  TypedReducer<ShareOtherState, UpdateShareOtherLoadMoreDataAction>(_updateShareOtherLoadMoreDataActionReducer),
  TypedReducer<ShareOtherState, UpdateShareCollectsDataAction>(_updateShareCollectsDataActionReducer),
]);

ShareOtherState _updateShareOtherDataStatusActionReducer(ShareOtherState state, UpdateShareOtherDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

ShareOtherState _updateShareOtherDataActionReducer(ShareOtherState state, UpdateShareOtherDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..shareOtherData = action.shareOtherData
    ..pageOffset = action.pageOffset;
}

ShareOtherState _updateShareOtherIsPerformingRequestActionReducer(ShareOtherState state, UpdateShareOtherIsPerformingRequestAction action) {
  return state.clone()..isPerformingRequest = action.isPerformingRequest;
}

ShareOtherState _updateShareOtherLoadMoreDataActionReducer(ShareOtherState state, UpdateShareOtherLoadMoreDataAction action) {
  return state.clone()
    ..isPerformingRequest = action.isPerformingRequest
    ..shareOtherData = action.shareOtherData
    ..pageOffset = action.pageOffset;
}

ShareOtherState _updateShareCollectsDataActionReducer(ShareOtherState state, UpdateShareCollectsDataAction action) {
  return state.clone()..collectIndexs = action.collects;
}
