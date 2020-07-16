import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/collect/collect_web_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class CollectWebState extends Cloneable<CollectWebState> {
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  List<CollectWeb> collectWebs;
  @override
  CollectWebState clone() {
    return CollectWebState()
      ..dataLoadStatus = dataLoadStatus
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..pageOffset = pageOffset
      ..collectWebs = collectWebs;
  }
}
