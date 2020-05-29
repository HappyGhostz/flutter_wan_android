import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/ui/login_signin/login_reducer.dart';
import 'package:flutterwanandroid/ui/splash/splash_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is Function) return state;
  if (action is UpdateSplashImgAction) {
    return state.clone()
      ..splashImg = action.img
      ..famousSentence = action.famousSentence;
  }
  return state.clone()
    ..splashState = splashReducer(state.splashState, action)
    ..loginState = loginReducer(state.loginState, action);
}
