import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/dialog/dialog.dart';
import 'package:flutterwanandroid/custom_widget/dialog/error_dialog.dart';
import 'package:flutterwanandroid/custom_widget/dialog/info_dialog.dart';

void showDioErrorInfo(BuildContext context, DioError dioError) {
  showAppDialog<void>(
      context: context,
      child: ErrorDialog(
        dioError: dioError,
      ));
}

void showExceptionInfo(BuildContext context, String exception) {
  showAppDialog<void>(
      context: context,
      child: ErrorDialog(
        exception: exception,
      ));
}

void showApiError(BuildContext context, String exception) {
  showAppDialog<void>(
      context: context,
      child: ErrorDialog(
        exception: exception,
      ));
}

void showInfoDialog(BuildContext context, String content, Function() onClick) {
  showAppDialog<void>(
      context: context,
      child: InfoDialog(
        content: content,
        onClick: onClick,
      ));
}
