import 'package:flutter/material.dart';

class KeepAliveWidget extends StatefulWidget {
  KeepAliveWidget({
    Key key,
    @required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  State<StatefulWidget> createState() => _KeepAliveWidgetstate();
}

class _KeepAliveWidgetstate extends State<KeepAliveWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
