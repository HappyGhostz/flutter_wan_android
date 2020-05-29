import 'package:flutterwanandroid/type/clone.dart';

class LoginState implements Cloneable<LoginState> {
  bool isLoggedIn;

  @override
  LoginState clone() {
    return LoginState()..isLoggedIn = isLoggedIn;
  }
}
