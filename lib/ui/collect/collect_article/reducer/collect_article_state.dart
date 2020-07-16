import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/collect/collect_article_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class CollectArticleState extends Cloneable<CollectArticleState> {
  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  List<CollectArticle> collectArticles;

  @override
  CollectArticleState clone() {
    return CollectArticleState()
      ..dataLoadStatus = dataLoadStatus
      ..scrollController = scrollController
      ..isPerformingRequest = isPerformingRequest
      ..pageOffset = pageOffset
      ..collectArticles = collectArticles;
  }
}
