import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

class CircularLoadingIndicator extends StatelessWidget {
  const CircularLoadingIndicator({
    Key key,
    this.message,
  }) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    Widget indicator = WillPopScope(
      onWillPop: () => Future.value(false),
      child: Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          color: AppColors.greyLightExtreme,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: _IndicatorColor(),
            ),
          ),
        ),
      ),
    );

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          indicator,
        ],
      ),
    );
  }
}

class _IndicatorColor extends Animation<Color> {
  @override
  void addListener(VoidCallback listener) {}

  @override
  void addStatusListener(AnimationStatusListener listener) {}

  @override
  void removeListener(VoidCallback listener) {}

  @override
  void removeStatusListener(AnimationStatusListener listener) {}

  @override
  AnimationStatus get status => null;

  @override
  Color get value => AppColors.primary;
}
