import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/collect/collect_article_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateCollectArticleListDataStatusAction {
  UpdateCollectArticleListDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateCollectArticleListDataAction {
  UpdateCollectArticleListDataAction({
    this.dataLoadStatus,
    this.collectArticles,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  List<CollectArticle> collectArticles;
  int pageOffset;
}

ThunkAction<AppState> loadCollectArticleListDataAction(int index) {
  return (Store<AppState> store) async {
    try {
      var collectArticleListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getCollectArticle(index));
      var collectArticleModule = CollectArticleResponseModule.fromJson(collectArticleListResponse.data);
      if (collectArticleModule == null ||
          collectArticleModule.collectArticleListData == null ||
          collectArticleModule.collectArticleListData.collectArticles == null ||
          collectArticleModule.collectArticleListData.collectArticles.isEmpty) {
        store.dispatch(UpdateCollectArticleListDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (collectArticleModule.errorCode < 0) {
        store.dispatch(UpdateCollectArticleListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateCollectArticleListDataAction(
            dataLoadStatus: DataLoadStatus.loadCompleted,
            collectArticles: collectArticleModule.collectArticleListData.collectArticles,
            pageOffset: index + 1));
      }
    } catch (e) {
      store.dispatch(UpdateCollectArticleListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateCollectArticleIsPerformingRequestAction {
  UpdateCollectArticleIsPerformingRequestAction({
    this.isPerformingRequest,
  });

  bool isPerformingRequest;
}

class UpdateCollectArticleListLoadMoreDataAction {
  UpdateCollectArticleListLoadMoreDataAction({
    this.isPerformingRequest,
    this.collectArticles,
    this.pageOffset,
  });

  bool isPerformingRequest;
  List<CollectArticle> collectArticles;
  int pageOffset;
}

ThunkAction<AppState> loadMoreAction(List<CollectArticle> collectArticles, int index) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(UpdateCollectArticleIsPerformingRequestAction(isPerformingRequest: true));
      var collectArticleListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getCollectArticle(index));
      var collectArticleModule = CollectArticleResponseModule.fromJson(collectArticleListResponse.data);

      Future.delayed(const Duration(microseconds: 500), () {
        if (collectArticleModule == null ||
            collectArticleModule.collectArticleListData == null ||
            collectArticleModule.collectArticleListData.collectArticles == null ||
            collectArticleModule.collectArticleListData.collectArticles.isEmpty ||
            collectArticleModule.errorCode < 0) {
          var edge = 72;
          var offsetFromBottom = store.state.collectArticleState.scrollController.position.maxScrollExtent -
              store.state.collectArticleState.scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            store.state.collectArticleState.scrollController.animateTo(
                store.state.collectArticleState.scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
          store.dispatch(UpdateCollectArticleIsPerformingRequestAction(isPerformingRequest: false));
        } else {
          collectArticles.addAll(collectArticleModule.collectArticleListData.collectArticles);
          store.dispatch(UpdateCollectArticleListLoadMoreDataAction(
              isPerformingRequest: false, collectArticles: collectArticles, pageOffset: index + 1));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = store.state.collectArticleState.scrollController.position.maxScrollExtent -
            store.state.collectArticleState.scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          store.state.collectArticleState.scrollController.animateTo(
              store.state.collectArticleState.scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        store.dispatch(UpdateCollectArticleIsPerformingRequestAction(isPerformingRequest: false));
      });
    }
  };
}

class UpdateArticleCollectsDataAction extends AppHttpResponseAction {
  UpdateArticleCollectsDataAction({
    this.collectArticles,
  });

  List<CollectArticle> collectArticles;
}

ThunkAction<AppState> cancelCollectAction(BuildContext context, CollectArticle collectArticles) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var response = await store.state.dio.post<Map<String, dynamic>>(NetPath.cancelCollect(collectArticles.id),
          queryParameters: <String, dynamic>{'originId': collectArticles.originId ?? -1});
      dismissDialog<void>(context);
      store.state.collectArticleState.collectArticles.remove(collectArticles);
      store.dispatch(HttpAction(
          context: context,
          response: response,
          action: UpdateArticleCollectsDataAction(collectArticles: store.state.collectArticleState.collectArticles)));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}

ThunkAction<AppState> addCollectArticleAction(BuildContext context, Map<String, String> params) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    var formData = FormData.fromMap(<String, dynamic>{
      'title': params[editTitleKey],
      'link': params[editContentKey],
      'author': params[editTimeKey],
    });
    try {
      var updateResponse = await store.state.dio.post<Map<String, dynamic>>(NetPath.ADD_COLLECT_ARTICLE, data: formData);
      dismissDialog<void>(context);
      var errorCode = updateResponse.data['errorCode'] as int;
      var errorMsg = updateResponse.data['errorMsg'] as String;
      if (errorCode == 0) {
        store.dispatch(UpdateCollectArticleListDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadCollectArticleListDataAction(0));
      } else {
        store.dispatch(HttpAction(error: errorMsg, context: context));
      }
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
