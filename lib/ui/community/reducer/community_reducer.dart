import 'package:flutterwanandroid/ui/community/reducer/community_action.dart';
import 'package:flutterwanandroid/ui/community/reducer/community_state.dart';
import 'package:redux/redux.dart';

final communityReducer = combineReducers<CommunityState>([
  TypedReducer<CommunityState, UpdateCommunityDataStatusAction>(_updateCommunityDataStatusActionReducer),
  TypedReducer<CommunityState, UpdateCommunityDataAction>(_updateCommunityDataActionReducer),
  TypedReducer<CommunityState, UpdateCommunityIsPerformingRequestAction>(_updateCommunityIsPerformingRequestActionReducer),
  TypedReducer<CommunityState, UpdateCommunityLoadMoreDataAction>(_updateCommunityLoadMoreDataActionReducer),
  TypedReducer<CommunityState, UpdateCommunityCollectsDataAction>(_updateCommunityCollectsDataActionReducer),
]);

CommunityState _updateCommunityDataStatusActionReducer(CommunityState state, UpdateCommunityDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

CommunityState _updateCommunityDataActionReducer(CommunityState state, UpdateCommunityDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..communities = action.communities
    ..pageOffset = action.pageOffset;
}

CommunityState _updateCommunityIsPerformingRequestActionReducer(CommunityState state, UpdateCommunityIsPerformingRequestAction action) {
  return state.clone()..isPerformingRequest = action.isPerformingRequest;
}

CommunityState _updateCommunityLoadMoreDataActionReducer(CommunityState state, UpdateCommunityLoadMoreDataAction action) {
  return state.clone()
    ..communities = action.communities
    ..isPerformingRequest = action.isPerformingRequest
    ..pageOffset = action.pageOffset;
}

CommunityState _updateCommunityCollectsDataActionReducer(CommunityState state, UpdateCommunityCollectsDataAction action) {
  return state.clone()..collectIndexs = action.collects;
}
