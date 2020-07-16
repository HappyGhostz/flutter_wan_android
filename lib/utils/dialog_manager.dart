import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/dialog/collect_edit_dialog.dart';
import 'package:flutterwanandroid/custom_widget/dialog/dialog.dart';
import 'package:flutterwanandroid/custom_widget/dialog/edit_dialog.dart';
import 'package:flutterwanandroid/custom_widget/dialog/error_dialog.dart';
import 'package:flutterwanandroid/custom_widget/dialog/info_dialog.dart';
import 'package:flutterwanandroid/custom_widget/dialog/login_dialog.dart';

void showDioErrorInfo(BuildContext context, DioError dioError, {Function() onClick}) {
  showAppDialog<void>(
      context: context,
      child: ErrorDialog(
        dioError: dioError,
        onClick: onClick ?? () {},
      ));
}

void showExceptionInfo(BuildContext context, String exception, {Function() onClick}) {
  showAppDialog<void>(
      context: context,
      child: ErrorDialog(
        exception: exception,
        onClick: onClick ?? () {},
      ));
}

void showApiError(BuildContext context, String exception, {Function() onClick}) {
  showAppDialog<void>(
      context: context,
      child: ErrorDialog(
        exception: exception,
        onClick: onClick ?? () {},
      ));
}

void showInfoDialog(BuildContext context, String content, Function() onClick) {
  showAppDialog<void>(
      context: context,
      child: InfoDialog(
        content: content,
        onClick: onClick ?? () {},
      ));
}

void showLoginDialog(BuildContext context) {
  showAppDialog<void>(
    context: context,
    child: LoginInfoDialog(),
  );
}

Future<Map<String, String>> showEditDialog(
  BuildContext context, {
  String title,
  String editItemTitle,
  String content,
  String dateTime,
}) async {
  var params = await showAppDialog<List<Map<String, String>>>(
      context: context,
      child: EditDialog(
        title: title,
        editItemTitle: editItemTitle,
        content: content,
        dateTime: dateTime,
      ));
  if (params.isNotEmpty) {
    return params[0];
  }
  return <String, String>{};
}

Future<Map<String, String>> showCollectEditDialog(
  BuildContext context, {
  String title,
  String editItemTitle,
  String content,
  String author,
}) async {
  var params = await showAppDialog<List<Map<String, String>>>(
      context: context,
      child: CollectEditDialog(
        title: title,
        editInfo: editItemTitle,
        content: content,
        author: author,
      ));
  if (params.isNotEmpty) {
    return params[0];
  }
  return <String, String>{};
}
