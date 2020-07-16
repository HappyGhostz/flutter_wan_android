import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterwanandroid/custom_widget/flushbar/flushbar.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';

Future showSuccessFlushBarMessage(
  String toastMessage,
  BuildContext context, {
  FlushbarPosition position = FlushbarPosition.TOP,
}) {
  return _buildFlushBar(toastMessage, position, Theme.of(context).primaryColor).show(context);
}

Future showFailedFlushBarMessage(
  String toastMessage,
  BuildContext context, {
  FlushbarPosition position = FlushbarPosition.TOP,
}) {
  return _buildFlushBar(toastMessage, position, AppColors.failedColor).show(context);
}

Flushbar _buildFlushBar(String toastMessage, FlushbarPosition position, Color color) {
  return Flushbar(
    messageText: Text(
      toastMessage,
      style: AppTextStyle.caption(color: AppColors.black),
    ),
    borderRadius: 4,
    aroundPadding: const EdgeInsets.all(16),
    backgroundColor: color,
    flushbarPosition: position,
    isDismissible: true,
    animationDuration: const Duration(seconds: 1),
    duration: const Duration(seconds: 5),
  );
}
