import 'package:flutterwanandroid/ui/splash/splash_action.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';

SplashState splashReducer(SplashState state, dynamic action) {
  if (action is SplashAction) {
    return state.clone()..countTime = action.countDownTime;
  }
  return state;
}
