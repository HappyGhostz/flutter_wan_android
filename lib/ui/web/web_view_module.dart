import 'dart:async';

import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/ui/web/redux/web_action.dart';
import 'package:redux/redux.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewModule {
  WebViewModule({
    this.webViewController,
    this.url,
    this.title,
    this.isShowProgress,
  });

  Completer<WebViewController> webViewController;
  String url;
  String title;
  bool isShowProgress;
  Function(bool progressStatus) changeProgressStatus;

  static WebViewModule fromStore(Store<AppState> store) {
    var state = store.state.webState;
    return WebViewModule()
      ..webViewController = state.webViewController
      ..url = state.url
      ..title = state.title
      ..isShowProgress = state.isShowProgress
      ..changeProgressStatus = (progressStatus) {
        store.dispatch(ChangeProgressStatusAction(progressStatus: progressStatus));
      };
  }
}
