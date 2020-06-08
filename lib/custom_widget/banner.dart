// ignore_for_file: unnecessary_lambdas, constant_identifier_names
import 'dart:async';

import 'package:flutter/material.dart';

const MAX_COUNT = 0x7fffffff;

typedef TextInfo = String Function(int index);
typedef GestureTapCallback = void Function();

class BannerView extends StatefulWidget {
  BannerView({
    Key key,
    @required this.banners,
    this.initIndex = 0,
    this.cycleRolling = true,
    this.autoRolling = true,
    this.intervalDuration = const Duration(seconds: 1),
    this.animationDuration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.onPageChanged,
    this.height,
    this.textBackgroundColor = const Color(0x99000000),
    this.hasTextinfo = true,
    this.itemTextInfo,
    this.pointRadius = 3.0,
    this.selectedColor = Colors.red,
    this.unSelectedColor = Colors.white,
    this.isShowCycleWidget = true,
    this.isShowTextInfoWidget = true,
    this.onTap,
  }) : super(key: key);

  final List<Widget> banners;
  final GestureTapCallback onTap;

  //whether cycyle rolling
  final bool cycleRolling;
  final bool isShowCycleWidget;
  final bool isShowTextInfoWidget;

  //whether auto rolling
  final bool autoRolling;
  final bool hasTextinfo;

  //init index
  final int initIndex;

  //switch interval
  final Duration intervalDuration;
  final Curve curve;

  //animation duration
  final Duration animationDuration;

  final ValueChanged onPageChanged;

  final double height;
  final Color textBackgroundColor;
  final double pointRadius;
  final Color selectedColor;
  final Color unSelectedColor;

  final TextInfo itemTextInfo;

  @override
  State<StatefulWidget> createState() => BannerViewState();
}

class BannerViewState extends State<BannerView> with SingleTickerProviderStateMixin {
  List<Widget> _originBanners = [];
  List<Widget> _banners = [];
  PageController _pageController;
  int _currentIndex = 0;
  Duration _duration;

  bool isStartScroll = false;

  Timer timer;

  Animation<double> animation;
  Animation<double> opacityAnimation;
  AnimationController controller;
  var pageOffset = 0.0;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    var curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = Tween(begin: 0.0, end: 30.0).animate(curvedAnimation)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);
    controller.forward();

    initDtata();
    super.initState();
  }

  void initDtata() {
    _originBanners.clear();
    _banners.clear();
    _originBanners = widget.banners;
    _banners = _banners..addAll(_originBanners);
    //是否循环滚动
    if (widget.cycleRolling) {
      var first = _originBanners[0];
      var last = _originBanners[_originBanners.length - 1];

      _banners.insert(0, last);
      _banners.add(first);
      _currentIndex = widget.initIndex + 1;
    } else {
      _currentIndex = widget.initIndex;
    }

    _duration = widget.intervalDuration;
    _pageController = PageController(initialPage: _banners.length, keepPage: true);
    _pageController.addListener(() {
      setState(() {
        controller.reset();
        isStartScroll = true;
      });
    });
    _nextBannerTask();
  }

  Timer _timer;

  void _nextBannerTask() {
    if (!mounted) {
      print('mounted4');
      return;
    }

    if (!widget.autoRolling) {
      _cancel(manual: false);
      print('mounted5');
      return;
    }
    print('用户手动滑动开始1');
    _cancel(manual: false);
    print('用户手动滑动开始3');
    //security check[for fuck the gesture notification handle]
    if (_seriesUserScrollRecordCount != 0) {
      print('mounted3');
      return;
    }
    print('用户手动滑动开始5');
    _timer = Timer(_duration, _doChangeIndex);
  }

  bool _canceledByManual = false;

  /// [manual] 是否手动停止
  void _cancel({bool manual = false}) {
    _timer?.cancel();
    print('是否手动停止');
    if (manual) {
      _canceledByManual = true;
    }
  }

  void _doChangeIndex({bool increment = true}) {
    if (!mounted) {
      print('mounted2');
      return;
    }
    _canceledByManual = false;
    if (increment) {
      _currentIndex++;
    } else {
      _currentIndex--;
    }
    _currentIndex = _currentIndex % _banners.length;
    if (0 == _currentIndex) {
      _pageController.jumpToPage(_currentIndex);
      print('_doChangeIndex0');
      _nextBannerTask();
      setState(() {});
    } else {
      print('_doChangeIndex1');
      _pageController
          .animateToPage(
        _currentIndex,
        duration: widget.animationDuration,
        curve: widget.curve,
      )
          .whenComplete(() {
        isStartScroll = false;
        if (!mounted) {
          print('mounted1');
          return;
        } else {
          setState(() {
            print('_doChangeIndex3');
            controller.forward();
            if (_currentIndex == 1) {
              updatePage();
            }
          });
        }
      });
      print('_doChangeIndex4');
    }
  }

  void initTextHeight() {
    setState(() {
      isStartScroll = false;
      controller.forward();
    });
  }

  void updatePage() {
    _pageController.jumpToPage(1);
    controller.reset();
    controller.forward();
  }

  @override
  void didUpdateWidget(BannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    initDtata();
    print('didUpdateWidget');
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _cancel();
    controller.dispose();
    print('banner: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height == null ? 180.0 : widget.height,
      child: Stack(
        children: <Widget>[
          _buildViewPage(),
          Align(
            alignment: Alignment.bottomCenter,
            child: isStartScroll
                ? Container()
                : Opacity(
                    opacity: opacityAnimation.value,
                    child: widget.hasTextinfo
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: widget.isShowTextInfoWidget ? animation.value : 0,
                            padding: EdgeInsets.only(right: 8.0, left: 8.0, top: 6.0, bottom: 6.0),
                            color: widget.textBackgroundColor,
                            child: _bannerTextInfoWidget(),
                          )
                        : Container(),
                  ),
          ),
          widget.isShowCycleWidget
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _builderCriInd(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

//tack the user scroll callback count in a series
  int _seriesUserScrollRecordCount = 0;

  Widget _buildViewPage() {
    Widget pageView = PageView.builder(
        itemCount: _banners.length,
        controller: _pageController,
        onPageChanged: onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          var widgetBanner = _banners[index];
          return GestureDetector(
            child: widgetBanner,
            onTap: widget.onTap,
            onTapDown: (details) {
              print('用户手动滑动开始2');
              _cancel(manual: true);
            },
          );
        });
    return NotificationListener(
      child: pageView,
      onNotification: (Notification notification) {
        _handleScrollNotification(notification);
        return null;
      },
    );
  }

  NotificationListenerCallback _handleScrollNotification(Notification notification) {
    if (notification is UserScrollNotification) {
      _handleUserScroll(notification);
    } else if (notification is ScrollUpdateNotification) {
      _handleOtherScroll(notification);
    }
  }

  void _handleUserScroll(UserScrollNotification notification) {
    var sn = notification;
    var pm = sn.metrics as PageMetrics;
    var depth = sn.depth;
    var page = pm.page;
    var left = page == .0 ? .0 : page % (page.round());
    if (_seriesUserScrollRecordCount == 0) {
      //用户手动滑动开始
      print('用户手动滑动开始');
      _cancel(manual: true);
    }
    if (depth == 0) {
      if (left == 0) {
        if (_seriesUserScrollRecordCount != 0) {
          //用户手动滑动结束
          setState(() {
            isStartScroll = false;
            controller.forward();
            _seriesUserScrollRecordCount = 0;
            _canceledByManual = false;
            _resetWhenAtEdge(pm);
          });
          _nextBannerTask();
        } else {
          _seriesUserScrollRecordCount++;
        }
      } else {
        _seriesUserScrollRecordCount++;
      }
    }
  }

  void _resetWhenAtEdge(PageMetrics pm) {
    if (null == pm || !pm.atEdge) {
      return;
    }
    if (!widget.cycleRolling) {
      return;
    }
    try {
      if (_currentIndex == 0) {
        _pageController.jumpToPage(_banners.length - 2);
      } else if (_currentIndex == _banners.length - 1) {
        _pageController.jumpToPage(1);
      }
      print("_resetWhenAtEdge");
      initTextHeight();
    } catch (e) {
      print('Exception: ${e?.toString()}');
    }
  }

  void _handleOtherScroll(ScrollUpdateNotification notification) {
    var sn = notification;
    if (widget.cycleRolling && sn.metrics.atEdge) {
      if (_canceledByManual) {
        return;
      }
      _resetWhenAtEdge(sn.metrics as PageMetrics);
    }
  }

  Widget _bannerTextInfoWidget() {
    return Opacity(
        opacity: opacityAnimation.value,
        child: Text(
          widget.itemTextInfo == null ? "" : widget.itemTextInfo(_currentIndex - 1) == null ? "" : widget.itemTextInfo(_currentIndex - 1),
          style: TextStyle(color: Colors.white, fontSize: 12.0),
        ));
  }

  List<Widget> _builderCriInd() {
    var circle = <Widget>[];
    var index = widget.cycleRolling ? _currentIndex - 1 : _currentIndex;
    index = index <= 0 ? 0 : index;
    for (var i = 0; i < widget.banners.length; i++) {
      circle.add(Container(
        margin: EdgeInsets.only(left: 0.0, top: 0.0, right: 4.0, bottom: 10.0),
        width: widget.pointRadius * 2,
        height: widget.pointRadius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == i ? widget.selectedColor : widget.unSelectedColor,
        ),
      ));
    }
    return circle;
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    if (!(_timer?.isActive ?? false)) {
      _nextBannerTask();
    }
    setState(() {});
    if (null != widget.onPageChanged) {
      widget.onPageChanged(index);
    }
  }
}
