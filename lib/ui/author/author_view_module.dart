import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/module/first_page/article.dart';
import 'package:flutterwanandroid/ui/author/redux/author_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class AuthorViewModule {
  AuthorViewModule({
    this.dataLoadStatus,
    this.articleModule,
    this.scrollController,
    this.refreshAuthorPageData,
    this.isPerformingRequest,
    this.collectIndexs,
    this.goToArticle,
    this.updateCollectAction,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  ArticleModule articleModule;
  ScrollController scrollController;
  Function(String author) refreshAuthorPageData;
  bool isPerformingRequest;
  Map<int, bool> collectIndexs;
  Function(BuildContext context, Datas article) goToArticle;
  Function(BuildContext context, bool collect, int indexCount) updateCollectAction;
  int pageOffset;

  static AuthorViewModule fromStore(Store<AppState> store) {
    var state = store.state.authorState;
    return AuthorViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..articleModule = state.articleModule
      ..scrollController = state.scrollController
      ..isPerformingRequest = state.isPerformingRequest
      ..collectIndexs = state.collectIndexs
      ..pageOffset = state.pageOffset
      ..refreshAuthorPageData = (author) {
        store.dispatch(ChangeAuthorPageStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadInitAuthorDataAction(0, author));
      }
      ..goToArticle = (context, article) {
        var params = <String, dynamic>{};
        params[webTitle] = article.title;
        params[webUrlKey] = article.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..updateCollectAction = (context, collect, index) {
        store.dispatch(changeTheAuthorCollectStatusAction(context, collect: collect, indexCount: index));
      };
  }
}
