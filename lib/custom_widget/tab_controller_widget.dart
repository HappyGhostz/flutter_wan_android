import 'package:flutter/material.dart';

class TabControllerWidget extends StatefulWidget {
  TabControllerWidget({
    Key key,
    @required this.tabChildren,
    @required this.tabBarViews,
  }) : super(key: key);
  final List<Widget> tabChildren;
  final List<Widget> tabBarViews;

  @override
  State<StatefulWidget> createState() => _TabControllerWidgetState();
}

class _TabControllerWidgetState extends State<TabControllerWidget> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: widget.tabChildren.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 4,
          child: TabBar(
            isScrollable: true,
            tabs: widget.tabChildren,
            controller: _tabController,
            unselectedLabelColor: Colors.blue[100],
            labelColor: Colors.blue,
          ),
        ),
        Expanded(
          child: TabBarView(
            children: widget.tabBarViews,
            controller: _tabController,
          ),
        ),
      ],
    );
  }
}