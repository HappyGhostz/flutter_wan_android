import 'package:flutterwanandroid/ui/splash/splash_action.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';
import 'package:redux/redux.dart';

final splashReducer = combineReducers<SplashState>([
  TypedReducer<SplashState, SplashAction>(_changeCountDownTimeReducer),
]);

SplashState _changeCountDownTimeReducer(SplashState state, SplashAction action) {
  return state.clone()..countTime = action.countDownTime;
}
