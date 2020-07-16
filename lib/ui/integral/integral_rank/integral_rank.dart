import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/custom_widget/tag_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/integral/integral_rank/integral_rank_view_module.dart';
import 'package:flutterwanandroid/ui/integral/integral_rank/reducer/integral_rank_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class IntegralRankScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, IntegralRankViewModule>(
        onInit: (store) {
          store.state.integralRankState.scrollController = ScrollController();
          store.state.integralRankState.isPerformingRequest = false;
          store.state.integralRankState.pageOffset = 1;
          store.state.integralRankState.dataLoadStatus = DataLoadStatus.loading;
          store.state.integralRankState.scrollController.addListener(() {
            if (store.state.integralRankState.scrollController.position.pixels ==
                store.state.integralRankState.scrollController.position.maxScrollExtent) {
              if (!store.state.integralRankState.isPerformingRequest) {
                store.dispatch(loadMoreAction(store.state.integralRankState.integralRanks, store.state.integralRankState.pageOffset));
              }
            }
          });
          store.dispatch(loadIntegralRankListDataAction(1));
        },
        onDispose: (store) {
          store.state.integralRankState.scrollController.dispose();
        },
        converter: IntegralRankViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('积分排行榜'),
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                if (index == vm.integralRanks.length) {
                  return _buildLoadMore(vm);
                }
                return _buildDataWidget(vm, index, context);
              },
              itemCount: _buildItemCount(vm),
              scrollController: vm.scrollController,
              onRefresh: () async {
                vm.refreshData(1);
                return;
              },
              tapGestureRecognizer: () {
                vm.refreshData(1);
              },
            ),
          );
        });
  }

  int _buildItemCount(IntegralRankViewModule vm) {
    if (vm.integralRanks == null) {
      return 1;
    }
    return vm.integralRanks.length + 1;
  }

  Widget _buildLoadMore(IntegralRankViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildDataWidget(IntegralRankViewModule vm, int index, BuildContext context) {
    var integralRankItem = vm.integralRanks[index];
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          vm.pushIntegralPrivatePage(context, integralRankItem.userId);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildRankItem('${integralRankItem.rank}.', EdgeInsets.only(bottom: 8.0, left: 8.0, top: 8.0, right: 0)),
            _buildRankItem('${integralRankItem.username}:', EdgeInsets.only(bottom: 8.0, left: 0.0, top: 8.0, right: 8.0)),
            _buildRankItem('${integralRankItem.coinCount}', EdgeInsets.only(bottom: 8.0, left: 0.0, top: 8.0, right: 8.0)),
            _buildTagsView('lv${integralRankItem.level}'),
          ],
        ),
      ),
    );
  }

  Padding _buildRankItem(String integralRankItem, EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: Text(
        integralRankItem,
        style: AppTextStyle.head(color: AppColors.black),
      ),
    );
  }

  Widget _buildTagsView(String level) {
    if (level == null || level.isEmpty) {
      return Container();
    }
    var tagRow = Padding(
      padding: EdgeInsets.only(bottom: 8.0, left: 0.0, top: 8.0, right: 8.0),
      child: TagWidget(
        tagInfo: level,
        textInfoColor: AppColors.primary,
        borderSideColor: AppColors.primary,
        backgroundColor: AppColors.white,
      ),
    );
    return tagRow;
  }
}
