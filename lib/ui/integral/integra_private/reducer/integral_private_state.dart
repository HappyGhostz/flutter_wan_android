import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/integral/integral_private_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class IntegralPrivateState extends Cloneable<IntegralPrivateState> {
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  List<IntegralPrivate> integralPrivates;

  @override
  IntegralPrivateState clone() {
    return IntegralPrivateState()
      ..dataLoadStatus = dataLoadStatus
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..pageOffset = pageOffset
      ..integralPrivates = integralPrivates;
  }
}
