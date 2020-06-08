import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({
    Key key,
    @required this.tapGestureRecognizer,
  }) : super(key: key);
  final TapGestureRecognizer tapGestureRecognizer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/ic_chat_empty.png",
            width: 100,
            height: 130,
            fit: BoxFit.contain,
          ),
          Padding(padding: EdgeInsets.only(top: 8.0)),
          RichText(
              text: TextSpan(
            text: '加载失败,',
            style: TextStyle(color: AppColors.black),
            children: <TextSpan>[
              TextSpan(
                text: '请点击重试!',
                style: TextStyle(color: Colors.blue),
                recognizer: tapGestureRecognizer,
              ),
            ],
          )),
        ],
      ),
    );
  }
}
