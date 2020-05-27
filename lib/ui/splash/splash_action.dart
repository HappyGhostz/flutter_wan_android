import 'dart:async';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SplashAction {
  SplashAction({this.countDownTime});
  int countDownTime;
}

ThunkAction decreaseCount(int initTimeValue) {
  var downTime = initTimeValue;
  return (Store store) async {
    var timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (downTime == 0) {
        timer.cancel();
        return;
      }
      downTime--;
    });
    store.dispatch(downTime);
  };
}
