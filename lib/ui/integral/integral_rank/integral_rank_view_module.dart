import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/integral_rank/integral_rank_module.dart';
import 'package:flutterwanandroid/ui/integral/integral_rank/reducer/integral_rank_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';

class IntegralRankViewModule {
  IntegralRankViewModule({
    this.dataLoadStatus,
    this.pageOffset,
    this.scrollController,
    this.refreshData,
    this.isPerformingRequest,
    this.integralRanks,
  });

  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  Function(int index) refreshData;
  bool isPerformingRequest;
  List<IntegralRank> integralRanks;

  static IntegralRankViewModule fromStore(Store<AppState> store) {
    var state = store.state.integralRankState;
    return IntegralRankViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..pageOffset = state.pageOffset
      ..isPerformingRequest = state.isPerformingRequest
      ..integralRanks = state.integralRanks
      ..scrollController = state.scrollController
      ..refreshData = (index) {
        store.dispatch(loadIntegralRankListDataAction(index));
      };
  }
}
