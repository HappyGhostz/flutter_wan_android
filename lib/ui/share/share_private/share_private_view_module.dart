import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/flushbar/flushbar.dart';
import 'package:flutterwanandroid/module/share/share_other_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/ui/share/share_private/reducer/share_private_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:flutterwanandroid/utils/toast_message.dart';
import 'package:redux/redux.dart';

class SharePrivateViewModule {
  SharePrivateViewModule({
    this.dataLoadStatus,
    this.pageOffset,
    this.scrollController,
    this.isPerformingRequest,
    this.shareOtherData,
    this.refreshData,
    this.showPromptInfo,
    this.pushWebPage,
    this.deletedShareArticle,
    this.addShareArticle,
  });

  DataLoadStatus dataLoadStatus;
  int pageOffset;
  ScrollController scrollController;
  bool isPerformingRequest;
  ShareOtherData shareOtherData;
  Function() refreshData;
  Function(BuildContext context) showPromptInfo;
  Function(BuildContext context, ShareArticle shareArticle) pushWebPage;
  Function(BuildContext context, ShareArticle shareArticle) deletedShareArticle;
  Function(BuildContext context) addShareArticle;

  static SharePrivateViewModule fromStore(Store<AppState> store) {
    var state = store.state.sharePrivateState;
    return SharePrivateViewModule()
      ..dataLoadStatus = state.dataLoadStatus
      ..pageOffset = state.pageOffset
      ..isPerformingRequest = state.isPerformingRequest
      ..scrollController = state.scrollController
      ..shareOtherData = state.shareOtherData
      ..refreshData = () {
        store.dispatch(UpdateSharePrivateDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadSharePrivateDataAction(1));
      }
      ..pushWebPage = (context, collectArticle) {
        var params = <String, dynamic>{};
        params[webTitle] = collectArticle.title;
        params[webUrlKey] = collectArticle.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      }
      ..showPromptInfo = (context) async {
        var isFirstEnterCollectArticle = await store.state.appDependency.sharedPreferences.getBool(isFirstEnterCollectArticleKey);
        if (isFirstEnterCollectArticle == null || !isFirstEnterCollectArticle) {
          await showSuccessFlushBarMessage('左右滑动，删除分享哦！', context, position: FlushbarPosition.BOTTOM);
        }
      }
      ..deletedShareArticle = (context, shareArticle) {
        store.dispatch(deletedShareArticleAction(context, shareArticle));
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
