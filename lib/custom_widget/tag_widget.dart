import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';

class TagWidget extends StatelessWidget {
  TagWidget({
    Key key,
    @required this.tagInfo,
    @required this.textInfoColor,
    this.backgroundColor,
    this.borderSideColor,
  }) : super(key: key);
  final String tagInfo;
  final Color textInfoColor;
  final Color backgroundColor;
  final Color borderSideColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(color: borderSideColor ?? AppColors.primary, width: 1.0),
        shape: BoxShape.rectangle,
      ),
      child: Text(
        tagInfo,
        style: AppTextStyle.caption(color: textInfoColor, fontSize: 10),
      ),
    );
  }
}
