import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/integral/integral_private_module.dart';
import 'package:flutterwanandroid/ui/integral/integra_private/reducer/integral_private_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';

class IntegralPrivateViewModule {
  IntegralPrivateViewModule({
    this.dataLoadStatus,
    this.pageOffset,
    this.scrollController,
    this.refreshData,
    this.isPerformingRequest,
    this.integralPrivates,
  });

  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  Function(int index, int id) refreshData;
  bool isPerformingRequest;
  List<IntegralPrivate> integralPrivates;

  static IntegralPrivateViewModule fromStore(Store<AppState> store) {
    var state = store.state.integralPrivateState;
    return IntegralPrivateViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..pageOffset = state.pageOffset
      ..isPerformingRequest = state.isPerformingRequest
      ..scrollController = state.scrollController
      ..integralPrivates = state.integralPrivates
      ..refreshData = (index, id) {
        store.dispatch(UpdateIntegralPrivateListDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadIntegralPrivateListDataAction(index, id: id));
      };
  }
}
