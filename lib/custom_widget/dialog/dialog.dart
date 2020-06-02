import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/cluster/cluster.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    Key key,
    @required this.title,
    this.content,
    this.actions,
    this.backMenuEnabled = true,
    this.padding,
  })  : assert(title != null),
        super(key: key);

  final Widget title;

  final Widget content;

  final List<Widget> actions;

  final bool backMenuEnabled;

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    var body = <Widget>[];

    if (title != null) {
      body.add(title);
    }

    if (content != null) {
      body.add(Container(
        margin: EdgeInsets.only(top: title != null ? 8.0 : 0.0),
        child: content,
      ));
    }

    if (actions != null) {
      body.add(Container(
        margin: const EdgeInsets.only(top: 30.0),
        child: ActionCluster(
          children: actions,
        ),
      ));
    }

    return WillPopScope(
      onWillPop: () {
        return Future.value(backMenuEnabled);
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0),
            child: Material(
              elevation: 24.0,
              color: Colors.white,
              type: MaterialType.card,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppVerticalButtonDialog extends StatelessWidget {
  const AppVerticalButtonDialog({
    Key key,
    this.icon,
    this.title,
    this.content,
    this.actions,
    this.backMenuEnabled = true,
    this.contentPaddingTop,
  })  : assert(title != null || content != null),
        super(key: key);

  final Widget icon;
  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final bool backMenuEnabled;
  final double contentPaddingTop;

  @override
  Widget build(BuildContext context) {
    var body = <Widget>[];

    if (title != null) {
      if (icon != null) {
        body.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
              child: icon,
            ),
            Expanded(child: title)
          ],
        ));
      } else {
        body.add(title);
      }
    }

    if (content != null) {
      body.add(Container(
        margin: EdgeInsets.only(top: title != null ? contentPaddingTop ?? 8.0 : 0.0),
        child: content,
      ));
    }

    if (actions != null) {
      for (var index = 0; index < actions.length; index++) {
        var action = actions[index];
        if (index == 0) {
          body.add(Container(
            margin: const EdgeInsets.only(top: 24.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: action,
                ))
              ],
            ),
          ));
        } else {
          body.add(Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: action,
                ))
              ],
            ),
          ));
        }
      }
    }

    return WillPopScope(
      onWillPop: () {
        return Future.value(backMenuEnabled);
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 280.0, maxWidth: 328.0),
            child: Material(
              elevation: 24.0,
              color: Colors.white,
              type: MaterialType.card,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<T> showAppDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = true,
  bool rootNavigator = false,
  @required Widget child,
}) async {
  var data = await Navigator.of(context, rootNavigator: rootNavigator).push(_DialogRoute<T>(
    child: child,
    theme: Theme.of(context, shadowThemeOnly: true),
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context)?.modalBarrierDismissLabel ?? '',
  ));
  return data;
}

class _DialogRoute<T> extends PopupRoute<T> {
  _DialogRoute({
    @required this.theme,
    bool barrierDismissible = true,
    this.barrierLabel,
    @required this.child,
  })  : assert(barrierDismissible != null),
        _barrierDismissible = barrierDismissible;

  final Widget child;
  final ThemeData theme;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);

  @override
  bool get barrierDismissible => _barrierDismissible;
  final bool _barrierDismissible;

  @override
  Color get barrierColor => Colors.black54;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return SafeArea(
      child: Builder(
        builder: (BuildContext context) {
          return theme != null ? Theme(data: theme, child: child) : child;
        },
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }
}
