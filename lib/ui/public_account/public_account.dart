import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/keep_alive_widget.dart';
import 'package:flutterwanandroid/custom_widget/loading/load_error_page.dart';
import 'package:flutterwanandroid/custom_widget/tab_controller_widget.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/history_list_screen.dart';
import 'package:flutterwanandroid/ui/public_account/public_account_view_module.dart';
import 'package:flutterwanandroid/ui/public_account/redux/public_account_action.dart';
import 'package:flutterwanandroid/ui/public_account/services/public_account_services.dart';

class PublicAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PublicAccountViewModule>(
      converter: PublicAccountViewModule.fromStore,
      onInit: (store) {
        store.state.publicAccountPageState.publicAccountPageService = PublicAccountPageService(dio: store.state.dio);
        store.dispatch(initTabBarData(context));
      },
      builder: (context, vm) {
        if (vm.publicAccountTabBarModule == null || vm.publicAccountTabBarModule.data.isEmpty) {
          return ErrorPage(
              tapGestureRecognizer: TapGestureRecognizer()
                ..onTap = () {
                  vm.refreshChapterData(context);
                });
        }
        return Container(
          child: TabControllerWidget(
            tabChildren: _buildTabs(vm),
            tabBarViews: _buildTabBarViews(vm, context),
          ),
        );
      },
    );
  }

  List<Widget> _buildTabs(PublicAccountViewModule vm) {
    var tabs = <Widget>[];
    var tabDatas = vm.publicAccountTabBarModule?.data;
    if (tabDatas == null || tabDatas.isEmpty) {
      return tabs;
    }
    for (var tabData in tabDatas) {
      tabs.add(Tab(
        text: '${tabData.name}',
      ));
    }
    return tabs;
  }

  List<Widget> _buildTabBarViews(PublicAccountViewModule vm, BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var dio = store.state.dio;
    var tabs = <Widget>[];
    var tabDatas = vm.publicAccountTabBarModule?.data;
    if (tabDatas == null || tabDatas.isEmpty) {
      return tabs;
    }
    for (var i = 0; i < tabDatas.length; i++) {
      var tabData = tabDatas[i];
      tabs.add(KeepAliveWidget(
        child: PublicAccountHistoryListScreen(
          chapterId: tabData.id,
          dio: dio,
        ),
      ));
    }
    return tabs;
  }
}
