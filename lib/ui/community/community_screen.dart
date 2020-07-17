import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/custom_widget/tag_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/community/community_view_module.dart';
import 'package:flutterwanandroid/ui/community/reducer/community_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/data_utils.dart';

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommunityViewModule>(
        onInit: (store) {
          store.state.communityState.scrollController = ScrollController();
          store.state.communityState.isPerformingRequest = false;
          store.state.communityState.pageOffset = 1;
          store.state.communityState.dataLoadStatus = DataLoadStatus.loading;
          store.state.communityState.scrollController.addListener(() {
            if (store.state.communityState.scrollController.position.pixels ==
                store.state.communityState.scrollController.position.maxScrollExtent) {
              if (!store.state.communityState.isPerformingRequest) {
                store.dispatch(loadMoreAction(store.state.communityState.communities, store.state.communityState.pageOffset));
              }
            }
          });
          store.dispatch(loadCommunityDataAction(0));
        },
        onDispose: (store) async {
          store.state.communityState.scrollController?.dispose();
        },
        converter: CommunityViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('社区'),
              actions: <Widget>[
                _buildAddCollectArticle(context, vm),
              ],
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                if (index == vm.communities.length) {
                  return _buildLoadMore(vm);
                }
                return _buildDataWidget(vm, index, context);
              },
              itemCount: _buildItemCount(vm),
              scrollController: vm.scrollController,
              onRefresh: () async {
                vm.refreshData();
                return;
              },
              tapGestureRecognizer: () {
                vm.refreshData();
              },
            ),
          );
        });
  }

  int _buildItemCount(CommunityViewModule vm) {
    if (vm.communities == null) {
      return 1;
    }
    return vm.communities.length + 1;
  }

  Widget _buildLoadMore(CommunityViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildDataWidget(CommunityViewModule vm, int index, BuildContext context) {
    var communityArticle = vm.communities[index];
    var isCurrentCollect = vm.collectIndexs == null ? null : vm.collectIndexs[index];
    var isCollect = isCurrentCollect ?? communityArticle.collect ?? false;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect, vm, index, context),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(communityArticle.title, vm, index, context),
              Padding(
                padding: edge16_8,
                child: Row(
                  children: <Widget>[
                    DataUtil.isToDay(communityArticle.niceDate)
                        ? Padding(
                            padding: edgeRight_8,
                            child: TagWidget(
                              tagInfo: '新',
                              textInfoColor: AppColors.warning,
                              borderSideColor: AppColors.warning,
                            ),
                          )
                        : Container(),
                    _buildAuthorOrShareUser(communityArticle.shareUser, vm, context, communityArticle.userId),
                  ],
                ),
              ),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(communityArticle.niceDate),
              ),
            ],
          ))
        ],
      ),
    );
  }

  IconButton _buildCollectWidget(bool collect, CommunityViewModule vm, int indexCount, BuildContext context) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          vm.updateCollectAction(context, !collect, indexCount);
        });
  }

  Widget _buildArticleTitle(String title, CommunityViewModule vm, int indexCount, BuildContext context) {
    return GestureDetector(
      onTap: () {
        var article = vm.communities[indexCount];
        vm.goToArticle(context, article);
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

  Widget _buildAuthorOrShareUser(String shareUser, CommunityViewModule vm, BuildContext context, int userId) {
    var name = shareUser;
    var title = '分享人';
    return GestureDetector(
      onTap: () {
        vm.toShareArticle(context, <String, dynamic>{
          shareUserIdKey: userId,
          shareUserNameKey: shareUser,
        });
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

  Widget _buildAddCollectArticle(BuildContext context, CommunityViewModule vm) {
    return Container(
      child: IconButton(
          icon: Icon(
            Icons.add,
            color: AppColors.white,
          ),
          onPressed: () async {
            vm.addShareArticle(context);
          }),
    );
  }
}
