import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/integral/integral_private_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateIntegralPrivateListDataStatusAction {
  UpdateIntegralPrivateListDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateIntegralPrivateListDataAction {
  UpdateIntegralPrivateListDataAction({
    this.dataLoadStatus,
    this.integralPrivates,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  List<IntegralPrivate> integralPrivates;
  int pageOffset;
}

ThunkAction<AppState> loadIntegralPrivateListDataAction(int index, {int id}) {
  return (Store<AppState> store) async {
    try {
      Response<Map<String, dynamic>> integralPrivateListResponse;
      if (id != null) {
        integralPrivateListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getUserIntegralPrivate(id, index));
      } else {
        integralPrivateListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getIntegralPrivate(index));
      }
      var integralPrivateModule = IntegralPrivateListResponseModule.fromJson(integralPrivateListResponse.data);
      if (integralPrivateModule == null ||
          integralPrivateModule.integralPrivateListData == null ||
          integralPrivateModule.integralPrivateListData.integralPrivates == null ||
          integralPrivateModule.integralPrivateListData.integralPrivates.isEmpty) {
        store.dispatch(UpdateIntegralPrivateListDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (integralPrivateModule.errorCode < 0) {
        store.dispatch(UpdateIntegralPrivateListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateIntegralPrivateListDataAction(
            dataLoadStatus: DataLoadStatus.loadCompleted,
            integralPrivates: integralPrivateModule.integralPrivateListData.integralPrivates,
            pageOffset: index + 1));
      }
    } catch (e) {
      store.dispatch(UpdateIntegralPrivateListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateIntegralPrivateIsPerformingRequestAction {
  UpdateIntegralPrivateIsPerformingRequestAction({
    this.isPerformingRequest,
  });

  bool isPerformingRequest;
}

class UpdateIntegralPrivateListLoadMoreDataAction {
  UpdateIntegralPrivateListLoadMoreDataAction({
    this.isPerformingRequest,
    this.integralPrivates,
    this.pageOffset,
  });

  bool isPerformingRequest;
  List<IntegralPrivate> integralPrivates;
  int pageOffset;
}

ThunkAction<AppState> loadMoreAction(List<IntegralPrivate> integralPrivates, int index, {int id}) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(UpdateIntegralPrivateIsPerformingRequestAction(isPerformingRequest: true));
      Response<Map<String, dynamic>> integralPrivateListResponse;
      if (id != null) {
        integralPrivateListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getUserIntegralPrivate(id, index));
      } else {
        integralPrivateListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getIntegralPrivate(index));
      }
      var integralPrivateModule = IntegralPrivateListResponseModule.fromJson(integralPrivateListResponse.data);

      Future.delayed(const Duration(microseconds: 500), () {
        if (integralPrivateModule == null ||
            integralPrivateModule.integralPrivateListData == null ||
            integralPrivateModule.integralPrivateListData.integralPrivates == null ||
            integralPrivateModule.integralPrivateListData.integralPrivates.isEmpty ||
            integralPrivateModule.errorCode < 0) {
          var edge = 72;
          var offsetFromBottom = store.state.integralPrivateState.scrollController.position.maxScrollExtent -
              store.state.integralPrivateState.scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            store.state.integralPrivateState.scrollController.animateTo(
                store.state.integralPrivateState.scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
          store.dispatch(UpdateIntegralPrivateIsPerformingRequestAction(isPerformingRequest: false));
        } else {
          integralPrivates.addAll(integralPrivateModule.integralPrivateListData.integralPrivates);
          store.dispatch(UpdateIntegralPrivateListLoadMoreDataAction(
              isPerformingRequest: false, integralPrivates: integralPrivates, pageOffset: index + 1));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = store.state.integralPrivateState.scrollController.position.maxScrollExtent -
            store.state.integralPrivateState.scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          store.state.integralPrivateState.scrollController.animateTo(
              store.state.integralPrivateState.scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        store.dispatch(UpdateIntegralPrivateIsPerformingRequestAction(isPerformingRequest: false));
      });
    }
  };
}
