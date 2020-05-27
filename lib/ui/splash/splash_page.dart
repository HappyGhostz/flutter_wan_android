import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_view_module.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SplashViewModule>(
      distinct: true,
      converter: (store) {
        return SplashViewModule.fromStore(store, endTimeListener: () {
          pushNextPage(context);
        });
      },
      onInit: (store) {
        SystemChrome.setEnabledSystemUIOverlays([]);
        store.state.splashState.countTime = 5;
      },
      onInitialBuild: (viewModule) {
        viewModule.downTime();
      },
      builder: (context, viewModule) => Scaffold(
        body: Stack(
          children: <Widget>[
            Image.asset(
              'assets/splash_wan_android.gif',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  pushNextPage(context);
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text('倒计时:${viewModule.countDownTime}'),
                ),
              ),
              top: 2.0,
              right: 2.0,
            ),
          ],
        ),
      ),
    );
  }

  void pushNextPage(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    var systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    RouterUtil.pushNameAndRemove(context, AppRouter.loginRouterName);
  }
}
