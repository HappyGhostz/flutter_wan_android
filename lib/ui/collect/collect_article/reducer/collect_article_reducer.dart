import 'package:flutterwanandroid/ui/collect/collect_article/reducer/collect_article_action.dart';
import 'package:flutterwanandroid/ui/collect/collect_article/reducer/collect_article_state.dart';
import 'package:redux/redux.dart';

final collectArticleReducer = combineReducers<CollectArticleState>([
  TypedReducer<CollectArticleState, UpdateCollectArticleListDataStatusAction>(_updateCollectArticleListDataStatusActionReducer),
  TypedReducer<CollectArticleState, UpdateCollectArticleListDataAction>(_updateCollectArticleListDataActionReducer),
  TypedReducer<CollectArticleState, UpdateCollectArticleIsPerformingRequestAction>(_updateCollectArticleIsPerformingRequestActionReducer),
  TypedReducer<CollectArticleState, UpdateCollectArticleListLoadMoreDataAction>(_updateCollectArticleListLoadMoreDataActionReducer),
  TypedReducer<CollectArticleState, UpdateArticleCollectsDataAction>(_updateArticleCollectsDataActionReducer),
]);

CollectArticleState _updateCollectArticleListDataStatusActionReducer(
    CollectArticleState state, UpdateCollectArticleListDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

CollectArticleState _updateCollectArticleListDataActionReducer(CollectArticleState state, UpdateCollectArticleListDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..collectArticles = action.collectArticles
    ..pageOffset = action.pageOffset;
}

CollectArticleState _updateCollectArticleIsPerformingRequestActionReducer(
    CollectArticleState state, UpdateCollectArticleIsPerformingRequestAction action) {
  return state.clone()..isPerformingRequest = action.isPerformingRequest;
}

CollectArticleState _updateCollectArticleListLoadMoreDataActionReducer(
    CollectArticleState state, UpdateCollectArticleListLoadMoreDataAction action) {
  return state.clone()
    ..isPerformingRequest = action.isPerformingRequest
    ..pageOffset = action.pageOffset
    ..collectArticles = action.collectArticles;
}

CollectArticleState _updateArticleCollectsDataActionReducer(CollectArticleState state, UpdateArticleCollectsDataAction action) {
  return state.clone()..collectArticles = action.collectArticles;
}
