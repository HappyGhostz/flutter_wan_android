import 'package:flutterwanandroid/ui/commonly_used_websites/reducer/commonly_websites_action.dart';
import 'package:flutterwanandroid/ui/commonly_used_websites/reducer/commonly_websites_state.dart';
import 'package:redux/redux.dart';

final commonlyWebSitesReducer = combineReducers<CommonlyUsedWebSitesState>([
  TypedReducer<CommonlyUsedWebSitesState, CommonlyUsedWebSitesPageStatusAction>(_commonlyUsedWebSitesPageStatusActionReducer),
  TypedReducer<CommonlyUsedWebSitesState, CommonlyUsedWebSitesModuleAction>(_commonlyUsedWebSitesModuleActionReducer),
]);

CommonlyUsedWebSitesState _commonlyUsedWebSitesPageStatusActionReducer(
    CommonlyUsedWebSitesState state, CommonlyUsedWebSitesPageStatusAction action) {
  return state.clone()..dataLoadStatus = action.dataLoadStatus;
}

CommonlyUsedWebSitesState _commonlyUsedWebSitesModuleActionReducer(
    CommonlyUsedWebSitesState state, CommonlyUsedWebSitesModuleAction action) {
  return state.clone()
    ..commonlyUsedWebSitesDatas = action.commonlyUsedWebSitesDatas
    ..dataLoadStatus = action.dataLoadStatus;
}
