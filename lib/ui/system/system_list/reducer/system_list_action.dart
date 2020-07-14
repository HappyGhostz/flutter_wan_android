import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/system/system_list_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateSystemListDataStatusAction {
  UpdateSystemListDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateSystemListDataAction {
  UpdateSystemListDataAction({
    this.dataLoadStatus,
    this.systemLists,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  List<SystemList> systemLists;
  int pageOffset;
}

ThunkAction<AppState> loadSystemListDataAction(int id, int index) {
  return (Store<AppState> store) async {
    try {
      var systemListResponse =
          await store.state.dio.get<Map<String, dynamic>>(NetPath.getAuthorList(index), queryParameters: <String, dynamic>{'cid': id});
      var systemListModule = SystemListResponseModule.fromJson(systemListResponse.data);
      if (systemListModule == null ||
          systemListModule.systemListModule == null ||
          systemListModule.systemListModule.systemLists == null ||
          systemListModule.systemListModule.systemLists.isEmpty) {
        store.dispatch(UpdateSystemListDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (systemListModule.errorCode < 0) {
        store.dispatch(UpdateSystemListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateSystemListDataAction(
            dataLoadStatus: DataLoadStatus.loadCompleted, systemLists: systemListModule.systemListModule.systemLists, pageOffset: 1));
      }
    } catch (e) {
      store.dispatch(UpdateSystemListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateIsPerformingRequestAction {
  UpdateIsPerformingRequestAction({
    this.isPerformingRequest,
  });

  bool isPerformingRequest;
}

class UpdateSystemListLoadMoreDataAction {
  UpdateSystemListLoadMoreDataAction({
    this.isPerformingRequest,
    this.systemLists,
    this.pageOffset,
  });

  bool isPerformingRequest;
  List<SystemList> systemLists;
  int pageOffset;
}

ThunkAction<AppState> loadMoreAction(List<SystemList> systemLists, int id, int index) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(UpdateIsPerformingRequestAction(isPerformingRequest: true));
      var systemListResponse =
          await store.state.dio.get<Map<String, dynamic>>(NetPath.getAuthorList(index), queryParameters: <String, dynamic>{'cid': id});
      var systemListModule = SystemListResponseModule.fromJson(systemListResponse.data);

      Future.delayed(const Duration(microseconds: 500), () {
        if (systemListModule == null ||
            systemListModule.systemListModule == null ||
            systemListModule.systemListModule.systemLists == null ||
            systemListModule.systemListModule.systemLists.isEmpty ||
            systemListModule.errorCode < 0) {
          var edge = 72;
          var offsetFromBottom = store.state.systemListState.scrollController.position.maxScrollExtent -
              store.state.systemListState.scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            store.state.systemListState.scrollController.animateTo(
                store.state.systemListState.scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
          store.dispatch(UpdateIsPerformingRequestAction(isPerformingRequest: false));
        } else {
          systemLists.addAll(systemListModule.systemListModule.systemLists);
          store.dispatch(UpdateSystemListLoadMoreDataAction(isPerformingRequest: false, systemLists: systemLists, pageOffset: index + 1));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = store.state.systemListState.scrollController.position.maxScrollExtent -
            store.state.systemListState.scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          store.state.systemListState.scrollController.animateTo(
              store.state.systemListState.scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        store.dispatch(UpdateIsPerformingRequestAction(isPerformingRequest: false));
      });
    }
  };
}

class UpdateSystemListCollectsDataAction extends AppHttpResponseAction {
  UpdateSystemListCollectsDataAction({
    this.isCollects,
  });

  Map<int, bool> isCollects;
}

ThunkAction<AppState> changeTheCollectStatusAction(BuildContext context, int index, {bool isCollect}) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var id = store.state.systemListState.systemLists[index].id;
      Response response;
      if (isCollect) {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      dismissDialog<void>(context);
      var collects = <int, bool>{};
      collects[index] = isCollect;
      store.dispatch(HttpAction(context: context, response: response, action: UpdateSystemListCollectsDataAction(isCollects: collects)));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
