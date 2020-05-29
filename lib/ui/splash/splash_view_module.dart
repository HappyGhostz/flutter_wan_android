import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_action.dart';
import 'package:flutterwanandroid/utils/solar_terms_util.dart';
import 'package:flutterwanandroid/utils/splash_img_choose_util.dart';
import 'package:redux/redux.dart';

typedef DispatcherTimerValue = void Function(int time);

class SplashViewModule extends Equatable {
  SplashViewModule({
    this.countDownTime,
    this.dispatcherTimerValue,
    this.nextPage,
    this.splashImg,
    this.updateSplashImg,
    this.famousSentence,
  });

  final int countDownTime;
  final String splashImg;
  final List<String> famousSentence;
  final DispatcherTimerValue dispatcherTimerValue;
  final Function() nextPage;
  final Function() updateSplashImg;

  static SplashViewModule fromStore(Store<AppState> store, {Function() endTimeListener}) {
    var solarTermsUtil = SolarTermsUtil();
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var year = DateTime.now().year;
    var name = solarTermsUtil.getSolatName(year, month, day);
    var splashImg = getSplashImg(name);
    var famousSentence = getFamousSentence(name);
    var splashState = store.state.splashState;
    return SplashViewModule(
      splashImg: splashImg,
      countDownTime: splashState.countTime,
      dispatcherTimerValue: (time) {
        store.dispatch(SplashAction(countDownTime: time));
      },
      updateSplashImg: () {
        store.dispatch(UpdateSplashImgAction(img: splashImg, famousSentence: famousSentence));
      },
      nextPage: endTimeListener,
      famousSentence: famousSentence,
    );
  }

  void downTime() {
    var downTime = countDownTime;
    var timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (downTime == 0) {
        timer.cancel();
        nextPage();
        return;
      }
      downTime--;
      dispatcherTimerValue(downTime);
    });
  }

  @override
  List<Object> get props => [countDownTime];
}
