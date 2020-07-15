import 'package:flutterwanandroid/ui/integral/integra_private/reducer/integral_private_action.dart';
import 'package:flutterwanandroid/ui/integral/integra_private/reducer/integral_private_state.dart';
import 'package:redux/redux.dart';

final integralPrivateReducer = combineReducers<IntegralPrivateState>([
  TypedReducer<IntegralPrivateState, UpdateIntegralPrivateListDataStatusAction>(_updateIntegralPrivateListDataStatusActionReducer),
  TypedReducer<IntegralPrivateState, UpdateIntegralPrivateListDataAction>(_updateIntegralPrivateListDataActionReducer),
  TypedReducer<IntegralPrivateState, UpdateIntegralPrivateIsPerformingRequestAction>(
      _updateIntegralPrivateIsPerformingRequestActionReducer),
  TypedReducer<IntegralPrivateState, UpdateIntegralPrivateListLoadMoreDataAction>(_updateIntegralPrivateListLoadMoreDataActionReducer),
]);

IntegralPrivateState _updateIntegralPrivateListDataStatusActionReducer(
    IntegralPrivateState state, UpdateIntegralPrivateListDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

IntegralPrivateState _updateIntegralPrivateListDataActionReducer(IntegralPrivateState state, UpdateIntegralPrivateListDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..integralPrivates = action.integralPrivates
    ..pageOffset = action.pageOffset;
}

IntegralPrivateState _updateIntegralPrivateIsPerformingRequestActionReducer(
    IntegralPrivateState state, UpdateIntegralPrivateIsPerformingRequestAction action) {
  return state.clone()..isPerformingRequest = action.isPerformingRequest;
}

IntegralPrivateState _updateIntegralPrivateListLoadMoreDataActionReducer(
    IntegralPrivateState state, UpdateIntegralPrivateListLoadMoreDataAction action) {
  return state.clone()
    ..isPerformingRequest = action.isPerformingRequest
    ..pageOffset = action.pageOffset
    ..integralPrivates = action.integralPrivates;
}
