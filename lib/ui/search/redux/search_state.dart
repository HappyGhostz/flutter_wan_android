import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/search/search_hot_key.dart';
import 'package:flutterwanandroid/module/search/search_result.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class SearchState extends Cloneable<SearchState> {
  bool isEditing;

  TextEditingController textEditingController;
  DataLoadStatus dataLoadStatus;
  SearchHotKeyResponseModule searchHotKeyResponseModule;
  List<String> historyList;
  SearchResultResponseModule searchResultResponseModule;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  Map<int, bool> collectIndexs;
  String keyWord;
  int currentIndex;

  @override
  SearchState clone() {
    return SearchState()
      ..isEditing = isEditing
      ..textEditingController = textEditingController
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..dataLoadStatus = dataLoadStatus
      ..searchHotKeyResponseModule = searchHotKeyResponseModule
      ..searchResultResponseModule = searchResultResponseModule
      ..pageOffset = pageOffset
      ..collectIndexs = collectIndexs
      ..keyWord = keyWord
      ..currentIndex = currentIndex
      ..historyList = historyList;
  }
}
