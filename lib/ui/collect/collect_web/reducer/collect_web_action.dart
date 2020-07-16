import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/collect/collect_web_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateCollectWebListDataStatusAction {
  UpdateCollectWebListDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateCollectWebListDataAction {
  UpdateCollectWebListDataAction({
    this.dataLoadStatus,
    this.collectWebs,
  });

  DataLoadStatus dataLoadStatus;
  List<CollectWeb> collectWebs;
}

ThunkAction<AppState> loadCollectWebListDataAction() {
  return (Store<AppState> store) async {
    try {
      var collectWebListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.COLLECT_WEB);
      var collectWebModule = CollectWebListResponseModule.fromJson(collectWebListResponse.data);
      if (collectWebModule == null || collectWebModule.collectWebs == null || collectWebModule.collectWebs.isEmpty) {
        store.dispatch(UpdateCollectWebListDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (collectWebModule.errorCode < 0) {
        store.dispatch(UpdateCollectWebListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateCollectWebListDataAction(
          dataLoadStatus: DataLoadStatus.loadCompleted,
          collectWebs: collectWebModule.collectWebs,
        ));
      }
    } catch (e) {
      store.dispatch(UpdateCollectWebListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateWebCollectsDataAction extends AppHttpResponseAction {
  UpdateWebCollectsDataAction({
    this.collectWebs,
  });

  List<CollectWeb> collectWebs;
}

ThunkAction<AppState> cancelCollectAction(BuildContext context, CollectWeb collectWebs) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var response = await store.state.dio
          .post<Map<String, dynamic>>(NetPath.CANCEL_COLLECT_WEB, queryParameters: <String, dynamic>{'id': collectWebs.id});
      dismissDialog<void>(context);
      store.state.collectWebState.collectWebs.remove(collectWebs);
      store.dispatch(HttpAction(
          context: context, response: response, action: UpdateWebCollectsDataAction(collectWebs: store.state.collectWebState.collectWebs)));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}

ThunkAction<AppState> editCollectAction(BuildContext context, CollectWeb collectWeb, Map<String, String> params) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    var formData = FormData.fromMap(<String, dynamic>{
      'name': params[editTitleKey],
      'link': params[editContentKey],
      'id': collectWeb.id,
    });
    try {
      var updateResponse = await store.state.dio.post<Map<String, dynamic>>(NetPath.UPDATE_COLLECT_WEB, data: formData);
      dismissDialog<void>(context);
      var errorCode = updateResponse.data['errorCode'] as int;
      var errorMsg = updateResponse.data['errorMsg'] as String;
      if (errorCode == 0) {
        store.dispatch(UpdateCollectWebListDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadCollectWebListDataAction());
      } else {
        store.dispatch(HttpAction(error: errorMsg, context: context));
      }
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}

ThunkAction<AppState> addCollectAction(BuildContext context, Map<String, String> params) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    var formData = FormData.fromMap(<String, dynamic>{
      'name': params[editTitleKey],
      'link': params[editContentKey],
    });
    try {
      var updateResponse = await store.state.dio.post<Map<String, dynamic>>(NetPath.ADD_COLLECT_WEB, data: formData);
      dismissDialog<void>(context);
      var errorCode = updateResponse.data['errorCode'] as int;
      var errorMsg = updateResponse.data['errorMsg'] as String;
      if (errorCode == 0) {
        store.dispatch(UpdateCollectWebListDataStatusAction(dataLoadStatus: DataLoadStatus.loading));
        store.dispatch(loadCollectWebListDataAction());
      } else {
        store.dispatch(HttpAction(error: errorMsg, context: context));
      }
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
