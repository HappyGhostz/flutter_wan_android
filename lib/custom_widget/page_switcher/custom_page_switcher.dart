// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterwanandroid/custom_widget/page_switcher/custom_widget_animation.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

class CustomPageTransitionSwitcher extends StatefulWidget {
  /// Creates a [CustomPageTransitionSwitcher].
  ///
  /// The [duration], [reverse], and [transitionBuilder] parameters
  /// must not be null.
  const CustomPageTransitionSwitcher({
    Key key,
    this.duration = const Duration(milliseconds: 2300),
    this.reverse = false,
    @required this.index,
    this.childs,
  })  : assert(duration != null),
        assert(reverse != null),
        super(key: key);

  final List<Widget> childs;

  final Duration duration;

  final bool reverse;
  final int index;

  @override
  _CustomPageTransitionSwitcherState createState() => _CustomPageTransitionSwitcherState();
}

class _CustomPageTransitionSwitcherState extends State<CustomPageTransitionSwitcher> with TickerProviderStateMixin {
  int currentIndex = 0;
  final List<Widget> cacheChildren = <Widget>[];
  final List<AnimationController> cacheChildrenAnimationController = <AnimationController>[];
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
//    initDataAndAnimation();
    initDataAndAnimationBuild();
  }

  void initDataAndAnimation() {
    _controller = AnimationController(
      vsync: this,
      value: 1,
      duration: widget.duration,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    for (var child in widget.childs) {
      var animationChild = WidgetCustomAnimation(
        child: child,
        animation: _animation,
      );
      cacheChildren.add(animationChild);
    }
    currentIndex = widget.index;
  }

  @override
  void didUpdateWidget(CustomPageTransitionSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
//    updateNewPage();
    updateNewBuilderPage();
  }

  void updateNewPage() {
    if (currentIndex != widget.index) {
      _controller.reset();
      _controller.forward();
      currentIndex = widget.index;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: IndexedStack(
        index: currentIndex,
        children: cacheChildren,
        alignment: Alignment.center,
      ),
    );
  }

  void initDataAndAnimationBuild() {
    for (var child in widget.childs) {
      var _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
      );
      var _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.ease,
        ),
      );
      var builder = AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: currentIndex == 0 ? 1 : _controller.value,
            child: Transform.scale(
              scale: 1.015 - (_controller.value * 0.015),
              child: child,
            ),
          );
        },
        child: child,
      );
      cacheChildrenAnimationController.add(_controller);
      cacheChildren.add(builder);
    }
  }

  void updateNewBuilderPage() {
    if (currentIndex != widget.index) {
      var currentIndexController = cacheChildrenAnimationController[currentIndex];
      currentIndexController.value = 1;
      currentIndexController.reverse();
      var nextIndexController = cacheChildrenAnimationController[widget.index];
      nextIndexController.reset();
      nextIndexController.forward();
      currentIndex = widget.index;
    }
  }
}
