import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/collect/collect_article/collect_article_view_module.dart';
import 'package:flutterwanandroid/ui/collect/collect_article/reducer/collect_article_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';

class CollectArticleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CollectArticleViewModule>(
        onInit: (store) {
          store.state.collectArticleState.scrollController = ScrollController();
          store.state.collectArticleState.isPerformingRequest = false;
          store.state.collectArticleState.pageOffset = 1;
          store.state.collectArticleState.dataLoadStatus = DataLoadStatus.loading;
          store.state.collectArticleState.scrollController.addListener(() {
            if (store.state.collectArticleState.scrollController.position.pixels ==
                store.state.collectArticleState.scrollController.position.maxScrollExtent) {
              if (!store.state.collectArticleState.isPerformingRequest) {
                store.dispatch(loadMoreAction(store.state.collectArticleState.collectArticles, store.state.collectArticleState.pageOffset));
              }
            }
          });
          store.dispatch(loadCollectArticleListDataAction(0));
        },
        onDispose: (store) async {
          var isFirstEnterCollectArticle = await store.state.appDependency.sharedPreferences.getBool(isFirstEnterCollectArticleKey);
          if (isFirstEnterCollectArticle == null || !isFirstEnterCollectArticle) {
            await store.state.appDependency.sharedPreferences.setBool(isFirstEnterCollectArticleKey, true);
          }
          store.state.collectArticleState.scrollController?.dispose();
        },
        onInitialBuild: (vm) {
          vm.showPromptInfo(context);
        },
        converter: CollectArticleViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('收藏文章列表'),
              actions: <Widget>[
                _buildAddCollectArticle(context, vm),
              ],
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                if (index == vm.collectArticles.length) {
                  return _buildLoadMore(vm);
                }
                return _buildDataWidget(vm, index, context);
              },
              itemCount: _buildItemCount(vm),
              scrollController: vm.scrollController,
              onRefresh: () async {
                vm.refreshData(0);
                return;
              },
              tapGestureRecognizer: () {
                vm.refreshData(0);
              },
            ),
          );
        });
  }

  int _buildItemCount(CollectArticleViewModule vm) {
    if (vm.collectArticles == null) {
      return 1;
    }
    return vm.collectArticles.length + 1;
  }

  Widget _buildLoadMore(CollectArticleViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildDataWidget(CollectArticleViewModule vm, int index, BuildContext context) {
    var collectArticle = vm.collectArticles[index];
    return Dismissible(
        key: Key('key${collectArticle.id}'),
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
          vm.cancelCollect(context, collectArticle);
        },
        child: Container(
          color: AppColors.white,
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(collectArticle.title, vm, index, context),
              Padding(
                padding: edge16_8,
                child: Row(
                  children: <Widget>[
                    _buildAuthor(collectArticle.author, vm, context),
                    _buildArticleType(collectArticle.chapterName),
                  ],
                ),
              ),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(collectArticle.niceDate),
              ),
            ],
          ),
        ));
  }

  Widget _buildArticleTitle(String title, CollectArticleViewModule vm, int indexCount, BuildContext context) {
    var collectArticle = vm.collectArticles[indexCount];
    return GestureDetector(
      onTap: () {
        vm.pushWebPage(context, collectArticle);
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

  Widget _buildAuthor(String author, CollectArticleViewModule vm, BuildContext context) {
    if (author == null || author.isEmpty) {
      return Container();
    }
    var name = author;
    var title = '作者';
    return GestureDetector(
      onTap: () {
        if (author.isNotEmpty) {
          RouterUtil.pushName(context, AppRouter.authorArticleRouterName, params: <String, dynamic>{
            authorKey: author,
          });
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

  Widget _buildArticleType(String chapterName) {
    return Expanded(
        child: GestureDetector(
      child: Padding(
        padding: edgeRight_8,
        child: Row(
          children: <Widget>[
            Text(
              '分类:',
              style: AppTextStyle.caption(color: AppColors.lightGrey2),
            ),
            Expanded(
              child: Text(
                chapterName,
                style: AppTextStyle.caption(color: AppColors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ));
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

  Widget _buildAddCollectArticle(BuildContext context, CollectArticleViewModule vm) {
    return Container(
      child: IconButton(
          icon: Icon(
            Icons.add,
            color: AppColors.white,
          ),
          onPressed: () async {
            var params = await showCollectEditDialog(context, title: '请输入标题', editItemTitle: '新增收藏', content: '请输入链接地址', author: '请输入作者');
            if (params.isEmpty) {
              return;
            }
            vm.addCollectArticle(context, params);
          }),
    );
  }
}
