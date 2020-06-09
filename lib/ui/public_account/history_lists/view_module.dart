import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/public_account/history_list_module.dart';
import 'package:flutterwanandroid/ui/public_account/history_lists/redux/history_action.dart';
import 'package:flutterwanandroid/ui/public_account/services/public_account_services.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';

class PublicAccountHistoryViewModule {
  PublicAccountHistoryViewModule({
    this.publicAccountHistoryStatus,
    this.refreshData,
    this.scrollController,
    this.publicAccountHistoryListModule,
    this.isPerformingRequest,
    this.pageOffset,
    this.publicAccountPageService,
  });

  DataLoadStatus publicAccountHistoryStatus;
  Function(int chapterId) refreshData;
  ScrollController scrollController;
  PublicAccountHistoryListModule publicAccountHistoryListModule;
  bool isPerformingRequest;
  int pageOffset;
  PublicAccountPageService publicAccountPageService;
  int chapterId;
  int currentScrollController;

  static PublicAccountHistoryViewModule fromStore(Store<AppState> store) {
    var state = store.state.publicAccountHistoryState;
    return PublicAccountHistoryViewModule()
      ..publicAccountHistoryStatus = state.publicAccountHistoryStatus
      ..scrollController = state.scrollController
      ..publicAccountHistoryListModule = state.publicAccountHistoryListModule
      ..isPerformingRequest = state.isPerformingRequest
      ..pageOffset = state.pageOffset
      ..chapterId = state.chapterId
      ..currentScrollController = state.currentScrollController
      ..publicAccountPageService = state.publicAccountPageService
      ..refreshData = (chapterId) {
        store.dispatch(PublicAccountHistoryDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(refreshHistoryDataAction(0, chapterId));
      };
  }
}
