import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/keep_alive_widget.dart';
import 'package:flutterwanandroid/custom_widget/tab_controller_widget.dart';
import 'package:flutterwanandroid/ui/to_do_page/to_do_list_screen.dart';
import 'package:flutterwanandroid/ui/to_do_page/to_do_menu_widget.dart';
import 'package:flutterwanandroid/ui/to_do_page/to_do_view_module.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';

class ToDoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TodoViewModule>(
      converter: TodoViewModule.fromStore,
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text('TODO-${vm.currentOptionTitle}'),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () async {
                    var params = await showEditDialog(context, title: 'TODO-${vm.currentOptionTitle}');
                    if (params.isNotEmpty) {
                      vm.addTodo(context, params, vm.currentOptionType);
                    }
                  }),
              TodoMenu(vm.itemSelectCallBack, vm.currentOptions),
            ],
          ),
          body: Container(
            child: TabControllerWidget(
              tabChildren: _buildTabs(vm),
              tabBarViews: _buildTabBarViews(vm, context),
              isScroller: false,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildTabs(TodoViewModule vm) {
    var tabs = <Widget>[];
    for (var tabData in toDoTabData) {
      tabs.add(Tab(
        text: '${tabData}',
      ));
    }
    return tabs;
  }

  List<Widget> _buildTabBarViews(TodoViewModule vm, BuildContext context) {
    var store = StoreProvider.of<AppState>(context);
    var dio = store.state.dio;
    var tabs = <Widget>[];
    for (var i = 0; i < toDoTabData.length; i++) {
      var tabData = toDoTabData[i];
      tabs.add(KeepAliveWidget(
        child: TodoListScreen(
          tabData: tabData,
          dio: dio,
          status: i,
          type: vm.currentOptionType,
          num: vm.addNum,
          title: vm.currentOptionTitle,
        ),
      ));
    }
    return tabs;
  }
}
