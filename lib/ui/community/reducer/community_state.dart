import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/community/community_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class CommunityState extends Cloneable<CommunityState> {
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  List<Community> communities;
  Map<int, bool> collectIndexs;

  @override
  CommunityState clone() {
    return CommunityState()
      ..dataLoadStatus = dataLoadStatus
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..pageOffset = pageOffset
      ..communities = communities
      ..collectIndexs = collectIndexs;
  }
}
