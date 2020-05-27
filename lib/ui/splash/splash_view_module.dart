import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutterwanandroid/app_state.dart';
import 'package:flutterwanandroid/ui/splash/splash_action.dart';
import 'package:redux/redux.dart';

typedef DispatcherTimerValue = void Function(int time);

class SplashViewModule extends Equatable {
  SplashViewModule({this.countDownTime, this.dispatcherTimerValue, this.nextPage});

  final int countDownTime;
  final DispatcherTimerValue dispatcherTimerValue;
  final Function() nextPage;

  static SplashViewModule fromStore(Store<AppState> store, {Function() endTimeListener}) {
    var splashState = store.state.splashState;
    return SplashViewModule(
      countDownTime: splashState.countTime,
      dispatcherTimerValue: (time) {
        store.dispatch(SplashAction(countDownTime: time));
      },
      nextPage: endTimeListener,
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
