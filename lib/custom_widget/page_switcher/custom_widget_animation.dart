import 'package:flutter/material.dart';

class WidgetCustomAnimation extends AnimatedWidget {
  WidgetCustomAnimation({Key key, Listenable animation, this.child})
      : super(
          key: key,
          listenable: animation,
        );

  final Widget child;

  @override
  Widget build(BuildContext context) {
    var animation = listenable as Animation<double>;
    return Opacity(
      opacity: animation.value,
      child: child,
    );
  }
}
