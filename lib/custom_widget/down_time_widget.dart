import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

typedef DownTimeEndListener = void Function();

class DownTimeWidget extends StatefulWidget {
  DownTimeWidget({Key key, this.clors, this.width, this.strokeWidth, this.time, this.textStyle, this.endListener}) : super();
  final Color clors;
  final double width;
  final double strokeWidth;
  final int time;
  final TextStyle textStyle;
  final DownTimeEndListener endListener;

  @override
  State<StatefulWidget> createState() => DownTimeState();
}

class DownTimeState extends State<DownTimeWidget> with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curvedAnimation;
  Tween<double> animationTween;
  double angle;
  Animation<double> animation;
  int _time = 0;

  @override
  void initState() {
    super.initState();
    _time = widget.time ~/ 1000;
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.time));
    curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.linear);
    animationTween = Tween(begin: 0.0, end: 360.0);
    animation = animationTween.animate(curvedAnimation);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.endListener();
      }
    });
    animation.addListener(() {
      angle = animation.value;
      setState(() {});
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.endListener();
      },
      child: Container(
        width: widget.width,
        height: widget.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.width / 2), color: Colors.white),
        child: Stack(
          children: <Widget>[
            Center(
              child: DownTimeText(
                time: _time,
                textStyle: widget.textStyle,
              ),
            ),
            CustomPaint(
              painter: DrawArcPainter(
                colors: widget.clors,
                angle: angle,
                width: widget.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawArcPainter extends CustomPainter {
  DrawArcPainter({this.colors, this.angle, this.width, this.mStrokeWidth});

  Color colors;

  double mStrokeWidth;

  double width;

  double angle;

  double angleToRadian(double angle) => angle * (pi / 180.0);

  double radianToAngle(double radian) => radian * (180.0 / pi);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = colors == null ? Colors.red : colors
      ..strokeWidth = mStrokeWidth == null ? 2.0 : mStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var rect = Rect.fromLTWH(0.0, 0.0, width, width);
    canvas.drawArc(rect, 0.0, angleToRadian(angle), false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class DownTimeText extends StatefulWidget {
  DownTimeText({Key key, this.time, this.textStyle}) : super(key: key);
  final int time;
  final TextStyle textStyle;

  @override
  State<StatefulWidget> createState() => DownTimeTextState();
}

class DownTimeTextState extends State<DownTimeText> {
  DownTimeTextState();

  int _time;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _time = widget.time;
    startDownTimer();
  }

  void startDownTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (_time == null || _time == 0) {
        setState(() {});
        timer?.cancel();
        return;
      }
      _time--;

      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "倒计时:$_time",
      style: widget.textStyle,
    );
  }
}
