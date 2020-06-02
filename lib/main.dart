import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterwanandroid/build_app.dart';
import 'package:pedantic/pedantic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = reportFlutterError;
  var app = await buildAppWidget();
  unawaited(runZonedGuarded<Future<void>>(
    () async {
      runApp(app);
    },
    _reportError,
  ));
}

void reportFlutterError(FlutterErrorDetails details) {
  FlutterError.dumpErrorToConsole(details);
}

Future<void> _reportError(dynamic error, StackTrace stackTrace) async {
  print('Caught error: $error');
  print(stackTrace);
  return;
}
