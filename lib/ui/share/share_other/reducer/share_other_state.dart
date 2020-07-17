import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/share/share_other_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class ShareOtherState extends Cloneable<ShareOtherState> {
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  ShareOtherData shareOtherData;
  Map<int, bool> collectIndexs;

  @override
  ShareOtherState clone() {
    return ShareOtherState()
      ..dataLoadStatus = dataLoadStatus
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..pageOffset = pageOffset
      ..collectIndexs = collectIndexs
      ..shareOtherData = shareOtherData;
  }
}
