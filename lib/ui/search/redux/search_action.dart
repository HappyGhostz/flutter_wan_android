import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/search/search_hot_key.dart';
import 'package:flutterwanandroid/module/search/search_result.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class SearchStatusChangedAction {
  SearchStatusChangedAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class SearchUpdateHotKeyModuleAction {
  SearchUpdateHotKeyModuleAction({
    this.searchHotKeyResponseModule,
    this.dataLoadStatus,
  });

  SearchHotKeyResponseModule searchHotKeyResponseModule;
  DataLoadStatus dataLoadStatus;
}

class ClearDataAction {
  ClearDataAction();
}

ThunkAction<AppState> getHotKeyAction() {
  return (Store<AppState> store) async {
    try {
      var hotKeyResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.HOT_KEY);
      var searchHotKeyModule = SearchHotKeyResponseModule.fromJson(hotKeyResponse.data);
      if (searchHotKeyModule.errorCode != 0) {
        store.dispatch(SearchStatusChangedAction(dataLoadStatus: DataLoadStatus.failure));
      } else if (searchHotKeyModule.hotKey == null || searchHotKeyModule.hotKey.isEmpty) {
        store.dispatch(SearchStatusChangedAction(dataLoadStatus: DataLoadStatus.empty));
      } else {
        store.dispatch(
            SearchUpdateHotKeyModuleAction(dataLoadStatus: DataLoadStatus.loadCompleted, searchHotKeyResponseModule: searchHotKeyModule));
      }
    } catch (e) {
      store.dispatch(SearchStatusChangedAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateHistorySearchAction {
  UpdateHistorySearchAction({
    this.historyList,
  });

  List<String> historyList;
}

ThunkAction<AppState> getHistorySearchKey() {
  return (Store<AppState> store) async {
    try {
      var sharedPreferences = await store.state.appDependency.sharedPreferences;
      var historyList = sharedPreferences.getStringList(searchHistoryKey);
      if (historyList == null) {
        historyList = <String>[];
      }
      store.dispatch(UpdateHistorySearchAction(historyList: historyList));
    } catch (e) {
      store.dispatch(UpdateHistorySearchAction(historyList: <String>[]));
    }
  };
}

class UpdateEditStatusAction {
  UpdateEditStatusAction({
    this.isEdit,
  });

  bool isEdit;
}

class UpdateSearchResultModuleAction {
  UpdateSearchResultModuleAction({
    this.searchResultResponseModule,
    this.dataLoadStatus,
    this.pageOffset,
    this.keyWord,
  });

  SearchResultResponseModule searchResultResponseModule;
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  String keyWord;
}

ThunkAction<AppState> searchAction(String keyWord, int index) {
  return (Store<AppState> store) async {
    try {
      var searchResponse = await store.state.dio.post<Map<String, dynamic>>(NetPath.search(index), queryParameters: <String, dynamic>{
        'k': keyWord,
      });
      var searchResultModule = SearchResultResponseModule.fromJson(searchResponse.data);
      if (searchResultModule.errorCode != 0) {
        store.dispatch(SearchStatusChangedAction(dataLoadStatus: DataLoadStatus.failure));
      } else if (searchResultModule.searchResultModule == null ||
          searchResultModule.searchResultModule.searchResults == null ||
          searchResultModule.searchResultModule.searchResults.isEmpty) {
        store.dispatch(SearchStatusChangedAction(dataLoadStatus: DataLoadStatus.empty));
      } else {
        store.dispatch(UpdateSearchResultModuleAction(
            dataLoadStatus: DataLoadStatus.loadCompleted, searchResultResponseModule: searchResultModule, pageOffset: 1, keyWord: keyWord));
      }
    } catch (e) {
      store.dispatch(SearchStatusChangedAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class ChangeSearchPerformingRequestStatusAction {
  ChangeSearchPerformingRequestStatusAction({
    this.isPerforming,
  });

  bool isPerforming;
}

class SearchLoadMoreAction {
  SearchLoadMoreAction({
    this.searchResultResponseModule,
    this.pageOffset,
    this.isPerforming,
  });

  SearchResultResponseModule searchResultResponseModule;
  int pageOffset;
  bool isPerforming;
}

ThunkAction<AppState> loadMoreAction(
    String keyWord, int index, SearchResultResponseModule searchResultResponseModule, ScrollController listController) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(ChangeSearchPerformingRequestStatusAction(isPerforming: true));
      var searchResponse = await store.state.dio.post<Map<String, dynamic>>(NetPath.search(index), queryParameters: <String, dynamic>{
        'k': keyWord,
      });
      var searchResultModule = SearchResultResponseModule.fromJson(searchResponse.data);
      Future.delayed(const Duration(microseconds: 500), () {
        if (searchResultModule == null ||
            searchResultModule.searchResultModule == null ||
            searchResultModule.searchResultModule.searchResults.isEmpty) {
          var edge = 72;
          var offsetFromBottom = listController.position.maxScrollExtent - listController.position.pixels;
          if (offsetFromBottom < edge) {
            listController.animateTo(listController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          }
          store.dispatch(ChangeSearchPerformingRequestStatusAction(isPerforming: false));
        } else {
          searchResultResponseModule.searchResultModule.searchResults.addAll(searchResultModule.searchResultModule.searchResults);
          store.dispatch(
              SearchLoadMoreAction(searchResultResponseModule: searchResultResponseModule, pageOffset: index + 1, isPerforming: false));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = listController.position.maxScrollExtent - listController.position.pixels;
        if (offsetFromBottom < edge) {
          listController.animateTo(listController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
        store.dispatch(ChangeSearchPerformingRequestStatusAction(isPerforming: false));
      });
    }
  };
}

ThunkAction<AppState> saveHistoryKeyAction(String keyWord, List<String> historyList) {
  return (Store<AppState> store) async {
    try {
      if (historyList == null) {
        historyList = <String>[];
      }
      if (!historyList.contains(keyWord) && keyWord != null && keyWord.isNotEmpty) {
        historyList.insert(0, keyWord);
      }
      store.dispatch(UpdateHistorySearchAction(historyList: historyList));
      var sharedPreferences = store.state.appDependency.sharedPreferences;
      await sharedPreferences.setStringList(searchHistoryKey, historyList);
    } catch (e) {
      print(e.toString());
    }
  };
}

class UpdateSearchCollectsDataAction extends AppHttpResponseAction {
  UpdateSearchCollectsDataAction({
    this.collectIndexs,
  });

  Map<int, bool> collectIndexs;
}

ThunkAction<AppState> changeTheCollectStatusAction(BuildContext context, {bool collect, int indexCount}) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var id = store.state.searchState.searchResultResponseModule.searchResultModule.searchResults[indexCount].id;
      Response response;
      if (collect) {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      dismissDialog<void>(context);
      var collects = <int, bool>{};
      collects[indexCount] = collect;
      store.dispatch(HttpAction(context: context, response: response, action: UpdateSearchCollectsDataAction(collectIndexs: collects)));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
