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

class UpdateShareOtherDataStatusAction {
  UpdateShareOtherDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateShareOtherDataAction {
  UpdateShareOtherDataAction({
    this.dataLoadStatus,
    this.shareOtherData,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  ShareOtherData shareOtherData;
  int pageOffset;
}

ThunkAction<AppState> loadShareOtherListDataAction(int userId, int index) {
  return (Store<AppState> store) async {
    try {
      var shareOtherResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getShareOtherArticle(userId, index));
      var shareOtherModule = ShareOtherResponseModule.fromJson(shareOtherResponse.data);
      if (shareOtherModule == null || shareOtherModule.shareOtherData == null) {
        store.dispatch(UpdateShareOtherDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (shareOtherModule.errorCode < 0) {
        store.dispatch(UpdateShareOtherDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateShareOtherDataAction(
          dataLoadStatus: DataLoadStatus.loadCompleted,
          shareOtherData: shareOtherModule.shareOtherData,
          pageOffset: index + 1,
        ));
      }
    } catch (e) {
      store.dispatch(UpdateShareOtherDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateShareOtherIsPerformingRequestAction {
  UpdateShareOtherIsPerformingRequestAction({
    this.isPerformingRequest,
  });

  bool isPerformingRequest;
}

class UpdateShareOtherLoadMoreDataAction {
  UpdateShareOtherLoadMoreDataAction({
    this.isPerformingRequest,
    this.shareOtherData,
    this.pageOffset,
  });

  bool isPerformingRequest;
  ShareOtherData shareOtherData;
  int pageOffset;
}

ThunkAction<AppState> loadMoreAction(ShareOtherData shareOtherData, int userId, int index) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(UpdateShareOtherIsPerformingRequestAction(isPerformingRequest: true));
      var shareOtherResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getShareOtherArticle(userId, index));
      var shareOtherModule = ShareOtherResponseModule.fromJson(shareOtherResponse.data);

      Future.delayed(const Duration(microseconds: 500), () {
        if (shareOtherModule == null || shareOtherModule.shareOtherData == null || shareOtherModule.errorCode < 0) {
          var edge = 72;
          var offsetFromBottom = store.state.shareOtherState.scrollController.position.maxScrollExtent -
              store.state.shareOtherState.scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            store.state.shareOtherState.scrollController.animateTo(
                store.state.shareOtherState.scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
          store.dispatch(UpdateShareOtherIsPerformingRequestAction(isPerformingRequest: false));
        } else {
          shareOtherData.shareArticles.shareArticles.addAll(shareOtherModule.shareOtherData.shareArticles.shareArticles);
          store.dispatch(
              UpdateShareOtherLoadMoreDataAction(isPerformingRequest: false, shareOtherData: shareOtherData, pageOffset: index + 1));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = store.state.shareOtherState.scrollController.position.maxScrollExtent -
            store.state.shareOtherState.scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          store.state.shareOtherState.scrollController.animateTo(
              store.state.shareOtherState.scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        store.dispatch(UpdateShareOtherIsPerformingRequestAction(isPerformingRequest: false));
      });
    }
  };
}

class UpdateShareCollectsDataAction extends AppHttpResponseAction {
  UpdateShareCollectsDataAction({
    this.collects,
  });

  Map<int, bool> collects;
}

ThunkAction<AppState> changeTheShareCollectStatusAction(BuildContext context, {bool collect, int indexCount}) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var id = store.state.shareOtherState.shareOtherData.shareArticles.shareArticles[indexCount].id;
      Response response;
      if (collect) {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      dismissDialog<void>(context);
      var collects = <int, bool>{};
      collects[indexCount] = collect;
      store.dispatch(HttpAction(context: context, response: response, action: UpdateShareCollectsDataAction(collects: collects)));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
