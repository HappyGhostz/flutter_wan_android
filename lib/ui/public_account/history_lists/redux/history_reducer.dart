import 'package:flutterwanandroid/ui/public_account/history_lists/redux/history_action.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/redux/history_state.dart';
import 'package:redux/redux.dart';

final publicAccountHistoryPageReducer = combineReducers<PublicAccountHistoryState>([
  TypedReducer<PublicAccountHistoryState, PublicAccountHistoryDataStatusAction>(_publicAccountHistoryDataStatusActionReducer),
  TypedReducer<PublicAccountHistoryState, UpdatePublicAccountHistoryDataAction>(_updatePublicAccountHistoryDataActionReducer),
  TypedReducer<PublicAccountHistoryState, UpdatePublicAccountMoreHistoryDataAction>(_updatePublicAccountMoreHistoryDataActionReducer),
  TypedReducer<PublicAccountHistoryState, HistoryChangePerformingRequestStatusAction>(_historyChangePerformingRequestStatusActionRedcer),
]);

PublicAccountHistoryState _publicAccountHistoryDataStatusActionReducer(
    PublicAccountHistoryState state, PublicAccountHistoryDataStatusAction action) {
  return state.clone()..publicAccountHistoryStatus = action.dataLoadStatus;
}

PublicAccountHistoryState _updatePublicAccountHistoryDataActionReducer(
    PublicAccountHistoryState state, UpdatePublicAccountHistoryDataAction action) {
  return state.clone()
    ..publicAccountHistoryStatus = action.dataLoadStatus
    ..publicAccountHistoryListModule = action.data
    ..pageOffset = action.pageOffset;
}

PublicAccountHistoryState _updatePublicAccountMoreHistoryDataActionReducer(
    PublicAccountHistoryState state, UpdatePublicAccountMoreHistoryDataAction action) {
  return state.clone()
    ..publicAccountHistoryListModule = action.data
    ..pageOffset = action.pageOffset
    ..isPerformingRequest = action.isPerFormingValue;
}

PublicAccountHistoryState _historyChangePerformingRequestStatusActionRedcer(
    PublicAccountHistoryState state, HistoryChangePerformingRequestStatusAction action) {
  return state.clone()..isPerformingRequest = action.isPerFormingValue;
}
