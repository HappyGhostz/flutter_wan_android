import 'package:flutterwanandroid/ui/public_account/redux/public_account_action.dart';
import 'package:flutterwanandroid/ui/public_account/redux/public_account_state.dart';
import 'package:redux/redux.dart';

final publicAccountPageReducer = combineReducers<PublicAccountState>([
  TypedReducer<PublicAccountState, UpdateTabBarDataAction>(_updateTabBarDataActionReducer),
  TypedReducer<PublicAccountState, PublicAccountTabBarDataErrorAction>(_publicAccountTabBarDataErrorActionReducer),
]);

PublicAccountState _updateTabBarDataActionReducer(PublicAccountState state, UpdateTabBarDataAction action) {
  return state.clone()..publicAccountTabBarModule = action.module;
}

PublicAccountState _publicAccountTabBarDataErrorActionReducer(PublicAccountState state, PublicAccountTabBarDataErrorAction action) {
  action.showErrorDialog();
  return state;
}
