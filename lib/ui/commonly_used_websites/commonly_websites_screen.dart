import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/page_show_custom_widget.dart';
import 'package:flutterwanandroid/module/commonly_websites_module.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/commonly_used_websites/commonly_wwbsites_view_module.dart';
import 'package:flutterwanandroid/ui/commonly_used_websites/reducer/commonly_websites_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/image_utils.dart';

class CommonlyUsedWebSitesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonlyUsedWebSitesViewModule>(
        onInit: (store) {
          store.state.commonlyUsedWebSitesState.dataLoadStatus = DataLoadStatus.loading;
          store.dispatch(initDataAction());
        },
        converter: CommonlyUsedWebSitesViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('常用网站'),
            ),
            body: CustomPageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              child: _buildDataWidget(vm, context),
              tapGestureRecognizer: () {
                vm.refresh();
              },
            ),
          );
        });
  }

  Widget _buildDataWidget(CommonlyUsedWebSitesViewModule vm, BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: _buildWebTagView(vm, context),
        )
      ],
    );
  }

  Widget _buildWebTagView(CommonlyUsedWebSitesViewModule vm, BuildContext context) {
    return builderTags(vm, context);
  }

  Widget builderTags(CommonlyUsedWebSitesViewModule vm, BuildContext context) {
    return Wrap(
      spacing: 4.0,
      alignment: WrapAlignment.start,
      children: _builderTagView(vm, context),
    );
  }

  List<Widget> _builderTagView(CommonlyUsedWebSitesViewModule vm, BuildContext context) {
    if (vm.commonlyUsedWebSitesDatas == null) {
      return <Widget>[Container()];
    }
    var widgets = <Widget>[];
    for (var i = 0; i < vm.commonlyUsedWebSitesDatas.length; i++) {
      var tag = vm.commonlyUsedWebSitesDatas[i].name;
      var color = getAssetsColor();
      var gestureDetector = _builderGesTag(tag, color, vm, vm.commonlyUsedWebSitesDatas[i], context);
      widgets.add(gestureDetector);
    }
    return widgets;
  }

  Widget _builderGesTag(
    String tag,
    Color color,
    CommonlyUsedWebSitesViewModule vm,
    CommonlyUsedWebSitesData commonlyUsedWebSitesData,
    BuildContext context,
  ) {
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
        vm.pushWebPage(context, commonlyUsedWebSitesData);
      },
    );
  }
}
