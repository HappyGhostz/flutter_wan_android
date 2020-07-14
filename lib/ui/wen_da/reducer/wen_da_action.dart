import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/module/wenda/wen_da_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateWendaListDataStatusAction {
  UpdateWendaListDataStatusAction({
    this.dataLoadStatus,
  });

  DataLoadStatus dataLoadStatus;
}

class UpdateWendaListDataAction {
  UpdateWendaListDataAction({
    this.dataLoadStatus,
    this.wendaLists,
    this.pageOffset,
  });

  DataLoadStatus dataLoadStatus;
  List<WendaModule> wendaLists;
  int pageOffset;
}

ThunkAction<AppState> loadWendaListDataAction(int index) {
  return (Store<AppState> store) async {
    try {
      var wendaListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getWenda(index));
      var wendaListModule = WendaListResponseModule.fromJson(wendaListResponse.data);
      if (wendaListModule == null ||
          wendaListModule.wendaListData == null ||
          wendaListModule.wendaListData.wendas == null ||
          wendaListModule.wendaListData.wendas.isEmpty) {
        store.dispatch(UpdateWendaListDataStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (wendaListModule.errorCode < 0) {
        store.dispatch(UpdateWendaListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateWendaListDataAction(
            dataLoadStatus: DataLoadStatus.loadCompleted, wendaLists: wendaListModule.wendaListData.wendas, pageOffset: index + 1));
      }
    } catch (e) {
      store.dispatch(UpdateWendaListDataStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

class UpdateWendaIsPerformingRequestAction {
  UpdateWendaIsPerformingRequestAction({
    this.isPerformingRequest,
  });

  bool isPerformingRequest;
}

class UpdateWendaListLoadMoreDataAction {
  UpdateWendaListLoadMoreDataAction({
    this.isPerformingRequest,
    this.wendaLists,
    this.pageOffset,
  });

  bool isPerformingRequest;
  List<WendaModule> wendaLists;
  int pageOffset;
}

ThunkAction<AppState> loadMoreAction(List<WendaModule> wendaLists, int index) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(UpdateWendaIsPerformingRequestAction(isPerformingRequest: true));
      var wendaListResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.getWenda(index));
      var wendaListModule = WendaListResponseModule.fromJson(wendaListResponse.data);

      Future.delayed(const Duration(microseconds: 500), () {
        if (wendaListModule == null ||
            wendaListModule.wendaListData == null ||
            wendaListModule.wendaListData.wendas == null ||
            wendaListModule.wendaListData.wendas.isEmpty ||
            wendaListModule.errorCode < 0) {
          var edge = 72;
          var offsetFromBottom =
              store.state.wendaState.scrollController.position.maxScrollExtent - store.state.wendaState.scrollController.position.pixels;
          if (offsetFromBottom < edge) {
            store.state.wendaState.scrollController.animateTo(store.state.wendaState.scrollController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          }
          store.dispatch(UpdateWendaIsPerformingRequestAction(isPerformingRequest: false));
        } else {
          wendaLists.addAll(wendaListModule.wendaListData.wendas);
          store.dispatch(UpdateWendaListLoadMoreDataAction(isPerformingRequest: false, wendaLists: wendaLists, pageOffset: index + 1));
        }
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom =
            store.state.wendaState.scrollController.position.maxScrollExtent - store.state.wendaState.scrollController.position.pixels;
        if (offsetFromBottom < edge) {
          store.state.wendaState.scrollController.animateTo(store.state.wendaState.scrollController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
        store.dispatch(UpdateWendaIsPerformingRequestAction(isPerformingRequest: false));
      });
    }
  };
}

class UpdateWendaListCollectsDataAction extends AppHttpResponseAction {
  UpdateWendaListCollectsDataAction({
    this.isCollects,
  });

  Map<int, bool> isCollects;
}

ThunkAction<AppState> changeTheCollectStatusAction(BuildContext context, int index, {bool isCollect}) {
  showLoadingDialog<void>(context);
  return (Store<AppState> store) async {
    try {
      var id = store.state.wendaState.wendaLists[index].id;
      Response response;
      if (isCollect) {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      dismissDialog<void>(context);
      var collects = <int, bool>{};
      collects[index] = isCollect;
      store.dispatch(HttpAction(context: context, response: response, action: UpdateWendaListCollectsDataAction(isCollects: collects)));
    } on DioError catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      dismissDialog<void>(context);
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
