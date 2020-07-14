import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/system/system_list_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class SystemListState extends Cloneable<SystemListState> {
  DataLoadStatus dataLoadStatus;
  List<SystemList> systemLists;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  Map<int, bool> collectIndexs;

  @override
  SystemListState clone() {
    return SystemListState()
      ..dataLoadStatus = dataLoadStatus
      ..systemLists = systemLists
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..collectIndexs = collectIndexs
      ..pageOffset = pageOffset;
  }
}
