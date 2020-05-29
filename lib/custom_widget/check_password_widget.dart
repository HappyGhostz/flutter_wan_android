import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';

class CheckPasswordInfoWidget extends StatelessWidget {
  const CheckPasswordInfoWidget({
    Key key,
    this.initValue,
    this.info,
    this.textStyle,
  }) : super(key: key);
  final bool initValue;
  final String info;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        (initValue ?? false)
            ? Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 16.0,
              )
            : Icon(
                Icons.radio_button_unchecked,
                color: AppColors.gray9c,
                size: 16.0,
              ),
        const Padding(padding: EdgeInsets.only(right: 7.0)),
        Text(
          info,
          style: textStyle ?? AppTextStyle.caption(color: AppColors.black),
        ),
      ],
    );
  }
}
