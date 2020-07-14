import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/module/system/system_list_module.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/system/system_list/reducer/system_list_action.dart';
import 'package:flutterwanandroid/ui/system/system_list/system_list_view_module.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class SystemListScreen extends StatelessWidget {
  SystemListScreen({
    Key key,
    this.id,
    this.title,
  }) : super(key: key);
  final int id;
  final String title;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SystemListViewModule>(
        onInit: (store) {
          var state = store.state.systemListState;
          state.scrollController = ScrollController();
          state.isPerformingRequest = false;
          state.dataLoadStatus = DataLoadStatus.loading;
          state.scrollController.addListener(() {
            if (state.scrollController.position.pixels == state.scrollController.position.maxScrollExtent) {
              if (!state.isPerformingRequest) {
                store.dispatch(loadMoreAction(id, state.pageOffset));
              }
            }
          });
          store.dispatch(loadSystemListDataAction(id, 0));
        },
        converter: SystemListViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                if (index == vm.systemLists.length) {
                  return _buildLoadMore(vm);
                }
                return _buildDataWidget(vm, index, context);
              },
              itemCount: _buildItemCount(vm),
              scrollController: vm.scrollController,
              onRefresh: () async {
                vm.refreshData(id, 0);
                return;
              },
              tapGestureRecognizer: () {
                vm.refreshData(id, 0);
              },
            ),
          );
        });
  }

  Widget _buildDataWidget(SystemListViewModule vm, int index, BuildContext context) {
    var systemListItem = vm.systemLists[index];
    var isCurrentCollect = vm.collectIndexs == null ? false : vm.collectIndexs[index];
    var isCollect = false;
    if (systemListItem.collect != null && systemListItem.collect && vm.collectIndexs == null) {
      isCollect = systemListItem.collect;
    } else {
      isCollect = isCurrentCollect ?? systemListItem.collect ?? false;
    }
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect ?? false, vm, index, context),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(systemListItem.title, vm, systemListItem, context),
              Padding(
                padding: edge16_8,
                child: _buildAuthorOrShareUser(systemListItem.author, systemListItem.shareUser, vm, context),
              ),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(systemListItem.niceDate),
              ),
            ],
          ))
        ],
      ),
    );
  }

  IconButton _buildCollectWidget(bool collect, SystemListViewModule vm, int indexCount, BuildContext context) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          vm.updateCollectAction(context, !collect, indexCount);
        });
  }

  Widget _buildArticleTitle(String title, SystemListViewModule vm, SystemList systemListItem, BuildContext context) {
    return GestureDetector(
      onTap: () {
        vm.goToArticle(context, systemListItem);
      },
      child: Padding(
        padding: edge16_8,
        child: Text(
          title,
          maxLines: 2,
          style: AppTextStyle.head(color: AppColors.black),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildAuthorOrShareUser(String author, String shareUser, SystemListViewModule vm, BuildContext context) {
    var name = '';
    var title = '';
    if (author.isNotEmpty) {
      name = author;
      title = '作者';
    } else {
      name = shareUser;
      title = '分享人';
    }
    return GestureDetector(
      onTap: () {
        if (author.isNotEmpty) {
          vm.goToAuthor(context, author);
        }
      },
      child: Padding(
        padding: edgeRight_8,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 4),
              child: Text(
                '$title:',
                style: AppTextStyle.caption(color: AppColors.lightGrey2),
              ),
            ),
            Text(
              name,
              style: AppTextStyle.caption(color: AppColors.black),
            )
          ],
        ),
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

  int _buildItemCount(SystemListViewModule vm) {
    if (vm.systemLists == null) {
      return 1;
    }
    return vm.systemLists.length + 1;
  }

  Widget _buildLoadMore(SystemListViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }
}
