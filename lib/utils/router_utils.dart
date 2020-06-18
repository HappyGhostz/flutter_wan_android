import 'package:flutter/material.dart';

class RouterUtil {
  static void pushNameAndRemove(BuildContext context, String routeName, {bool isRootRoute = false}) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => isRootRoute);
  }

  static void pushName(BuildContext context, String routeName, {bool isRootRoute = false, Map<String, dynamic> params}) {
    Navigator.pushNamed(context, routeName, arguments: params ?? <String, dynamic>{});
  }

  static void pushReplacementNamed(BuildContext context, String routeName, {bool isRootRoute = false, Map<String, dynamic> params}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: params ?? <String, dynamic>{});
  }
}
