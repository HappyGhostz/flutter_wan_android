import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/loading/empty_page.dart';
import 'package:flutterwanandroid/custom_widget/loading/linear_loading_indicator.dart';
import 'package:flutterwanandroid/module/system/system_tree_module.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/system/reducer/system_action.dart';
import 'package:flutterwanandroid/ui/system/system_view_module.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/image_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';

class SystemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SystemViewModule>(
        distinct: true,
        onInit: (store) {
          store.dispatch(getSystemTreeDataAction());
          var listController = ScrollController();
          store.state.systemState.listController = listController;
        },
        onDispose: (store){
          store.state.systemState.listController.dispose();
        },
        converter: SystemViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('体系'),
            ),
            body: _buildSystemContainer(vm, context),
          );
        });
  }

  Widget _buildSystemContainer(SystemViewModule vm, BuildContext context) {
    if (vm.systemTreeDatas == null) {
      return Container(
        child: Center(child: LinearLoadingIndicator()),
      );
    } else if (vm.systemTreeDatas.isEmpty) {
      return EmptyPage(
          tapGestureRecognizer: TapGestureRecognizer()
            ..onTap = () {
              vm.refreshData();
            });
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            width: 120,
            decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey[300], width: 0.8))),
            child: _buildSystemTab(vm, context)),
        Expanded(child: _buildSystemData(context, vm)),
      ],
    );
  }

  Widget _buildSystemTab(SystemViewModule vm, BuildContext context) {
    return ListView.builder(
        controller: vm.listController,
        itemCount: vm.systemTreeDatas.length,
        itemBuilder: (context, index) {
          return _buildSystemTabItem(vm, context, index);
        });
  }

  Widget _buildSystemTabItem(SystemViewModule vm, BuildContext context, int index) {
    Color backgroundColor;
    Color textColor;
    if (index == vm.selectTabIndex) {
      backgroundColor = Theme.of(context).primaryColor;
      textColor = AppColors.white;
    } else {
      backgroundColor = AppColors.lightGrey3;
      textColor = AppColors.lightGrey1;
    }
    var systemTree = vm.systemTreeDatas[index];
    return GestureDetector(
      onTap: () {
        vm.selectIndex(index);
        vm.listController.animateTo(index * 48.0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      },
      child: Container(
        height: 48,
        padding: EdgeInsets.all(8.0),
        color: backgroundColor,
        child: Center(
          child: Text(
            systemTree.name ?? '',
            style: AppTextStyle.caption(color: textColor, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildSystemData(BuildContext context, SystemViewModule vm) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildPageTitle(context, vm, vm.selectTabIndex),
            _builderTags(vm, vm.selectTabIndex, context),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle(BuildContext context, SystemViewModule vm, int index) {
    Color backgroundColor;
    Color textColor;
    if (index == vm.selectTabIndex) {
      backgroundColor = Theme.of(context).primaryColor;
      textColor = AppColors.white;
    } else {
      backgroundColor = AppColors.lightGrey3;
      textColor = AppColors.lightGrey3;
    }
    var systemTree = vm.systemTreeDatas[index];
    return Container(
      height: 48,
      padding: EdgeInsets.all(8.0),
      color: backgroundColor,
      child: Center(
        child: Text(
          systemTree.name ?? '',
          style: AppTextStyle.caption(color: textColor, fontSize: 18),
        ),
      ),
    );
  }

  Widget _builderTags(SystemViewModule vm, int index, BuildContext context) {
    return Wrap(
      spacing: 4.0,
      alignment: WrapAlignment.start,
      children: _builderTagView(vm, index, context),
    );
  }

  List<Widget> _builderTagView(SystemViewModule vm, int index, BuildContext context) {
    var systemTree = vm.systemTreeDatas[index];
    if (systemTree.children == null) {
      return <Widget>[Container()];
    }
    var widgets = <Widget>[];
    for (var i = 0; i < systemTree.children.length; i++) {
      var tag = systemTree.children[i].name;
      var color = getAssetsColor();
      var gestureDetector = _builderGesTag(tag, color, systemTree.children[i], context);
      widgets.add(gestureDetector);
    }
    return widgets;
  }

  Widget _builderGesTag(String tag, Color color, SystemChildren vm, BuildContext context) {
    return GestureDetector(
      child: Chip(
        label: Text(
          tag,
          style: AppTextStyle.body2(color: AppColors.white),
        ),
        backgroundColor: color,
        shape: RoundedRectangleBorder(side: BorderSide(color: color)),
      ),
      onTap: () {
        RouterUtil.pushName(context, AppRouter.systemList, params: <String, dynamic>{systemListIdKey: vm.id, systemListTitleKey: vm.name});
      },
    );
  }
}
