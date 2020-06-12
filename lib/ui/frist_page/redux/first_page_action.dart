import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/first_page/fist_page_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class ChangePageStatusAction {
  ChangePageStatusAction({this.dataLoadStatus});

  DataLoadStatus dataLoadStatus;
}

class UpdateFirstDataAction {
  UpdateFirstDataAction({
    this.firstPageModule,
    this.dataLoadStatus,
    this.pageOffset,
  });

  FirstPageModule firstPageModule;
  DataLoadStatus dataLoadStatus;
  int pageOffset;
}

class LoadMoreFirstDataAction {
  LoadMoreFirstDataAction({
    this.firstPageModule,
    this.pageOffset,
    this.isChangePerformingRequestStatus,
  });

  FirstPageModule firstPageModule;
  int pageOffset;
  bool isChangePerformingRequestStatus;
}

class ChangePerformingRequestStatusAction {
  ChangePerformingRequestStatusAction({
    this.isChangePerformingRequestStatus,
  });

  bool isChangePerformingRequestStatus;
}

class ChangeTagViewColorAction {
  ChangeTagViewColorAction({
    this.changeColor,
    this.textInfoColor,
  });

  Color changeColor;
  Color textInfoColor;
}

class ChangeNameViewColorAction {
  ChangeNameViewColorAction({
    this.changeColor,
  });

  Color changeColor;
}

class ChangeTypeViewColorAction {
  ChangeTypeViewColorAction({
    this.changeColor,
  });

  Color changeColor;
}

ThunkAction<AppState> loadInitDataAction(int index) {
  return (Store<AppState> store) async {
    try {
      var firstData = await store.state.firstPageState.firstPageService.getFirstPageData(index);
      if (firstData == null) {
        store.dispatch(ChangePageStatusAction(dataLoadStatus: DataLoadStatus.empty));
      } else if (firstData.errorCode < 0) {
        store.dispatch(ChangePageStatusAction(dataLoadStatus: DataLoadStatus.failure));
      } else {
        store.dispatch(UpdateFirstDataAction(firstPageModule: firstData, dataLoadStatus: DataLoadStatus.loadCompleted, pageOffset: 1));
      }
    } on DioError catch (e) {
      store.dispatch(ChangePageStatusAction(dataLoadStatus: DataLoadStatus.failure));
    } catch (e) {
      store.dispatch(ChangePageStatusAction(dataLoadStatus: DataLoadStatus.failure));
    }
  };
}

ThunkAction<AppState> loadMoreAction(int index, FirstPageModule firstPageModule, ScrollController listController) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(ChangePerformingRequestStatusAction(isChangePerformingRequestStatus: true));
      var firstData = await store.state.firstPageState.firstPageService.getFirstPageMoreData(firstPageModule, index);

      Future.delayed(const Duration(microseconds: 500), () {
        if (!firstData.isLoadMore) {
          var edge = 72;
          var offsetFromBottom = listController.position.maxScrollExtent - listController.position.pixels;
          if (offsetFromBottom < edge) {
            listController.animateTo(listController.offset - (edge - offsetFromBottom),
                duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          }
        }
        store.dispatch(LoadMoreFirstDataAction(firstPageModule: firstData, pageOffset: index + 1, isChangePerformingRequestStatus: false));
      });
    } on DioError catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = listController.position.maxScrollExtent - listController.position.pixels;
        if (offsetFromBottom < edge) {
          listController.animateTo(listController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
        store.dispatch(ChangePerformingRequestStatusAction(isChangePerformingRequestStatus: false));
      });
    } catch (e) {
      Future.delayed(const Duration(microseconds: 500), () {
        var edge = 72;
        var offsetFromBottom = listController.position.maxScrollExtent - listController.position.pixels;
        if (offsetFromBottom < edge) {
          listController.animateTo(listController.offset - (edge - offsetFromBottom),
              duration: Duration(milliseconds: 500), curve: Curves.easeOut);
        }
        store.dispatch(ChangePerformingRequestStatusAction(isChangePerformingRequestStatus: false));
      });
    }
  };
}

class UpdateCollectsDataAction extends AppHttpResponseAction {
  UpdateCollectsDataAction({
    this.collects,
  });

  Map<int, bool> collects;
}

ThunkAction<AppState> changeTheCollectStatusAction(BuildContext context, {bool collect, bool isTopArticle, int indexCount}) {
  return (Store<AppState> store) async {
    try {
      var id = 0;
      if (isTopArticle) {
        id = store.state.firstPageState.firstPageModule.topArticle.data[indexCount].id;
      } else {
        id = store.state.firstPageState.firstPageModule.articleModule.data.datas[indexCount].id;
      }
      Response response;
      if (collect) {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await store.state.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      var collects = <int, bool>{};
      collects[indexCount] = collect;
      store.dispatch(HttpAction(context: context, response: response, action: UpdateCollectsDataAction(collects: collects)));
    } on DioError catch (e) {
      store.dispatch(HttpAction(dioError: e, context: context));
    } catch (e) {
      store.dispatch(HttpAction(error: e.toString(), context: context));
    }
  };
}
