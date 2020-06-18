import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/first_page/article.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class AuthorState extends Cloneable<AuthorState> {
  DataLoadStatus dataLoadStatus;
  ArticleModule articleModule;
  ScrollController scrollController;
  bool isPerformingRequest;
  Map<int, bool> collectIndexs;
  int pageOffset;

  @override
  AuthorState clone() {
    return AuthorState()
      ..dataLoadStatus = dataLoadStatus
      ..articleModule = articleModule
      ..isPerformingRequest = isPerformingRequest
      ..collectIndexs = collectIndexs
      ..pageOffset = pageOffset
      ..scrollController = scrollController;
  }
}
