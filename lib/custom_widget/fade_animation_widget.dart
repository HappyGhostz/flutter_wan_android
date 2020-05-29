import 'package:flutter/material.dart';

class FadeAnimationWidget extends StatefulWidget {
  FadeAnimationWidget({
    Key key,
    @required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<StatefulWidget> createState() => _FadeAnimationWidgetState();
}

class _FadeAnimationWidgetState extends State<FadeAnimationWidget> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    // Create an animation controller to drive the animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // Our animation will go between a "Light Blue" and a "Dark Blue" depending
    // on whether the user has selected a light or dark theme
    _animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
