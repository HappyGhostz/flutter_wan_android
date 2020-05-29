import 'package:flutter/material.dart';

// 垂直布局的文字. 从右上开始排序到左下角.
//https://github.com/wilin52/vertical_text
class VerticalText extends CustomPainter {
  String text;
  double width;
  double height;
  TextStyle textStyle;

  VerticalText({@required this.text, @required this.textStyle, @required this.width, @required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = textStyle.color;
    var offsetX = width;
    var offsetY = 0.0;
    var newLine = true;
    var maxWidth = 0.0;

    maxWidth = findMaxWidth(text, textStyle);

    // ignore: avoid_function_literals_in_foreach_calls
    text.runes.forEach((rune) {
      var str = String.fromCharCode(rune);
      var span = TextSpan(style: textStyle, text: str);
      var tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();

      if (offsetY + tp.height > height) {
        newLine = true;
        offsetY = 0;
      }

      if (newLine) {
        offsetX -= maxWidth;
        newLine = false;
      }

      if (offsetX < -maxWidth) {
        return;
      }

      tp.paint(canvas, Offset(offsetX, offsetY));
      offsetY += tp.height;
    });
  }

  double findMaxWidth(String text, TextStyle style) {
    var maxWidth = 0.0;

    // ignore: avoid_function_literals_in_foreach_calls
    text.runes.forEach((rune) {
      var str = String.fromCharCode(rune);
      var span = TextSpan(style: style, text: str);
      var tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
      tp.layout();
      maxWidth = max(maxWidth, tp.width);
    });

    return maxWidth;
  }

  @override
  bool shouldRepaint(VerticalText oldDelegate) {
    return oldDelegate.text != text || oldDelegate.textStyle != textStyle || oldDelegate.width != width || oldDelegate.height != height;
  }

  double max(double a, double b) {
    if (a > b) {
      return a;
    } else {
      return b;
    }
  }
}
