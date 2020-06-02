import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/cricular_loading_indicator.dart';

Future<T> showLoadingDialog<T>(BuildContext context) {
  return showDialog<T>(
      context: context,
      builder: (_) => Container(
            alignment: const Alignment(0.0, -0.33),
            child: const CircularLoadingIndicator(),
          ),
      barrierDismissible: false);
}

void dismissDialog<T>(BuildContext context, [T value]) {
  Navigator.of(context).pop(value);
}
