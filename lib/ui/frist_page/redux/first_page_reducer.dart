import 'package:flutterwanandroid/ui/frist_page/redux/first_page_action.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_state.dart';
import 'package:redux/redux.dart';

final firstPageReducer = combineReducers<FirstPageState>([
  TypedReducer<FirstPageState, ChangePageStatusAction>(_changePageStatusReducer),
  TypedReducer<FirstPageState, UpdateFirstDataAction>(_updateFirstDataReducer),
  TypedReducer<FirstPageState, ChangePerformingRequestStatusAction>(_changePerformingRequestStatusReducer),
  TypedReducer<FirstPageState, LoadMoreFirstDataAction>(_loadMoreFirstDataReducer),
  TypedReducer<FirstPageState, ChangeNameViewColorAction>(_changeNameViewColorReducer),
  TypedReducer<FirstPageState, ChangeTagViewColorAction>(_changeTagViewColorReducer),
  TypedReducer<FirstPageState, ChangeTypeViewColorAction>(_changeTypeViewColorReducer),
  TypedReducer<FirstPageState, UpdateCollectsDataAction>(_updateCollectsDataActionReducer),
]);

FirstPageState _changePageStatusReducer(FirstPageState state, ChangePageStatusAction action) {
  return state.clone()..firstPageStatus = action.dataLoadStatus;
}

FirstPageState _updateFirstDataReducer(FirstPageState state, UpdateFirstDataAction action) {
  return state.clone()
    ..firstPageModule = action.firstPageModule
    ..pageOffset = action.pageOffset
    ..firstPageStatus = action.dataLoadStatus;
}

FirstPageState _changePerformingRequestStatusReducer(FirstPageState state, ChangePerformingRequestStatusAction action) {
  return state.clone()..isPerformingRequest = action.isChangePerformingRequestStatus;
}

FirstPageState _loadMoreFirstDataReducer(FirstPageState state, LoadMoreFirstDataAction action) {
  return state.clone()
    ..isPerformingRequest = action.isChangePerformingRequestStatus
    ..pageOffset = action.pageOffset
    ..firstPageModule = action.firstPageModule;
}

FirstPageState _changeNameViewColorReducer(FirstPageState state, ChangeNameViewColorAction action) {
  return state.clone()..tabBackgroundNameColor = action.changeColor;
}

FirstPageState _changeTagViewColorReducer(FirstPageState state, ChangeTagViewColorAction action) {
  return state.clone()
    ..tabBackgroundTagViewColor = action.changeColor
    ..tagTextInfoColor = action.textInfoColor;
}

FirstPageState _changeTypeViewColorReducer(FirstPageState state, ChangeTypeViewColorAction action) {
  return state.clone()..tabBackgroundTypeColor = action.changeColor;
}

FirstPageState _updateCollectsDataActionReducer(FirstPageState state, UpdateCollectsDataAction action) {
  if (state.collectIndexs == null) {
    return state.clone()..collectIndexs = action.collects;
  } else {
    state.collectIndexs.addAll(action.collects);
    return state.clone();
  }
}
