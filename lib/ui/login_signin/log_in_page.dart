import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/ui/login_signin/login_srceen.dart';
import 'package:flutterwanandroid/ui/login_signin/login_view_module.dart';
import 'package:flutterwanandroid/ui/login_signin/signin_screen.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginModuleView>(
      onInit: (store) {
        store.state.loginState.isShowPassword = true;
        store.state.loginState.isRememberPassword = true;
        store.state.loginState.isLoggedIn = true;
        store.state.loginState.confirmPasswordIsError = false;
        store.state.loginState.userName = store.state.appDependency.sharedPreferences.getString(userNameKey);
        store.state.loginState.userPassword = store.state.appDependency.sharedPreferences.getString(userPasswordKey);
      },
      converter: LoginModuleView.fromStore,
      builder: (context, viewModule) {
        return Scaffold(
          appBar: AppBar(
            title: Text('登陆/注册'),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 1000),
            reverse: viewModule.isLoggedIn,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
              );
            },
            child: !viewModule.isLoggedIn
                ? SignInScreen(
                    viewModule: viewModule,
                  )
                : LoginScreen(
                    viewModule: viewModule,
                  ),
          ),
        );
      },
    );
  }
}
