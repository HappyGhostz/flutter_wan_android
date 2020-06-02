import 'package:flutterwanandroid/ui/login_signin/login_action.dart';
import 'package:flutterwanandroid/ui/login_signin/login_state.dart';
import 'package:redux/redux.dart';

final loginReducer = combineReducers<LoginState>([
  TypedReducer<LoginState, ChangeThePageTypeAction>(_changeThePageTypeReducer),
  TypedReducer<LoginState, ChangeThePasswordShowStatusAction>(_changeThePasswordShowStatus),
  TypedReducer<LoginState, ShowErrorInfoAction>(_isShowErrorInfoReducer),
  TypedReducer<LoginState, SignInResponseAction>(_signInResponseAction),
  TypedReducer<LoginState, ChangeTheRememberPasswordStatusAction>(_changeTheRememberPasswordStatusReducer),
  TypedReducer<LoginState, LoginResponseAction>(_loginResponseReducer),
]);

LoginState _changeThePageTypeReducer(LoginState state, ChangeThePageTypeAction action) {
  return state.clone()..isLoggedIn = action.isLoggedIn;
}

LoginState _changeThePasswordShowStatus(LoginState state, ChangeThePasswordShowStatusAction action) {
  return state.clone()..isShowPassword = !state.isShowPassword;
}

LoginState _isShowErrorInfoReducer(LoginState state, ShowErrorInfoAction action) {
  return state.clone()..confirmPasswordIsError = action.isShowErrorInfo;
}

LoginState _signInResponseAction(LoginState state, SignInResponseAction action) {
  action.showSignInDialog();
  return state;
}

LoginState _loginResponseReducer(LoginState state, LoginResponseAction action) {
  action.successLogin();
  return state;
}

LoginState _changeTheRememberPasswordStatusReducer(LoginState state, ChangeTheRememberPasswordStatusAction action) {
  return state.clone()..isRememberPassword = action.isRememberPassword;
}
