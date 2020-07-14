import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/wenda/wen_da_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class WendaState extends Cloneable<WendaState> {
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  Map<int, bool> collectIndexs;
  List<WendaModule> wendaLists;

  @override
  WendaState clone() {
    return WendaState()
      ..dataLoadStatus = dataLoadStatus
      ..scrollController = scrollController
      ..wendaLists = wendaLists
      ..isPerformingRequest = isPerformingRequest
      ..collectIndexs = collectIndexs
      ..pageOffset = pageOffset;
  }
}
