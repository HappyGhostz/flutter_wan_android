import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/community/community_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateCommunityDataStatusAction {
  UpdateCommunityDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateCommunityDataAction {
  UpdateCommunityDataAction({
    this.dataLoadStatus,
    this.communities,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  List<Community> communities;
  int pageOffset;
}

ThunkAction<AppState> loadCommunityDataAction(int index) {
  return (Store<AppState> store) async {
    try {
      var communityResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getCommunityArticle(index));
      var communityModule = CommunityListResponseModule.fromJson(communityResponse.data);
      if (communityModule == null ||
          communityModule.communityData == null ||
          communityModule.communityData.communities == null ||
          communityModule.communityData.communities.isEmpty) {
        store.dispatch(UpdateCommunityDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (communityModule.errorCode < 0) {
        store.dispatch(UpdateCommunityDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateCommunityDataAction(
            dataLoadStatus: DataLoadStatus.loadCompleted, communities: communityModule.communityData.communities, pageOffset: index + 1));
      }
    } catch (e) {
      store.dispatch(UpdateCommunityDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateCommunityIsPerformingRequestAction {
  UpdateCommunityIsPerformingRequestAction({
    this.isPerformingRequest,
  });

  bool isPerformingRequest;
}

class UpdateCommunityLoadMoreDataAction {
  UpdateCommunityLoadMoreDataAction({
    this.isPerformingRequest,
    this.communities,
    this.pageOffset,
  });

  bool isPerformingRequest;
  List<Community> communities;
  int pageOffset;
}

ThunkAction<AppState> loadMoreAction(List<Community> communities, int index) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(UpdateCommunityIsPerformingRequestAction(isPerformingRequest: true));
      var communityResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getCommunityArticle(index));
      var communityModule = CommunityListResponseModule.fromJson(communityResponse.data);
      Future.delayed(const Duration(microseconds: 500), () {
        if (communityModule == null ||
            communityModule.communityData == null ||
            communityModule.communityData.communities == null ||
            communityModule.communityData.communities.isEmpty ||
            communityModule.errorCode < 0) {
          var edge = 72;
          var offsetFromBottom = store.state.communityState.scrollController.position.maxScrollExtent -
              store.state.communityState.scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            store.state.communityState.scrollController.animateTo(
                store.state.communityState.scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
          store.dispatch(UpdateCommunityIsPerformingRequestAction(isPerformingRequest: false));
        } else {
          communities.addAll(communityModule.communityData.communities);
          store.dispatch(UpdateCommunityLoadMoreDataAction(isPerformingRequest: false, communities: communities, pageOffset: index + 1));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = store.state.communityState.scrollController.position.maxScrollExtent -
            store.state.communityState.scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          store.state.communityState.scrollController.animateTo(
              store.state.communityState.scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        store.dispatch(UpdateCommunityIsPerformingRequestAction(isPerformingRequest: false));
      });
    }
  };
}

class UpdateCommunityCollectsDataAction extends AppHttpResponseAction {
  UpdateCommunityCollectsDataAction({
    this.collects,
  });

  Map<int, bool> collects;
}

ThunkAction<AppState> changeTheCollectStatusAction(BuildContext context, {bool collect, int indexCount}) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var id = store.state.communityState.communities[indexCount].id;
      Response response;
      if (collect) {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      dismissDialog<void>(context);
      var collects = <int, bool>{};
      collects[indexCount] = collect;
      store.dispatch(HttpAction(context: context, response: response, action: UpdateCommunityCollectsDataAction(collects: collects)));
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
        store.dispatch(UpdateCommunityDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadCommunityDataAction(0));
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
