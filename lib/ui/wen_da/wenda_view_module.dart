import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/module/wenda/wen_da_module.dart';
import 'package:flutterwanandroid/ui/wen_da/reducer/wen_da_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class WendaViewModule {
  WendaViewModule({
    this.dataLoadStatus,
    this.pageOffset,
    this.scrollController,
    this.refreshData,
    this.isPerformingRequest,
    this.collectIndexs,
    this.updateCollectAction,
    this.goToAuthor,
    this.wendaLists,
  });

  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  Function(int index) refreshData;
  bool isPerformingRequest;
  Map<int, bool> collectIndexs;
  Function(BuildContext context, bool isCollect, int index) updateCollectAction;
  Function(BuildContext context, WendaModule wendaModule) goToArticle;
  Function(BuildContext context, String author) goToAuthor;
  List<WendaModule> wendaLists;

  static WendaViewModule fromStore(Store<AppState> store) {
    var state = store.state.wendaState;
    return WendaViewModule()
      ..dataLoadStatus = state.dataLoadStatus ?? DataLoadStatus.loading
      ..pageOffset = state.pageOffset ?? 0
      ..isPerformingRequest = state.isPerformingRequest ?? false
      ..wendaLists = state.wendaLists
      ..scrollController = state.scrollController
      ..collectIndexs = state.collectIndexs
      ..refreshData = (index) {
        store.dispatch(UpdateWendaListDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadWendaListDataAction(1));
      }
      ..updateCollectAction = (context, isCollect, index) {
        store.dispatch(changeTheCollectStatusAction(context, index, isCollect: isCollect));
      }
      ..goToArticle = (context, wendaModule) {
        var params = <String, dynamic>{};
        params[webTitle] = wendaModule.title;
        params[webUrlKey] = wendaModule.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..goToAuthor = (context, name) {
        RouterUtil.pushName(context, AppRouter.authorArticleRouterName, params: <String, dynamic>{
          authorKey: name,
        });
      };
  }
}
