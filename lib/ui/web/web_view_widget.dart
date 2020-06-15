import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/ui/web/web_view_module.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  WebViewScreen({
    Key key,
    @required this.url,
    @required this.title,
  }) : super(key: key);
  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WebViewModule>(
        onInit: (store) {
          var _controller = Completer<WebViewController>();
          store.state.webState.webViewController = _controller;
          store.state.webState.title = title;
          store.state.webState.url = url;
          store.state.webState.isShowProgress = true;
        },
        converter: WebViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).maybePop();
                  }),
              title: Text(
                vm.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              actions: <Widget>[
                NavigationControls(vm.webViewController.future),
              ],
            ),
            body: Builder(builder: (BuildContext context) {
              return Stack(
                children: <Widget>[
                  WebView(
                    initialUrl: vm.url,
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (webViewController) {
                      vm.webViewController.complete(webViewController);
                    },
                    navigationDelegate: (request) {
                      if (!request.url.startsWith('https://') || !request.url.startsWith('http://')) {
                        return NavigationDecision.prevent;
                      }
                      print('allowing navigation to $request');
                      return NavigationDecision.navigate;
                    },
                    onPageStarted: (String url) {
                      print('Page started loading: $url');
                      vm.changeProgressStatus(true);
                    },
                    onPageFinished: (String url) {
                      print('Page finished loading: $url');
                      vm.changeProgressStatus(false);
                    },
                    gestureNavigationEnabled: true,
                  ),
                  vm.isShowProgress ? LinearProgressIndicator() : Container(),
                ],
              );
            }),
          );
        });
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture) : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder: (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        var webViewReady = snapshot.connectionState == ConnectionState.done;
        var controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoBack()) {
                        await controller.goBack();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No back history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () async {
                      if (await controller.canGoForward()) {
                        await controller.goForward();
                      } else {
                        Scaffold.of(context).showSnackBar(
                          const SnackBar(content: Text("No forward history item")),
                        );
                        return;
                      }
                    },
            ),
            IconButton(
              icon: !webViewReady
                  ? const Icon(
                      Icons.replay,
                      color: AppColors.lightGrey2,
                    )
                  : const Icon(
                      Icons.replay,
                      color: AppColors.white,
                    ),
              onPressed: !webViewReady
                  ? null
                  : () {
                      controller.reload();
                    },
            ),
          ],
        );
      },
    );
  }
}
