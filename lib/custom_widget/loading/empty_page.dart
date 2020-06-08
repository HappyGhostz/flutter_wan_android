import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

class EmptyPage extends StatelessWidget {
  EmptyPage({
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
            "assets/disk_file_no_data.png",
            width: 120,
            height: 140,
            fit: BoxFit.contain,
          ),
          Padding(padding: EdgeInsets.only(top: 8.0)),
          RichText(
              text: TextSpan(
            text: '哦！世界都空了,',
            style: TextStyle(color: AppColors.black),
            children: <TextSpan>[
              TextSpan(
                text: '请点击重新加载...!',
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
