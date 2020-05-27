import 'package:flutter/material.dart';

class RouterUtil {
  static void pushNameAndRemove(BuildContext context, String routeName, {bool isRootRoute = false}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => isRootRoute);
  }
}
