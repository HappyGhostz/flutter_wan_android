import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/flushbar/flushbar.dart';
import 'package:flutterwanandroid/module/collect/collect_article_module.dart';
import 'package:flutterwanandroid/ui/collect/collect_article/reducer/collect_article_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:flutterwanandroid/utils/toast_message.dart';
import 'package:redux/redux.dart';

class CollectArticleViewModule {
  CollectArticleViewModule({
    this.dataLoadStatus,
    this.pageOffset,
    this.scrollController,
    this.refreshData,
    this.isPerformingRequest,
    this.collectArticles,
    this.pushWebPage,
    this.cancelCollect,
    this.showPromptInfo,
  });

  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  Function(int index) refreshData;
  Function(BuildContext context) showPromptInfo;
  Function(BuildContext context, CollectArticle collectArticle) pushWebPage;
  Function(BuildContext context, CollectArticle collectArticle) cancelCollect;
  bool isPerformingRequest;
  List<CollectArticle> collectArticles;

  static CollectArticleViewModule fromStore(Store<AppState> store) {
    var state = store.state.collectArticleState;
    return CollectArticleViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..pageOffset = state.pageOffset
      ..isPerformingRequest = state.isPerformingRequest
      ..scrollController = state.scrollController
      ..collectArticles = state.collectArticles
      ..refreshData = (index) {
        store.dispatch(UpdateCollectArticleListDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadCollectArticleListDataAction(index));
      }
      ..pushWebPage = (context, collectArticle) {
        var params = <String, dynamic>{};
        params[webTitle] = collectArticle.title;
        params[webUrlKey] = collectArticle.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..cancelCollect = (context, collectArticle) {
        store.dispatch(cancelCollectAction(context, collectArticle));
      }
      ..showPromptInfo = (context) async {
        var isFirstEnterCollectArticle = await store.state.appDependency.sharedPreferences.getBool(isFirstEnterCollectArticleKey);
        if (isFirstEnterCollectArticle == null || !isFirstEnterCollectArticle) {
          await showSuccessFlushBarMessage('左右滑动，取消收藏哦！', context, position: FlushbarPosition.BOTTOM);
        }
      };
  }
}
