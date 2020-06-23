import 'package:flutterwanandroid/ui/search/redux/search_action.dart';
import 'package:flutterwanandroid/ui/search/redux/search_state.dart';
import 'package:redux/redux.dart';

var searchReducer = combineReducers<SearchState>([
  TypedReducer<SearchState, SearchStatusChangedAction>(_searchStatusChangedActionReducer),
  TypedReducer<SearchState, SearchUpdateHotKeyModuleAction>(_searchUpdateHotKeyModuleActionReducer),
  TypedReducer<SearchState, UpdateHistorySearchAction>(_updateHistorySearchActionReducer),
  TypedReducer<SearchState, UpdateEditStatusAction>(_updateEditStatusActionReducer),
  TypedReducer<SearchState, UpdateSearchResultModuleAction>(_updateSearchResultModuleActionReducer),
  TypedReducer<SearchState, ChangeSearchPerformingRequestStatusAction>(_changeSearchPerformingRequestStatusActionReducer),
  TypedReducer<SearchState, SearchLoadMoreAction>(_searchLoadMoreActionReducer),
  TypedReducer<SearchState, ClearDataAction>(_clearDataActionReducer),
  TypedReducer<SearchState, UpdateSearchCollectsDataAction>(_updateSearchCollectsDataActionReducer),
]);

SearchState _searchStatusChangedActionReducer(SearchState state, SearchStatusChangedAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

SearchState _searchUpdateHotKeyModuleActionReducer(SearchState state, SearchUpdateHotKeyModuleAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..searchHotKeyResponseModule = action.searchHotKeyResponseModule;
}

SearchState _updateHistorySearchActionReducer(SearchState state, UpdateHistorySearchAction action) {
  return state.clone()..historyList = action.historyList;
}

SearchState _updateEditStatusActionReducer(SearchState state, UpdateEditStatusAction action) {
  return state.clone()..isEditing = action.isEdit;
}

SearchState _updateSearchResultModuleActionReducer(SearchState state, UpdateSearchResultModuleAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..searchResultResponseModule = action.searchResultResponseModule
    ..pageOffset = action.pageOffset
    ..keyWord = action.keyWord;
}

SearchState _changeSearchPerformingRequestStatusActionReducer(SearchState state, ChangeSearchPerformingRequestStatusAction action) {
  return state.clone()..isPerformingRequest = action.isPerforming;
}

SearchState _searchLoadMoreActionReducer(SearchState state, SearchLoadMoreAction action) {
  return state.clone()
    ..searchResultResponseModule = action.searchResultResponseModule
    ..pageOffset = action.pageOffset
    ..isPerformingRequest = action.isPerforming;
}

SearchState _clearDataActionReducer(SearchState state, ClearDataAction action) {
  return state.clone()
    ..searchResultResponseModule = null
    ..keyWord = '';
}

SearchState _updateSearchCollectsDataActionReducer(SearchState state, UpdateSearchCollectsDataAction action) {
  if (state.collectIndexs == null) {
    return state.clone()..collectIndexs = action.collectIndexs;
  } else {
    state.collectIndexs.addAll(action.collectIndexs);
    return state.clone();
  }
}
