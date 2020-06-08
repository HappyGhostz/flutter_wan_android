import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/first_page/fist_page_module.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:redux/redux.dart';

class FirstPageViewModule {
  FirstPageViewModule({
    this.firstPageStatus,
    this.refreshFirstPageData,
    this.isPerformingRequest,
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

  static FirstPageViewModule fromStore(Store<AppState> store) {
    var firstState = store.state.firstPageState;
    return FirstPageViewModule()
      ..firstPageStatus = firstState.firstPageStatus
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
      };
  }
}
