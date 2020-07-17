import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/share/share_private/reducer/share_private_action.dart';
import 'package:flutterwanandroid/ui/share/share_private/share_private_view_module.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class SharePrivateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SharePrivateViewModule>(
        converter: SharePrivateViewModule.fromStore,
        onInit: (store) {
          store.state.sharePrivateState.scrollController = ScrollController();
          store.state.sharePrivateState.isPerformingRequest = false;
          store.state.sharePrivateState.pageOffset = 1;
          store.state.sharePrivateState.dataLoadStatus = DataLoadStatus.loading;
          store.state.sharePrivateState.scrollController.addListener(() {
            if (store.state.sharePrivateState.scrollController.position.pixels ==
                store.state.sharePrivateState.scrollController.position.maxScrollExtent) {
              if (!store.state.sharePrivateState.isPerformingRequest) {
                store.dispatch(loadMoreAction(store.state.sharePrivateState.shareOtherData, store.state.sharePrivateState.pageOffset));
              }
            }
          });
          store.dispatch(loadSharePrivateDataAction(1));
        },
        onDispose: (store) async {
          var isFirstEnterSharePrivate = await store.state.appDependency.sharedPreferences.getBool(isFirstEnterSharePrivateKey);
          if (isFirstEnterSharePrivate == null || !isFirstEnterSharePrivate) {
            await store.state.appDependency.sharedPreferences.setBool(isFirstEnterSharePrivateKey, true);
          }
          store.state.sharePrivateState.scrollController?.dispose();
        },
        onInitialBuild: (vm) {
          vm.showPromptInfo(context);
        },
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('分享的文章'),
              actions: <Widget>[
                _buildAddCollectArticle(context, vm),
              ],
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                if (index == vm.shareOtherData.shareArticles.shareArticles.length) {
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

  int _buildItemCount(SharePrivateViewModule vm) {
    if (vm.shareOtherData == null) {
      return 1;
    }
    return vm.shareOtherData.shareArticles.shareArticles.length + 1;
  }

  Widget _buildLoadMore(SharePrivateViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildDataWidget(SharePrivateViewModule vm, int index, BuildContext context) {
    var shareArticle = vm.shareOtherData.shareArticles.shareArticles[index];
    return Dismissible(
        key: Key('key${shareArticle.id}'),
        background: Container(
          color: AppColors.warning,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.delete,
                color: AppColors.white,
              ),
              Text(
                '删除',
                style: AppTextStyle.caption(color: AppColors.white),
              ),
              Spacer(),
              Text(
                '删除',
                style: AppTextStyle.caption(color: AppColors.white),
              ),
              Icon(
                Icons.delete,
                color: AppColors.white,
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          vm.deletedShareArticle(context, shareArticle);
        },
        child: Container(
          color: AppColors.white,
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(shareArticle.title, vm, index, context),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(shareArticle.niceDate),
              ),
            ],
          ),
        ));
  }

  Widget _buildArticleTitle(String title, SharePrivateViewModule vm, int indexCount, BuildContext context) {
    var shareArticle = vm.shareOtherData.shareArticles.shareArticles[indexCount];
    return GestureDetector(
      onTap: () {
        vm.pushWebPage(context, shareArticle);
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

  Widget _buildAddCollectArticle(BuildContext context, SharePrivateViewModule vm) {
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
