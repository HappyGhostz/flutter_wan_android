import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/module/system/system_list_module.dart';
import 'package:flutterwanandroid/ui/system/system_list/reducer/system_list_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class SystemListViewModule {
  DataLoadStatus dataLoadStatus;
  List<SystemList> systemLists;
  int pageOffset;
  ScrollController scrollController;
  Function(int id, int index) refreshData;
  bool isPerformingRequest;
  Map<int, bool> collectIndexs;
  Function(BuildContext context, bool isCollect, int index) updateCollectAction;
  Function(BuildContext context, SystemList systemListItem) goToArticle;
  Function(BuildContext context, String author) goToAuthor;

  static SystemListViewModule fromStore(Store<AppState> store) {
    var state = store.state.systemListState;
    return SystemListViewModule()
      ..dataLoadStatus = state.dataLoadStatus ?? DataLoadStatus.loading
      ..pageOffset = state.pageOffset ?? 0
      ..isPerformingRequest = state.isPerformingRequest ?? false
      ..systemLists = state.systemLists
      ..scrollController = state.scrollController
      ..collectIndexs = state.collectIndexs
      ..refreshData = (id, index) {
        store.dispatch(UpdateSystemListDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadSystemListDataAction(id, 0));
      }
      ..updateCollectAction = (context, isCollect, index) {
        store.dispatch(changeTheCollectStatusAction(context, index, isCollect: isCollect));
      }
      ..goToArticle = (context, systemListItem) {
        var params = <String, dynamic>{};
        params[webTitle] = systemListItem.title;
        params[webUrlKey] = systemListItem.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..goToAuthor = (context, name) {
        RouterUtil.pushName(context, AppRouter.authorArticleRouterName, params: <String, dynamic>{
          authorKey: name,
        });
      };
  }
}
