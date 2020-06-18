import 'package:flutterwanandroid/ui/author/redux/author_action.dart';
import 'package:flutterwanandroid/ui/author/redux/author_state.dart';
import 'package:redux/redux.dart';

var authorReducer = combineReducers<AuthorState>([
  TypedReducer<AuthorState, UpdateAuthorCollectsDataAction>(_updateCollectsDataActionReducer),
  TypedReducer<AuthorState, ChangeAuthorPageStatusAction>(_changePageStatusReducer),
  TypedReducer<AuthorState, LoadMoreAuthorDataAction>(_loadMoreAuthorDataActionReducer),
  TypedReducer<AuthorState, UpdateAuthorDataAction>(_updateAuthorDataActionReducer),
  TypedReducer<AuthorState, ChangeAuthorPerformingRequestStatusAction>(_changePerformingRequestStatusActionReducer),
]);

AuthorState _updateCollectsDataActionReducer(AuthorState state, UpdateAuthorCollectsDataAction action) {
  if (state.collectIndexs == null) {
    return state.clone()..collectIndexs = action.collects;
  } else {
    state.collectIndexs.addAll(action.collects);
    return state.clone();
  }
}

AuthorState _changePageStatusReducer(AuthorState state, ChangeAuthorPageStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

AuthorState _loadMoreAuthorDataActionReducer(AuthorState state, LoadMoreAuthorDataAction action) {
  if (action.isLoadMore) {
    return state.clone()
      ..articleModule = action.articleModule
      ..isPerformingRequest = action.isChangePerformingRequestStatus
      ..pageOffset = action.pageOffset;
  } else {
    return state.clone()..isPerformingRequest = action.isChangePerformingRequestStatus;
  }
}

AuthorState _updateAuthorDataActionReducer(AuthorState state, UpdateAuthorDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..articleModule = action.articleModule
    ..pageOffset = action.pageOffset;
}

AuthorState _changePerformingRequestStatusActionReducer(AuthorState state, ChangeAuthorPerformingRequestStatusAction action) {
  return state.clone()..isPerformingRequest = action.isChangePerformingRequestStatus;
}
