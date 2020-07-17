import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/share/share_other_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateSharePrivateDataStatusAction {
  UpdateSharePrivateDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateSharePrivateDataAction {
  UpdateSharePrivateDataAction({
    this.dataLoadStatus,
    this.shareOtherData,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  ShareOtherData shareOtherData;
  int pageOffset;
}

ThunkAction<AppState> loadSharePrivateDataAction(int index) {
  return (Store<AppState> store) async {
    try {
      var sharePrivateResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getSharePrivateArticle(index));
      var shareArticleModule = ShareOtherResponseModule.fromJson(sharePrivateResponse.data);
      if (shareArticleModule == null || shareArticleModule.shareOtherData == null) {
        store.dispatch(UpdateSharePrivateDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (shareArticleModule.errorCode < 0) {
        store.dispatch(UpdateSharePrivateDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateSharePrivateDataAction(
            dataLoadStatus: DataLoadStatus.loadCompleted, shareOtherData: shareArticleModule.shareOtherData, pageOffset: index + 1));
      }
    } catch (e) {
      store.dispatch(UpdateSharePrivateDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateSharePrivateIsPerformingRequestAction {
  UpdateSharePrivateIsPerformingRequestAction({
    this.isPerformingRequest,
  });

  bool isPerformingRequest;
}

class UpdateSharePrivateLoadMoreDataAction {
  UpdateSharePrivateLoadMoreDataAction({
    this.isPerformingRequest,
    this.shareOtherData,
    this.pageOffset,
  });

  bool isPerformingRequest;
  ShareOtherData shareOtherData;
  int pageOffset;
}

ThunkAction<AppState> loadMoreAction(ShareOtherData shareOtherData, int index) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(UpdateSharePrivateIsPerformingRequestAction(isPerformingRequest: true));
      var sharePrivateResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getSharePrivateArticle(index));
      var shareArticleModule = ShareOtherResponseModule.fromJson(sharePrivateResponse.data);
      Future.delayed(const Duration(microseconds: 500), () {
        if (shareArticleModule == null || shareArticleModule.shareOtherData == null || shareArticleModule.errorCode < 0) {
          var edge = 72;
          var offsetFromBottom = store.state.sharePrivateState.scrollController.position.maxScrollExtent -
              store.state.sharePrivateState.scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            store.state.sharePrivateState.scrollController.animateTo(
                store.state.sharePrivateState.scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
          store.dispatch(UpdateSharePrivateIsPerformingRequestAction(isPerformingRequest: false));
        } else {
          shareOtherData.shareArticles.shareArticles.addAll(shareArticleModule.shareOtherData.shareArticles.shareArticles);
          store.dispatch(
              UpdateSharePrivateLoadMoreDataAction(isPerformingRequest: false, shareOtherData: shareOtherData, pageOffset: index + 1));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = store.state.sharePrivateState.scrollController.position.maxScrollExtent -
            store.state.sharePrivateState.scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          store.state.sharePrivateState.scrollController.animateTo(
              store.state.sharePrivateState.scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        store.dispatch(UpdateSharePrivateIsPerformingRequestAction(isPerformingRequest: false));
      });
    }
  };
}

class UpdateShareArticleDataAction extends AppHttpResponseAction {
  UpdateShareArticleDataAction({
    this.shareOtherData,
  });

  ShareOtherData shareOtherData;
}

ThunkAction<AppState> deletedShareArticleAction(BuildContext context, ShareArticle shareArticle) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var response = await store.state.dio.post<Map<String, dynamic>>(NetPath.deletedSharePrivateArticle(shareArticle.id));
      dismissDialog<void>(context);
      store.state.sharePrivateState.shareOtherData.shareArticles.shareArticles.remove(shareArticle);
      store.dispatch(HttpAction(
          context: context,
          response: response,
          action: UpdateShareArticleDataAction(shareOtherData: store.state.sharePrivateState.shareOtherData)));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}

ThunkAction<AppState> addShareArticleAction(BuildContext context, Map<String, String> params) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    var formData = FormData.fromMap(<String, dynamic>{
      'title': params[editTitleKey],
      'link': params[editContentKey],
    });
    try {
      var updateResponse = await store.state.dio.post<Map<String, dynamic>>(NetPath.SHARE_ARTICLE, data: formData);
      dismissDialog<void>(context);
      var errorCode = updateResponse.data['errorCode'] as int;
      var errorMsg = updateResponse.data['errorMsg'] as String;
      if (errorCode == 0) {
        store.dispatch(UpdateSharePrivateDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadSharePrivateDataAction(1));
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
