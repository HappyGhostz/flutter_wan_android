import 'package:flutterwanandroid/ui/share/share_private/reducer/share_private_action.dart';
import 'package:flutterwanandroid/ui/share/share_private/reducer/share_private_state.dart';
import 'package:redux/redux.dart';

final sharePrivateReducer = combineReducers<SharePrivateState>([
  TypedReducer<SharePrivateState, UpdateSharePrivateDataStatusAction>(_updateSharePrivateDataStatusActionReducer),
  TypedReducer<SharePrivateState, UpdateSharePrivateDataAction>(_updateSharePrivateDataActionReducer),
  TypedReducer<SharePrivateState, UpdateSharePrivateIsPerformingRequestAction>(_updateSharePrivateIsPerformingRequestActionReducer),
  TypedReducer<SharePrivateState, UpdateSharePrivateLoadMoreDataAction>(_updateSharePrivateLoadMoreDataActionReducer),
  TypedReducer<SharePrivateState, UpdateShareArticleDataAction>(_updateShareArticleDataActionReducer),
]);

SharePrivateState _updateSharePrivateDataStatusActionReducer(SharePrivateState state, UpdateSharePrivateDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

SharePrivateState _updateSharePrivateDataActionReducer(SharePrivateState state, UpdateSharePrivateDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..pageOffset = action.pageOffset
    ..shareOtherData = action.shareOtherData;
}

SharePrivateState _updateSharePrivateIsPerformingRequestActionReducer(
    SharePrivateState state, UpdateSharePrivateIsPerformingRequestAction action) {
  return state.clone()..isPerformingRequest = action.isPerformingRequest;
}

SharePrivateState _updateSharePrivateLoadMoreDataActionReducer(SharePrivateState state, UpdateSharePrivateLoadMoreDataAction action) {
  return state.clone()
    ..isPerformingRequest = action.isPerformingRequest
    ..shareOtherData = action.shareOtherData
    ..pageOffset = action.pageOffset;
}

SharePrivateState _updateShareArticleDataActionReducer(SharePrivateState state, UpdateShareArticleDataAction action) {
  return state.clone()..shareOtherData = action.shareOtherData;
}
