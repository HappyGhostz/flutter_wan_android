import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/keep_alive_widget.dart';
import 'package:flutterwanandroid/custom_widget/loading/load_error_page.dart';
import 'package:flutterwanandroid/custom_widget/tab_controller_widget.dart';
import 'package:flutterwanandroid/ui/project/project_list_screen.dart';
import 'package:flutterwanandroid/ui/project/project_view_module.dart';
import 'package:flutterwanandroid/ui/project/reducer/project_action.dart';

class ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProjectViewModule>(
      converter: ProjectViewModule.fromStore,
      onInit: (store) {
        store.dispatch(initTabBarData());
      },
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text('项目'),
          ),
          body: _buildProjectContainer(vm, context),
        );
      },
    );
  }

  Widget _buildProjectContainer(ProjectViewModule vm, BuildContext context) {
    if (vm.projectTabData == null || vm.projectTabData.isEmpty) {
      return ErrorPage(tapGestureRecognizer: TapGestureRecognizer()..onTap = () {});
    }
    return Container(
      child: TabControllerWidget(
        tabChildren: _buildTabs(vm),
        tabBarViews: _buildTabBarViews(vm, context),
        changeTabIndex: (index) {},
      ),
    );
  }

  List<Widget> _buildTabs(ProjectViewModule vm) {
    var tabs = <Widget>[];
    var tabDatas = vm.projectTabData;
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

  List<Widget> _buildTabBarViews(ProjectViewModule vm, BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var dio = store.state.dio;
    var tabs = <Widget>[];
    var tabDatas = vm.projectTabData;
    if (tabDatas == null || tabDatas.isEmpty) {
      return tabs;
    }
    for (var i = 0; i < tabDatas.length; i++) {
      var tabData = tabDatas[i];
      tabs.add(KeepAliveWidget(
        child: ProjectListScreen(
          chapterId: tabData.id,
          dio: dio,
        ),
      ));
    }
    return tabs;
  }
}
