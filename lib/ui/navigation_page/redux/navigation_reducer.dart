import 'package:flutterwanandroid/ui/navigation_page/redux/navigation_action.dart';
import 'package:flutterwanandroid/ui/navigation_page/redux/navigation_state.dart';
import 'package:redux/redux.dart';

final navigationPageReducer = combineReducers<NavigationState>([
  TypedReducer<NavigationState, NavigationPageStatusAction>(_navigationPageStatusActionReducer),
  TypedReducer<NavigationState, UpdateNavigationModuleAction>(_updateNavigationModuleActionReducer),
]);

NavigationState _navigationPageStatusActionReducer(NavigationState state, NavigationPageStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

NavigationState _updateNavigationModuleActionReducer(NavigationState state, UpdateNavigationModuleAction action) {
  return state.clone()
    ..navigationModule = action.navigationModule
    ..dataLoadStatus = action.dataLoadStatus;
}
