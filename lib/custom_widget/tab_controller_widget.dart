import 'package:flutter/material.dart';

typedef ChangeTabIndex = Function(int index);

class TabControllerWidget extends StatefulWidget {
  TabControllerWidget({
    Key key,
    @required this.tabChildren,
    @required this.tabBarViews,
    this.width,
    this.isScroller,
    this.changeTabIndex,
  }) : super(key: key);
  final List<Widget> tabChildren;
  final List<Widget> tabBarViews;
  final double width;
  final bool isScroller;
  final ChangeTabIndex changeTabIndex;

  @override
  State<StatefulWidget> createState() => _TabControllerWidgetState();
}

class _TabControllerWidgetState extends State<TabControllerWidget> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: widget.tabChildren.length);
    _tabController.addListener(() {
      widget.changeTabIndex(_tabController.index);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          elevation: 4,
          child: SizedBox(
            width: widget.width == null ? null : widget.width,
            child: TabBar(
              isScrollable: widget.isScroller ?? true,
              tabs: widget.tabChildren,
              controller: _tabController,
              unselectedLabelColor: Colors.blue[100],
              labelColor: Colors.blue,
            ),
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
