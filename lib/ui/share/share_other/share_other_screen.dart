import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/custom_widget/tag_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/share/share_other/reducer/share_other_action.dart';
import 'package:flutterwanandroid/ui/share/share_other/share_other_view_module.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class ShareOtherScreen extends StatelessWidget {
  ShareOtherScreen({
    Key key,
    this.userId,
    this.shareOtherName,
  }) : super(key: key);
  final int userId;
  final String shareOtherName;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ShareOtherViewModule>(
        onInit: (store) {
          store.state.shareOtherState.scrollController = ScrollController();
          store.state.shareOtherState.isPerformingRequest = false;
          store.state.shareOtherState.pageOffset = 1;
          store.state.shareOtherState.dataLoadStatus = DataLoadStatus.loading;
          store.state.shareOtherState.scrollController.addListener(() {
            if (store.state.shareOtherState.scrollController.position.pixels ==
                store.state.shareOtherState.scrollController.position.maxScrollExtent) {
              if (!store.state.shareOtherState.isPerformingRequest) {
                store.dispatch(loadMoreAction(store.state.shareOtherState.shareOtherData, userId, store.state.shareOtherState.pageOffset));
              }
            }
          });
          store.dispatch(loadShareOtherListDataAction(userId, 1));
        },
        onDispose: (store) async {
          store.state.shareOtherState.scrollController?.dispose();
        },
        converter: ShareOtherViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text(shareOtherName ?? '分享人'),
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                if (index == vm.shareOtherData.shareArticles.shareArticles.length + 1) {
                  return _buildLoadMore(vm);
                } else if (index == 0) {
                  return _buildHeadWidget(context, vm, index);
                }
                return _buildDataWidget(vm, index, context);
              },
              itemCount: _buildItemCount(vm),
              scrollController: vm.scrollController,
              onRefresh: () async {
                vm.refreshData(userId);
                return;
              },
              tapGestureRecognizer: () {
                vm.refreshData(userId);
              },
            ),
          );
        });
  }

  int _buildItemCount(ShareOtherViewModule vm) {
    if (vm.shareOtherData == null) {
      return 1;
    }
    return vm.shareOtherData.shareArticles.shareArticles.length + 2;
  }

  Widget _buildLoadMore(ShareOtherViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildHeadWidget(BuildContext context, ShareOtherViewModule vm, int index) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: edge16_8,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Text(
                vm.shareOtherData.coinInfo.username,
                maxLines: 1,
                style: AppTextStyle.head(color: AppColors.black, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        width: 6,
                        height: 6,
                        padding: EdgeInsets.only(right: 4.0),
                      ),
                      Text(
                        ' 分享了${vm.shareOtherData.shareArticles.total}篇文章',
                        style: AppTextStyle.caption(color: AppColors.lightGrey2),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        width: 6,
                        height: 6,
                        padding: EdgeInsets.only(right: 4.0),
                      ),
                      Text(
                        ' 本站积分:',
                        style: AppTextStyle.caption(color: AppColors.lightGrey2),
                      ),
                      Text(
                        '${vm.shareOtherData.coinInfo.coinCount}',
                        style: AppTextStyle.caption(color: AppColors.warning),
                      ),
                      Padding(padding: EdgeInsets.only(right: 4.0)),
                      _buildTagsView('lv${vm.shareOtherData.coinInfo.level}', AppColors.primary),
                      Padding(padding: EdgeInsets.only(right: 4.0)),
                      _buildTagsView('排名${vm.shareOtherData.coinInfo.rank}', Theme.of(context).primaryColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsView(String level, Color colors) {
    if (level == null || level.isEmpty) {
      return Container();
    }
    var tagRow = Padding(
      padding: EdgeInsets.only(bottom: 8.0, left: 0.0, top: 8.0, right: 8.0),
      child: TagWidget(
        tagInfo: level,
        textInfoColor: AppColors.white,
        borderSideColor: colors,
        backgroundColor: colors,
      ),
    );
    return tagRow;
  }

  Widget _buildDataWidget(ShareOtherViewModule vm, int index, BuildContext context) {
    var shareArticle = vm.shareOtherData.shareArticles.shareArticles[index - 1];
    var isCurrentCollect = vm.collectIndexs == null ? null : vm.collectIndexs[index - 1];
    var isCollect = isCurrentCollect ?? shareArticle.collect ?? false;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect, vm, index - 1, context),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(shareArticle.title, vm, index - 1, context),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(shareArticle.niceDate),
              ),
            ],
          ))
        ],
      ),
    );
  }

  IconButton _buildCollectWidget(bool collect, ShareOtherViewModule vm, int indexCount, BuildContext context) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          vm.updateCollectAction(context, !collect, indexCount);
        });
  }

  Widget _buildArticleTitle(String title, ShareOtherViewModule vm, int indexCount, BuildContext context) {
    return GestureDetector(
      onTap: () {
        var article = vm.shareOtherData.shareArticles.shareArticles[indexCount];
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
}
