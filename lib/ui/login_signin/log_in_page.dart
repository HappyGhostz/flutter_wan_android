import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/ui/login_signin/login_srceen.dart';
import 'package:flutterwanandroid/ui/login_signin/login_view_module.dart';
import 'package:flutterwanandroid/ui/login_signin/signin_screen.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LoginModuleView>(
      converter: LoginModuleView.fromStore,
      builder: (context, viewModule) {
        return Scaffold(
          appBar: AppBar(
            title: Text('登陆/注册'),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  viewModule.exitApp();
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
