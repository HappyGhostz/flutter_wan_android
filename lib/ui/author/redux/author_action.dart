import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/first_page/article.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateAuthorDataAction {
  UpdateAuthorDataAction({
    this.articleModule,
    this.dataLoadStatus,
    this.pageOffset,
  });

  ArticleModule articleModule;
  DataLoadStatus dataLoadStatus;
  int pageOffset;
}

class ChangeAuthorPageStatusAction {
  ChangeAuthorPageStatusAction({this.dataLoadStatus});

  DataLoadStatus dataLoadStatus;
}

class UpdateAuthorCollectsDataAction extends AppHttpResponseAction {
  UpdateAuthorCollectsDataAction({
    this.collects,
  });

  Map<int, bool> collects;
}

ThunkAction<AppState> loadInitAuthorDataAction(int index, String author) {
  return (Store<AppState> store) async {
    try {
      var param = <String, dynamic>{
        'author': author,
      };
      var authorArticleResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getAuthorList(index), queryParameters: param);
      var articleModule = ArticleModule.fromJson(authorArticleResponse.data);
      if (articleModule == null) {
        store.dispatch(ChangeAuthorPageStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (articleModule.errorCode < 0) {
        store.dispatch(ChangeAuthorPageStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateAuthorDataAction(articleModule: articleModule, dataLoadStatus: DataLoadStatus.loadCompleted, pageOffset: 1));
      }
    } on DioError catch (e) {
      store.dispatch(ChangeAuthorPageStatusAction(dataLoadStatus: DataLoadStatus.failure));
    } catch (e) {
      store.dispatch(ChangeAuthorPageStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

ThunkAction<AppState> changeTheAuthorCollectStatusAction(BuildContext context, {bool collect, int indexCount}) {
  return (Store<AppState> store) async {
    try {
      var id = store.state.authorState.articleModule.data.datas[indexCount].id;
      Response response;
      if (collect) {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      var collects = <int, bool>{};
      collects[indexCount] = collect;
      store.dispatch(HttpAction(context: context, response: response, action: UpdateAuthorCollectsDataAction(collects: collects)));
    } on DioError catch (e) {
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}

class LoadMoreAuthorDataAction {
  LoadMoreAuthorDataAction({
    this.articleModule,
    this.pageOffset,
    this.isChangePerformingRequestStatus,
    this.isLoadMore,
  });

  ArticleModule articleModule;
  int pageOffset;
  bool isChangePerformingRequestStatus;
  bool isLoadMore;
}

class ChangeAuthorPerformingRequestStatusAction {
  ChangeAuthorPerformingRequestStatusAction({
    this.isChangePerformingRequestStatus,
  });

  bool isChangePerformingRequestStatus;
}

ThunkAction<AppState> loadMoreAction(int index, ArticleModule oldArticleModule, ScrollController listController, String author) {
  return (Store<AppState> store) async {
    try {
      var param = <String, dynamic>{
        'author': author,
      };
      store.dispatch(ChangeAuthorPerformingRequestStatusAction(isChangePerformingRequestStatus: true));
      var authorArticleResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getAuthorList(index), queryParameters: param);
      var articleModule = ArticleModule.fromJson(authorArticleResponse.data);
      Future.delayed(const Duration(microseconds: 500), () {
        if (articleModule == null || articleModule.data.datas != null || articleModule.data.datas.isEmpty) {
          var edge = 72;
          var offsetFromBottom = listController.position.maxScrollExtent - listController.position.pixels;
          if (offsetFromBottom < edge) {
            listController.animateTo(listController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          }
          store.dispatch(LoadMoreAuthorDataAction(isChangePerformingRequestStatus: false, isLoadMore: false));
        } else {
          oldArticleModule.data.datas.addAll(articleModule.data.datas);
          store.dispatch(LoadMoreAuthorDataAction(
              articleModule: oldArticleModule, pageOffset: index + 1, isChangePerformingRequestStatus: false, isLoadMore: true));
        }
      });
    } on DioError catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = listController.position.maxScrollExtent - listController.position.pixels;
        if (offsetFromBottom < edge) {
          listController.animateTo(listController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
        store.dispatch(ChangeAuthorPerformingRequestStatusAction(isChangePerformingRequestStatus: false));
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = listController.position.maxScrollExtent - listController.position.pixels;
        if (offsetFromBottom < edge) {
          listController.animateTo(listController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
        store.dispatch(ChangeAuthorPerformingRequestStatusAction(isChangePerformingRequestStatus: false));
      });
    }
  };
}
