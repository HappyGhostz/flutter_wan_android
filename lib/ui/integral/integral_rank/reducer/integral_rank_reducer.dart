import 'package:flutterwanandroid/ui/integral/integral_rank/reducer/integral_rank_action.dart';
import 'package:flutterwanandroid/ui/integral/integral_rank/reducer/integral_rank_state.dart';
import 'package:redux/redux.dart';

final integralRankReducer = combineReducers<IntegralRankState>([
  TypedReducer<IntegralRankState, UpdateIntegralRankListDataStatusAction>(_updateIntegralRankListDataStatusActionReducer),
  TypedReducer<IntegralRankState, UpdateIntegralRankListDataAction>(_updateIntegralRankListDataActionReducer),
  TypedReducer<IntegralRankState, UpdateIntegralRankIsPerformingRequestAction>(_updateIntegralRankIsPerformingRequestActionReducer),
  TypedReducer<IntegralRankState, UpdateIntegralRankListLoadMoreDataAction>(_updateIntegralRankListLoadMoreDataActionReducer),
]);

IntegralRankState _updateIntegralRankListDataStatusActionReducer(IntegralRankState state, UpdateIntegralRankListDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

IntegralRankState _updateIntegralRankListDataActionReducer(IntegralRankState state, UpdateIntegralRankListDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..integralRanks = action.integralRanks
    ..pageOffset = action.pageOffset;
}

IntegralRankState _updateIntegralRankIsPerformingRequestActionReducer(
    IntegralRankState state, UpdateIntegralRankIsPerformingRequestAction action) {
  return state.clone()..isPerformingRequest = action.isPerformingRequest;
}

IntegralRankState _updateIntegralRankListLoadMoreDataActionReducer(
    IntegralRankState state, UpdateIntegralRankListLoadMoreDataAction action) {
  return state.clone()
    ..isPerformingRequest = action.isPerformingRequest
    ..pageOffset = action.pageOffset
    ..integralRanks = action.integralRanks;
}
