import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is Function) return state;
  return state.clone()..splashState = splashReducer(state.splashState, action);
}
