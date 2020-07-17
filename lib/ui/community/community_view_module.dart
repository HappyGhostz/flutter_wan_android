import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/module/community/community_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/ui/community/reducer/community_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/redux.dart';

class CommunityViewModule {
  CommunityViewModule({
    this.dataLoadStatus,
    this.pageOffset,
    this.scrollController,
    this.isPerformingRequest,
    this.communities,
    this.refreshData,
    this.collectIndexs,
    this.updateCollectAction,
    this.goToArticle,
  });

  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  List<Community> communities;
  Map<int, bool> collectIndexs;
  Function refreshData;
  Function(BuildContext context, bool collect, int indexCount) updateCollectAction;
  Function(BuildContext context, Community article) goToArticle;
  Function(BuildContext context, Map<String, dynamic>) toShareArticle;
  Function(BuildContext context) addShareArticle;

  static CommunityViewModule fromStore(Store<AppState> store) {
    var state = store.state.communityState;
    return CommunityViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..pageOffset = state.pageOffset
      ..isPerformingRequest = state.isPerformingRequest
      ..scrollController = state.scrollController
      ..communities = state.communities
      ..collectIndexs = state.collectIndexs
      ..refreshData = () {
        store.dispatch(UpdateCommunityDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadCommunityDataAction(0));
      }
      ..updateCollectAction = (context, collect, indexCount) {
        store.dispatch(changeTheCollectStatusAction(context, collect: collect, indexCount: indexCount));
      }
      ..goToArticle = (context, article) {
        var params = <String, dynamic>{};
        params[webTitle] = article.title;
        params[webUrlKey] = article.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..toShareArticle = (context, params) {
        RouterUtil.pushName(context, AppRouter.shareOtherArticle, params: params);
      }
      ..addShareArticle = (context) async {
        try {
          var cookies = store.state.cookJar.loadForRequest(Uri.parse('${NetPath.APP_BASE_URL}${NetPath.LOG_IN}'));
          if (cookies != null && cookies.length >= 2) {
            var cookie = cookies[1];
            var name = cookie.value;
            var params = await showShareArticleDialog(context, author: name);
            if (params.isEmpty) {
              return;
            }
            store.dispatch(addShareArticleAction(context, params));
          } else {
            return;
          }
        } catch (e) {
          return;
        }
      };
  }
}
