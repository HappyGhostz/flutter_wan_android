import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/redux/history_action.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/view_module.dart';
import 'package:flutterwanandroid/ui/public_account/services/public_account_services.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

///说一下这个问题，如果用flutter_redux来做的话,state会在buildAppState的时候初始化一个对象，
///所以在tabbar中，每次切换页面，加载PublicAccountHistoryListScreen，在下面的onInit中，state都会被刷新切换新的数据，
///这会导致一份ScrollController会被绑定到不同的滚动视图中，对ScrollController的操作会因为业务的关系变得复杂。
// ignore: must_be_immutable
class PublicAccountHistoryListScreen extends StatelessWidget {
  PublicAccountHistoryListScreen({
    Key key,
    @required this.chapterId,
    @required this.scrollController,
    @required this.currentScrollController,
  }) : super(key: key);
  final int chapterId;
  int currentScrollController;
  ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PublicAccountHistoryViewModule>(
      converter: PublicAccountHistoryViewModule.fromStore,
      onInit: (store) {
        var state = store.state.publicAccountHistoryState;
        state.publicAccountHistoryStatus = DataLoadStatus.loading;
        state.isPerformingRequest = false;
        state.chapterId = chapterId;
        state.pageOffset = 1;
        state.currentScrollController = currentScrollController;
        state.publicAccountPageService = PublicAccountPageService(dio: store.state.dio);
        state.scrollController = scrollController;
        state.scrollController.addListener(() {
          var index = store.state.publicAccountHistoryState.currentScrollController;
          // ignore: invalid_use_of_protected_member
          if (state.scrollController.positions.elementAt(index).pixels ==
              // ignore: invalid_use_of_protected_member
              state.scrollController.positions.elementAt(index).maxScrollExtent) {
            if (!state.isPerformingRequest) {
              var state = store.state.publicAccountHistoryState;
              store.dispatch(
                  loadMoreAction(chapterId, state.pageOffset, state.publicAccountHistoryListModule, state.scrollController, index));
            }
          }
        });
        store.dispatch(refreshHistoryDataAction(0, chapterId));
      },
      builder: (context, vm) {
        return PageLoadWidget(
          dataLoadStatus: vm.publicAccountHistoryStatus,
          itemBuilder: (context, index) {
            if (index == vm.publicAccountHistoryListModule.historyListData.datas.length) {
              return _buildLoadMore(vm);
            }
            return _buildHistoryItem(vm, index);
          },
          itemCount: _buildItemCount(vm),
          scrollController: vm.scrollController,
          onRefresh: () async {
            vm.refreshData(vm.chapterId);
            return;
          },
          tapGestureRecognizer: () {
            vm.refreshData(vm.chapterId);
          },
        );
      },
    );
  }

  Widget _buildLoadMore(PublicAccountHistoryViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildHistoryItem(PublicAccountHistoryViewModule vm, int index) {
    var historyItem = vm.publicAccountHistoryListModule.historyListData.datas[index];
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(historyItem.collect ?? false),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(historyItem.title),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(historyItem.niceDate),
              ),
            ],
          ))
        ],
      ),
    );
  }

  IconButton _buildCollectWidget(bool collect) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {});
  }

  Widget _buildArticleTitle(String title) {
    return Padding(
      padding: edge16_8,
      child: Text(
        title,
        maxLines: 2,
        style: AppTextStyle.head(color: AppColors.black),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTimeInfo(String niceDate) {
    return Padding(
      padding: edgeRight_8,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              '时间:',
              style: AppTextStyle.caption(color: AppColors.lightGrey2),
            ),
          ),
          Expanded(
              child: Text(
            niceDate,
            style: AppTextStyle.caption(color: AppColors.lightGrey2),
          )),
        ],
      ),
    );
  }

  int _buildItemCount(PublicAccountHistoryViewModule vm) {
    if (vm.publicAccountHistoryListModule != null) {
      return vm.publicAccountHistoryListModule.historyListData.datas.length + 1;
    }
    return 1;
  }
}
