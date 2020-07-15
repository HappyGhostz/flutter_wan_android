import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/integral/integral_rank_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateIntegralRankListDataStatusAction {
  UpdateIntegralRankListDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateIntegralRankListDataAction {
  UpdateIntegralRankListDataAction({
    this.dataLoadStatus,
    this.integralRanks,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  List<IntegralRank> integralRanks;
  int pageOffset;
}

ThunkAction<AppState> loadIntegralRankListDataAction(int index) {
  return (Store<AppState> store) async {
    try {
      var integralRankListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getIntegralRank(index));
      var integralRankModule = IntegralRankListResponseModule.fromJson(integralRankListResponse.data);
      if (integralRankModule == null ||
          integralRankModule.integralRankListData == null ||
          integralRankModule.integralRankListData.integralRanks == null ||
          integralRankModule.integralRankListData.integralRanks.isEmpty) {
        store.dispatch(UpdateIntegralRankListDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (integralRankModule.errorCode < 0) {
        store.dispatch(UpdateIntegralRankListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateIntegralRankListDataAction(
            dataLoadStatus: DataLoadStatus.loadCompleted,
            integralRanks: integralRankModule.integralRankListData.integralRanks,
            pageOffset: index + 1));
      }
    } catch (e) {
      store.dispatch(UpdateIntegralRankListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateIntegralRankIsPerformingRequestAction {
  UpdateIntegralRankIsPerformingRequestAction({
    this.isPerformingRequest,
  });

  bool isPerformingRequest;
}

class UpdateIntegralRankListLoadMoreDataAction {
  UpdateIntegralRankListLoadMoreDataAction({
    this.isPerformingRequest,
    this.integralRanks,
    this.pageOffset,
  });

  bool isPerformingRequest;
  List<IntegralRank> integralRanks;
  int pageOffset;
}

ThunkAction<AppState> loadMoreAction(List<IntegralRank> integralRanks, int index) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(UpdateIntegralRankIsPerformingRequestAction(isPerformingRequest: true));
      var integralRankListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getIntegralRank(index));
      var integralRankModule = IntegralRankListResponseModule.fromJson(integralRankListResponse.data);

      Future.delayed(const Duration(microseconds: 500), () {
        if (integralRankModule == null ||
            integralRankModule.integralRankListData == null ||
            integralRankModule.integralRankListData.integralRanks == null ||
            integralRankModule.integralRankListData.integralRanks.isEmpty ||
            integralRankModule.errorCode < 0) {
          var edge = 72;
          var offsetFromBottom = store.state.integralRankState.scrollController.position.maxScrollExtent -
              store.state.integralRankState.scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            store.state.integralRankState.scrollController.animateTo(
                store.state.integralRankState.scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut);
          }
          store.dispatch(UpdateIntegralRankIsPerformingRequestAction(isPerformingRequest: false));
        } else {
          integralRanks.addAll(integralRankModule.integralRankListData.integralRanks);
          store.dispatch(
              UpdateIntegralRankListLoadMoreDataAction(isPerformingRequest: false, integralRanks: integralRanks, pageOffset: index + 1));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = store.state.integralRankState.scrollController.position.maxScrollExtent -
            store.state.integralRankState.scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          store.state.integralRankState.scrollController.animateTo(
              store.state.integralRankState.scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut);
        }
        store.dispatch(UpdateIntegralRankIsPerformingRequestAction(isPerformingRequest: false));
      });
    }
  };
}
