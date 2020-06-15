import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/module/first_page/article.dart';
import 'package:flutterwanandroid/module/first_page/fist_page_module.dart';
import 'package:flutterwanandroid/module/first_page/top_article.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class FirstPageViewModule {
  FirstPageViewModule({
    this.firstPageStatus,
    this.refreshFirstPageData,
    this.isPerformingRequest,
    this.collectIndexs,
  });

  DataLoadStatus firstPageStatus;
  Function() refreshFirstPageData;
  int currentIndex;
  int pageOffset;
  FirstPageModule firstPageModule;
  bool isPerformingRequest;
  ScrollController scrollController;
  Function(Color changeColor) changeTypeColorForTapDown;
  Function(Color changeColor, Color textInfoColor) changeTagViewColorForTapDown;
  Function(Color changeColor) changeNameColorForTapDown;
  Color tabBackgroundTagViewColor;
  Color tabBackgroundNameColor;
  Color tabBackgroundTypeColor;
  Color tagTextInfoColor;
  Map<int, bool> collectIndexs;
  Function(BuildContext context, bool collect, bool isTopArticle, int indexCount) updateCollectAction;
  Function(BuildContext context, TopArticleData topArticle) goToTopArticle;
  Function(BuildContext context, Datas article) goToArticle;

  static FirstPageViewModule fromStore(Store<AppState> store) {
    var firstState = store.state.firstPageState;
    return FirstPageViewModule()
      ..firstPageStatus = firstState.firstPageStatus
      ..collectIndexs = firstState.collectIndexs
      ..currentIndex = firstState.currentIndex
      ..firstPageModule = firstState.firstPageModule
      ..isPerformingRequest = firstState.isPerformingRequest
      ..scrollController = firstState.scrollController
      ..pageOffset = firstState.pageOffset
      ..tabBackgroundTypeColor = firstState.tabBackgroundTypeColor
      ..tabBackgroundTagViewColor = firstState.tabBackgroundTagViewColor
      ..tagTextInfoColor = firstState.tagTextInfoColor
      ..tabBackgroundNameColor = firstState.tabBackgroundNameColor
      ..refreshFirstPageData = () {
        store.dispatch(ChangePageStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadInitDataAction(0));
      }
      ..changeNameColorForTapDown = (changeColor) {
        store.dispatch(ChangeNameViewColorAction(changeColor: changeColor));
      }
      ..changeTagViewColorForTapDown = (changeColor, textInfoColor) {
        store.dispatch(ChangeTagViewColorAction(changeColor: changeColor, textInfoColor: textInfoColor));
      }
      ..changeTypeColorForTapDown = (changeColor) {
        store.dispatch(ChangeTypeViewColorAction(changeColor: changeColor));
      }
      ..updateCollectAction = (context, collect, isTopArticle, indexCount) {
        store.dispatch(changeTheCollectStatusAction(context, collect: collect, isTopArticle: isTopArticle, indexCount: indexCount));
      }
      ..goToTopArticle = (context, topArticle) {
        var params = <String, dynamic>{};
        params[webTitle] = topArticle.title;
        params[webUrlKey] = topArticle.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..goToArticle = (context, article) {
        var params = <String, dynamic>{};
        params[webTitle] = article.title;
        params[webUrlKey] = article.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      };
  }
}
