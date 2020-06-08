import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/keep_alive_widget.dart';
import 'package:flutterwanandroid/ui/frist_page/frist_page.dart';
import 'package:flutterwanandroid/ui/home/redux/home_action.dart';
import 'package:flutterwanandroid/ui/my_page/my_page.dart';
import 'package:flutterwanandroid/ui/navigation_page/navigation_page.dart';
import 'package:flutterwanandroid/ui/public_account/public_account.dart';
import 'package:redux/redux.dart';

var firstPage = KeepAliveWidget(
  child: FirstPage(
//  key: ValueKey('FirstPage'),
      ),
);
var publicAccountPage = KeepAliveWidget(
  child: PublicAccountPage(
//  key: ValueKey('PublicAccountPage'),
      ),
);

var navigationPage = KeepAliveWidget(
  child: NavigationPage(
//  key: ValueKey('NavigationPage'),
      ),
);

var myPage = KeepAliveWidget(
  child: MyPage(
//  key: ValueKey('MyPage'),
      ),
);

Widget getCurrentPage(HomeViewModule vm) {
  var pageList = <Widget>[
    firstPage,
    publicAccountPage,
    navigationPage,
    myPage,
  ];
  return pageList[vm.currentIndex];
}

List<Widget> getPages() {
  var pageList = <Widget>[
    firstPage,
    publicAccountPage,
    navigationPage,
    myPage,
  ];
  return pageList;
}

String getCurrentPageAppTitle(HomeViewModule vm) {
  var pageList = <String>[
    '首页',
    '公众号',
    '导航',
    '我的',
  ];
  return pageList[vm.currentIndex];
}

class HomeViewModule {
  HomeViewModule({
    this.currentIndex,
    this.changeNextPage,
    this.pageController,
  });

  int currentIndex;
  Function(int index) changeNextPage;
  PageController pageController;

  static HomeViewModule fromStore(Store<AppState> store) {
    var homeState = store.state.homeState;
    return HomeViewModule()
      ..currentIndex = homeState.currentIndex
      ..pageController = PageController(initialPage: 0, keepPage: true)
      ..changeNextPage = (newIndex) {
        store.dispatch(CurrentPageAction(currentIndex: newIndex));
      };
  }
}
