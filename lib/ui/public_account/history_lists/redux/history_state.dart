import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/public_account/history_list_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/ui/public_account/services/public_account_services.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class PublicAccountHistoryState extends Cloneable<PublicAccountHistoryState> {
  DataLoadStatus publicAccountHistoryStatus;
  ScrollController scrollController;
  PublicAccountHistoryListModule publicAccountHistoryListModule;
  bool isPerformingRequest;
  int pageOffset;
  PublicAccountPageService publicAccountPageService;
  int chapterId;
  int currentScrollController;

  @override
  PublicAccountHistoryState clone() {
    return PublicAccountHistoryState()
      ..publicAccountHistoryStatus = publicAccountHistoryStatus
      ..publicAccountHistoryListModule = publicAccountHistoryListModule
      ..isPerformingRequest = isPerformingRequest
      ..pageOffset = pageOffset
      ..publicAccountPageService = publicAccountPageService
      ..chapterId = chapterId
      ..currentScrollController = currentScrollController
      ..scrollController = scrollController;
  }
}
