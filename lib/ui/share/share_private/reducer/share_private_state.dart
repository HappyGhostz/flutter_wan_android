import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/share/share_other_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class SharePrivateState extends Cloneable<SharePrivateState> {
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  ShareOtherData shareOtherData;

  @override
  SharePrivateState clone() {
    return SharePrivateState()
      ..dataLoadStatus = dataLoadStatus
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..pageOffset = pageOffset
      ..shareOtherData = shareOtherData;
  }
}
