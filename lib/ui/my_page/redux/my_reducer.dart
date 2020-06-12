import 'package:flutterwanandroid/ui/my_page/redux/my_page_action.dart';
import 'package:flutterwanandroid/ui/my_page/redux/my_state.dart';
import 'package:redux/redux.dart';

final myPageReducer = combineReducers<MyState>([
  TypedReducer<MyState, UpdateLoginStatusAction>(_updateLoginStatusActionReducer),
  TypedReducer<MyState, UpdateIntegralAction>(_updateIntegralActionReducer),
  TypedReducer<MyState, UpdateWebCollectDataAction>(_updateWebCollectDataActionReducer),
  TypedReducer<MyState, UpdateCollectDataAction>(_updateCollectDataActionReducer),
  TypedReducer<MyState, UpdateMyShareDataAction>(_updateMyShareDataActionReducer),
  TypedReducer<MyState, UpdateRefreshStatusAction>(_updateRefreshStatusActionReducer),
  TypedReducer<MyState, LogoutAction>(_logoutActionReducer),
]);

MyState _updateLoginStatusActionReducer(MyState state, UpdateLoginStatusAction action) {
  return state.clone()
    ..isLogin = action.isLogin
    ..name = action.name;
}

MyState _updateRefreshStatusActionReducer(MyState state, UpdateRefreshStatusAction action) {
  return state.clone()..isRefresh = action.isRefresh;
}

MyState _updateIntegralActionReducer(MyState state, UpdateIntegralAction action) {
  return state.clone()..integralModule = action.integralModule;
}

MyState _updateWebCollectDataActionReducer(MyState state, UpdateWebCollectDataAction action) {
  return state.clone()..webCollectModule = action.webCollectModule;
}

MyState _updateCollectDataActionReducer(MyState state, UpdateCollectDataAction action) {
  return state.clone()..articleCollectModule = action.articleCollectModule;
}

MyState _updateMyShareDataActionReducer(MyState state, UpdateMyShareDataAction action) {
  return state.clone()..myShareModule = action.myShareModule;
}

MyState _logoutActionReducer(MyState state, LogoutAction action) {
  action.showLogoutDialog();
  return state;
}
