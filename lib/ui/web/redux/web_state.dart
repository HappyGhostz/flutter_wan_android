import 'dart:async';

import 'package:flutterwanandroid/type/clone.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebState extends Cloneable<WebState> {
  Completer<WebViewController> webViewController;
  String url;
  String title;
  bool isShowProgress;

  @override
  WebState clone() {
    return WebState()
      ..webViewController = webViewController
      ..isShowProgress = isShowProgress
      ..url = url
      ..title = title;
  }
}
