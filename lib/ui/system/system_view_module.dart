import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/system/system_tree_module.dart';
import 'package:flutterwanandroid/ui/system/reducer/system_action.dart';
import 'package:redux/redux.dart';

// ignore: must_be_immutable
class SystemViewModule implements Equatable {
  SystemViewModule({
    this.systemTreeDatas,
  });

  List<SystemTreeData> systemTreeDatas;
  Function refreshData;
  int selectTabIndex;
  Function(int index) selectIndex;
  ScrollController listController;

  static SystemViewModule fromStore(Store<AppState> store) {
    var state = store.state.systemState;
    return SystemViewModule()
      ..systemTreeDatas = state.systemTreeDatas
      ..selectTabIndex = state.selectTabIndex ?? 0
      ..listController = state.listController
      ..refreshData = () {
        store.dispatch(UpdateSystemTreeDatasAction(systemTreeDatas: null));
        store.dispatch(getSystemTreeDataAction());
      }
      ..selectIndex = (index) {
        store.dispatch(UpdateSelectTabIndexAction(index: index));
      };
  }

  @override
  List<Object> get props => [systemTreeDatas];

  @override
  bool get stringify => true;
}
