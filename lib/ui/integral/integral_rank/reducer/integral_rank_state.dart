import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/integral_rank/integral_rank_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class IntegralRankState extends Cloneable<IntegralRankState> {
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  List<IntegralRank> integralRanks;

  @override
  IntegralRankState clone() {
    return IntegralRankState()
      ..dataLoadStatus = dataLoadStatus
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..pageOffset = pageOffset
      ..integralRanks = integralRanks;
  }
}
