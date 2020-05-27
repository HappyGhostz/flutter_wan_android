import 'package:flutterwanandroid/type/clone.dart';

class SplashState implements Cloneable<SplashState> {
  SplashState({this.countTime});

  int countTime;

  @override
  SplashState clone() {
    return SplashState()..countTime = countTime;
  }
}
