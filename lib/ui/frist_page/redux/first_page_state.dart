import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/first_page/fist_page_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/ui/frist_page/services/first_page_service.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class FirstPageState implements Cloneable<FirstPageState> {
  int currentIndex;
  DataLoadStatus firstPageStatus;
  FirstPageService firstPageService;
  FirstPageModule firstPageModule;
  bool isPerformingRequest;
  int pageOffset;
  ScrollController scrollController;
  Color tabBackgroundTagViewColor;
  Color tabBackgroundNameColor;
  Color tabBackgroundTypeColor;
  Color tagTextInfoColor;
  Map<int, bool> collectIndexs;

  @override
  FirstPageState clone() {
    return FirstPageState()
      ..currentIndex = currentIndex
      ..pageOffset = pageOffset
      ..collectIndexs = collectIndexs
      ..firstPageStatus = firstPageStatus
      ..firstPageModule = firstPageModule
      ..scrollController = scrollController
      ..tabBackgroundTagViewColor = tabBackgroundTagViewColor
      ..tabBackgroundNameColor = tabBackgroundNameColor
      ..tabBackgroundTypeColor = tabBackgroundTypeColor
      ..tagTextInfoColor = tagTextInfoColor
      ..isPerformingRequest = isPerformingRequest
      ..firstPageService = firstPageService;
  }
}
