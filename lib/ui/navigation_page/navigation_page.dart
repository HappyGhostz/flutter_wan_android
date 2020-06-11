import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/page_show_custom_widget.dart';
import 'package:flutterwanandroid/ui/navigation_page/navigation_card_widget.dart';
import 'package:flutterwanandroid/ui/navigation_page/navigation_view_module.dart';
import 'package:flutterwanandroid/ui/navigation_page/redux/navigation_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NavigationViewModule>(
      converter: NavigationViewModule.fromStore,
      onInit: (store) {
        store.state.navigationState.dataLoadStatus = DataLoadStatus.loading;
        store.dispatch(initNavigationDataAction());
      },
      builder: (context, vm) {
        return CustomPageLoadWidget(
          dataLoadStatus: vm.dataLoadStatus,
          child: _buildDataWidget(vm),
          tapGestureRecognizer: () {
            vm.refresh();
          },
        );
      },
    );
  }

  Widget _buildDataWidget(NavigationViewModule vm) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var chapterData = vm.navigationModule.navigationData[index];
              return NavigationCardWidget(
                navigationData: chapterData,
              );
            },
            childCount: _getChildCount(vm),
          ),
        ),
      ],
    );
  }

  int _getChildCount(NavigationViewModule vm) {
    if (vm.navigationModule != null) {
      return vm.navigationModule.navigationData.length;
    }
    return 1;
  }
}
