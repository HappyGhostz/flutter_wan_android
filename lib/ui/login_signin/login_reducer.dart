import 'package:flutterwanandroid/ui/login_signin/login_action.dart';
import 'package:flutterwanandroid/ui/login_signin/login_state.dart';

LoginState loginReducer(LoginState state, dynamic action) {
  if (action is ChangeThePageTypeAction) {
    return state.clone()..isLoggedIn = action.isLoggedIn;
  }
  return state;
}
