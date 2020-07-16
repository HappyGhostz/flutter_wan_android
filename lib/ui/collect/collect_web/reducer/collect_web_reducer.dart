import 'package:flutterwanandroid/ui/collect/collect_web/reducer/collect_web_action.dart';
import 'package:flutterwanandroid/ui/collect/collect_web/reducer/collect_web_state.dart';
import 'package:redux/redux.dart';

final collectWebReducer = combineReducers<CollectWebState>([
  TypedReducer<CollectWebState, UpdateCollectWebListDataStatusAction>(_updateCollectWebListDataStatusActionReducer),
  TypedReducer<CollectWebState, UpdateCollectWebListDataAction>(_updateCollectWebListDataActionReducer),
  TypedReducer<CollectWebState, UpdateWebCollectsDataAction>(_updateWebCollectsDataActionReducer),
]);

CollectWebState _updateCollectWebListDataStatusActionReducer(CollectWebState state, UpdateCollectWebListDataStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

CollectWebState _updateCollectWebListDataActionReducer(CollectWebState state, UpdateCollectWebListDataAction action) {
  return state.clone()
    ..dataLoadStatus = action.dataLoadStatus
    ..collectWebs = action.collectWebs;
}

CollectWebState _updateWebCollectsDataActionReducer(CollectWebState state, UpdateWebCollectsDataAction action) {
  return state.clone()..collectWebs = action.collectWebs;
}
