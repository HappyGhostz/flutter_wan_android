import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/photo_hero.dart';
import 'package:flutterwanandroid/custom_widget/vertival_text.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
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
        viewModule.updateSplashImg();
      },
      builder: (context, viewModule) => Scaffold(
        body: Stack(
          children: <Widget>[
            HeroPhoto(
              photo: viewModule.splashImg,
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
            Positioned(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: 60,
                margin: EdgeInsets.all(10.0),
                child: CustomPaint(
                  painter: VerticalText(
                    text: viewModule.famousSentence[0],
                    textStyle: AppTextStyle.liShuBody(),
                    height: MediaQuery.of(context).size.height / 2,
                    width: 60,
                  ),
                ),
              ),
              top: MediaQuery.of(context).size.height / 6,
              right: 48.0,
            ),
            Positioned(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: 60,
                margin: EdgeInsets.all(10.0),
                child: CustomPaint(
                  painter: VerticalText(
                    text: viewModule.famousSentence[1],
                    textStyle: AppTextStyle.liShuBody(),
                    height: MediaQuery.of(context).size.height / 2,
                    width: 60,
                  ),
                ),
              ),
              top: MediaQuery.of(context).size.height / 6,
              right: 24.0,
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
    RouterUtil.pushNameAndRemove(context, AppRouter.homeRouterName);
  }
}
