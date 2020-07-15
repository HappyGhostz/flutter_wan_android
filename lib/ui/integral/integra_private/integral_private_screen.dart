import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/integral/integra_private/integral_private_view_module.dart';
import 'package:flutterwanandroid/ui/integral/integra_private/reducer/integral_private_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class IntegralPrivateScreen extends StatelessWidget {
  IntegralPrivateScreen({
    Key key,
    this.userId,
  }) : super(key: key);
  final int userId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, IntegralPrivateViewModule>(
        onInit: (store) {
          store.state.integralPrivateState.scrollController = ScrollController();
          store.state.integralPrivateState.isPerformingRequest = false;
          store.state.integralPrivateState.pageOffset = 1;
          store.state.integralPrivateState.dataLoadStatus = DataLoadStatus.loading;
          store.state.integralPrivateState.scrollController.addListener(() {
            if (store.state.integralPrivateState.scrollController.position.pixels ==
                store.state.integralPrivateState.scrollController.position.maxScrollExtent) {
              if (!store.state.integralPrivateState.isPerformingRequest) {
                store.dispatch(loadMoreAction(
                    store.state.integralPrivateState.integralPrivates, store.state.integralPrivateState.pageOffset,
                    id: userId));
              }
            }
          });
          store.dispatch(loadIntegralPrivateListDataAction(1, id: userId));
        },
        converter: IntegralPrivateViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('积分获取列表'),
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                if (index == vm.integralPrivates.length) {
                  return _buildLoadMore(vm);
                }
                return _buildDataWidget(vm, index, context);
              },
              itemCount: _buildItemCount(vm),
              scrollController: vm.scrollController,
              onRefresh: () async {
                vm.refreshData(1, userId);
                return;
              },
              tapGestureRecognizer: () {
                vm.refreshData(1, userId);
              },
            ),
          );
        });
  }

  int _buildItemCount(IntegralPrivateViewModule vm) {
    if (vm.integralPrivates == null) {
      return 1;
    }
    return vm.integralPrivates.length + 1;
  }

  Widget _buildLoadMore(IntegralPrivateViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildDataWidget(IntegralPrivateViewModule vm, int index, BuildContext context) {
    var integralPrivateItem = vm.integralPrivates[index];
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.0, left: 8.0, top: 8.0, right: 8.0),
          child: Text(
            integralPrivateItem.desc,
            style: AppTextStyle.head(color: AppColors.black),
          ),
        ),
      ),
    );
  }
}
