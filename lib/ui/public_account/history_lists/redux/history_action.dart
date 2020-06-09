import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/public_account/history_list_module.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class PublicAccountHistoryDataStatusAction {
  PublicAccountHistoryDataStatusAction({this.dataLoadStatus});

  DataLoadStatus dataLoadStatus;
}

class UpdatePublicAccountHistoryDataAction {
  UpdatePublicAccountHistoryDataAction({
    this.dataLoadStatus,
    this.data,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  PublicAccountHistoryListModule data;
  int pageOffset;
}

class HistoryChangePerformingRequestStatusAction {
  HistoryChangePerformingRequestStatusAction({
    this.isPerFormingValue,
  });

  bool isPerFormingValue;
}

class UpdatePublicAccountMoreHistoryDataAction {
  UpdatePublicAccountMoreHistoryDataAction({
    this.data,
    this.pageOffset,
    this.isPerFormingValue,
  });

  PublicAccountHistoryListModule data;
  int pageOffset;
  bool isPerFormingValue;
}

ThunkAction<AppState> refreshHistoryDataAction(int index, int chapterId) {
  return (Store<AppState> store) async {
    try {
      var historyData =
          await store.state.publicAccountHistoryState.publicAccountPageService.getPublicAccountHistoryActicles(chapterId, index);
      if (historyData == null) {
        store.dispatch(PublicAccountHistoryDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (historyData.errorCode < 0) {
        store.dispatch(PublicAccountHistoryDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store
            .dispatch(UpdatePublicAccountHistoryDataAction(data: historyData, dataLoadStatus: DataLoadStatus.loadCompleted, pageOffset: 2));
      }
    } on DioError catch (e) {
      store.dispatch(PublicAccountHistoryDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    } catch (e) {
      store.dispatch(PublicAccountHistoryDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

ThunkAction<AppState> loadMoreAction(
    int chapterId, int index, PublicAccountHistoryListModule historyModules, ScrollController listController, int currentScrollController) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(HistoryChangePerformingRequestStatusAction(isPerFormingValue: true));
      var historyData =
          await store.state.publicAccountHistoryState.publicAccountPageService.getHistoryMoreData(historyModules, chapterId, index);

      Future.delayed(const Duration(microseconds: 500), () {
        if (historyData == null) {
          var edge = 72;
          var offsetFromBottom =
              // ignore: invalid_use_of_protected_member
              listController.positions.elementAt(currentScrollController).maxScrollExtent -
                  // ignore: invalid_use_of_protected_member
                  listController.positions.elementAt(currentScrollController).pixels;
          if (offsetFromBottom < edge) {
            listController.animateTo(listController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          }
          historyData = historyModules;
        }
        store.dispatch(UpdatePublicAccountMoreHistoryDataAction(data: historyData, pageOffset: index + 1, isPerFormingValue: false));
      });
    } on DioError catch (e) {
      print('publicAccountPageService::loadMore:${e.toString()}');
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        // ignore: invalid_use_of_protected_member
        var offsetFromBottom = listController.positions.elementAt(currentScrollController).maxScrollExtent -
            // ignore: invalid_use_of_protected_member
            listController.positions.elementAt(currentScrollController).pixels;
        if (offsetFromBottom < edge) {
          listController.animateTo(listController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
        store.dispatch(HistoryChangePerformingRequestStatusAction(isPerFormingValue: false));
      });
    } catch (e) {
      print('publicAccountPageService::loadMore:${e.toString()}');
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        // ignore: invalid_use_of_protected_member
        var offsetFromBottom = listController.positions.elementAt(currentScrollController).maxScrollExtent -
            // ignore: invalid_use_of_protected_member
            listController.positions.elementAt(currentScrollController).pixels;
        if (offsetFromBottom < edge) {
          listController.animateTo(listController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
        store.dispatch(HistoryChangePerformingRequestStatusAction(isPerFormingValue: false));
      });
    }
  };
}
