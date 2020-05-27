import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/ui/splash/splash_state.dart';

class AppState implements Cloneable<AppState> {
  AppState({this.splashState});
  SplashState splashState;

  @override
  AppState clone() {
    return AppState()..splashState = splashState;
  }
}
