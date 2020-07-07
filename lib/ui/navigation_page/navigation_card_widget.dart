import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/widget_item.dart';
import 'package:flutterwanandroid/module/navigation/navigation_module.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:flutterwanandroid/utils/widget_name_to_icon.dart';

class NavigationCardWidget extends StatelessWidget {
  NavigationCardWidget({
    Key key,
    this.navigationData,
  }) : super(key: key);
  final NavigationData navigationData;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: screenWidth - 20,
            margin: const EdgeInsets.only(top: 30.0, bottom: 0.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  width: screenWidth - 20,
                  padding: const EdgeInsets.only(left: 65.0, top: 3.0),
                  height: 30.0,
                  child: Text(
                    navigationData.name,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                _buildWidgetContainer(context),
              ],
            ),
          ),
          Positioned(
            left: 0.0,
            top: 0.0,
            child: Container(
              height: 60.0,
              width: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(23.0),
                  ),
                  height: 46.0,
                  width: 46.0,
                  child: Icon(
                    WidgetName2Icon.navigationIcons[navigationData.name],
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWidgetContainer(BuildContext context) {
    if (navigationData.articles.isEmpty) {
      return Container();
    }
    var chapters = navigationData.articles;
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
      child: Column(
        children: _buildColumns(context, chapters, 3),
      ),
    );
  }

  List<Widget> _buildColumns(BuildContext context, List<Articles> chapters, int columnCount) {
    var _listWidget = <Widget>[];
    var _listRows = <Widget>[];
    int addI;
    for (var i = 0, length = chapters.length; i < length; i += columnCount) {
      _listRows = [];
      for (var innerI = 0; innerI < columnCount; innerI++) {
        addI = innerI + i;
        if (addI < length) {
          var item = chapters[addI];

          _listRows.add(
            Expanded(
              flex: 1,
              child: WidgetItem(
                title: item.title,
                onTap: () {
                  var params = <String, dynamic>{};
                  params[webTitle] = item.title;
                  params[webUrlKey] = item.link;
                  RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
                },
                index: addI,
                totalCount: length,
                rowLength: columnCount,
              ),
            ),
          );
        } else {
          _listRows.add(
            Expanded(
              flex: 1,
              child: Container(),
            ),
          );
        }
      }
      _listWidget.add(
        Row(
          children: _listRows,
        ),
      );
    }
    return _listWidget;
  }
}
