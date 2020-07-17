import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/module/share/share_other_module.dart';
import 'package:flutterwanandroid/ui/share/share_other/reducer/share_other_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class ShareOtherViewModule {
  ShareOtherViewModule({
    this.dataLoadStatus,
    this.pageOffset,
    this.scrollController,
    this.isPerformingRequest,
    this.refreshData,
    this.collectIndexs,
  });

  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  ShareOtherData shareOtherData;
  Function(int userId) refreshData;
  Map<int, bool> collectIndexs;
  Function(BuildContext context, bool collect, int indexCount) updateCollectAction;
  Function(BuildContext context, ShareArticle article) goToArticle;

  static ShareOtherViewModule fromStore(Store<AppState> store) {
    var state = store.state.shareOtherState;
    return ShareOtherViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..pageOffset = state.pageOffset
      ..isPerformingRequest = state.isPerformingRequest
      ..scrollController = state.scrollController
      ..shareOtherData = state.shareOtherData
      ..collectIndexs = state.collectIndexs
      ..refreshData = (userId) {
        store.dispatch(UpdateShareOtherDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadShareOtherListDataAction(userId, 1));
      }
      ..updateCollectAction = (context, collect, index) {
        store.dispatch(changeTheShareCollectStatusAction(context, collect: collect, indexCount: index));
      }
      ..goToArticle = (context, article) {
        var params = <String, dynamic>{};
        params[webTitle] = article.title;
        params[webUrlKey] = article.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      };
  }
}
