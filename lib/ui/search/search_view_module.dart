import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/module/search/search_hot_key.dart';
import 'package:flutterwanandroid/module/search/search_result.dart';
import 'package:flutterwanandroid/ui/search/redux/search_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class SearchViewModule {
  SearchViewModule({
    this.isEditing,
    this.textEditingController,
    this.dataLoadStatus,
    this.refreshHotKey,
    this.searchHotKeyResponseModule,
    this.historyList,
    this.searchResultResponseModule,
    this.pageOffset,
    this.scrollController,
    this.isPerformingRequest,
    this.collectIndexs,
    this.keyWord,
    this.clearData,
    this.saveHistoryKey,
    this.goToSearchArticle,
    this.updateCollectAction,
  });

  bool isEditing;
  TextEditingController textEditingController;
  DataLoadStatus dataLoadStatus;
  Function refreshHotKey;
  SearchHotKeyResponseModule searchHotKeyResponseModule;
  List<String> historyList;
  Function(bool isEdit) updateIsEditStatus;
  Function(String keyWord, int index) search;
  SearchResultResponseModule searchResultResponseModule;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  Map<int, bool> collectIndexs;
  String keyWord;
  Function clearData;
  Function(String keyWord, List<String> historyList) saveHistoryKey;
  Function(BuildContext context, SearchResult searchResult) goToSearchArticle;
  Function(BuildContext context, bool collect, int indexCount) updateCollectAction;

  static SearchViewModule fromStore(Store<AppState> store) {
    var searchState = store.state.searchState;
    return SearchViewModule()
      ..isEditing = searchState.isEditing
      ..pageOffset = searchState.pageOffset
      ..textEditingController = searchState.textEditingController
      ..scrollController = searchState.scrollController
      ..dataLoadStatus = searchState.dataLoadStatus
      ..searchHotKeyResponseModule = searchState.searchHotKeyResponseModule
      ..historyList = searchState.historyList
      ..isPerformingRequest = searchState.isPerformingRequest
      ..searchResultResponseModule = searchState.searchResultResponseModule
      ..collectIndexs = searchState.collectIndexs
      ..keyWord = searchState.keyWord
      ..refreshHotKey = () {
        store.dispatch(SearchStatusChangedAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(getHotKeyAction());
      }
      ..updateIsEditStatus = (isEdit) {
        store.dispatch(UpdateEditStatusAction(isEdit: isEdit));
      }
      ..search = (keyWord, index) {
        store.dispatch(SearchStatusChangedAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(searchAction(keyWord, index));
      }
      ..clearData = () {
        store.dispatch(ClearDataAction());
      }
      ..saveHistoryKey = (keyWord, historyList) {
        store.dispatch(saveHistoryKeyAction(keyWord, historyList));
      }
      ..goToSearchArticle = (context, searchResult) {
        var params = <String, dynamic>{};
        params[webTitle] = searchResult.title;
        params[webUrlKey] = searchResult.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..updateCollectAction = (context, collect, indexCount) {
        store.dispatch(changeTheCollectStatusAction(context, collect: collect, indexCount: indexCount));
      };
  }
}
