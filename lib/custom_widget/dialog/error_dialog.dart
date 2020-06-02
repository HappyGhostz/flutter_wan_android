import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/app_button.dart';
import 'package:flutterwanandroid/custom_widget/dialog/dialog.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key key,
    this.dioError,
    this.buttonText,
    this.exception,
  }) : super(key: key);
  final DioError dioError;
  final String buttonText;
  final String exception;

  @override
  Widget build(BuildContext context) {
    var greyHead1 = Theme.of(context).textTheme.headline6.copyWith(color: AppColors.black, fontSize: 20);
    var greyBody2 = Theme.of(context).textTheme.bodyText2.copyWith(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w400);
    return AppVerticalButtonDialog(
      title: Text(
        dioError == null ? '网络错误' : dioErrorValue[dioError.type] ?? '网络错误',
        style: greyHead1,
      ),
      content: Text(
        dioError == null ? exception : dioError.message,
        style: greyBody2,
      ),
      contentPaddingTop: 16.0,
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    var actions = <Widget>[];
    var button = Theme.of(context).textTheme.button.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16);
    actions.add(Padding(
      padding: EdgeInsets.only(
        top: 16,
      ),
      child: AppButton(
        buttonColor: AppColors.warning,
        text: buttonText ?? 'Got it',
        onPressed: () {
          Navigator.maybePop(context);
        },
        textStyle: button,
      ),
    ));
    return actions;
  }
}
