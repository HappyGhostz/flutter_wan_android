import 'package:flutter/material.dart';
import 'package:flutterwanandroid/module/system/system_tree_module.dart';
import 'package:flutterwanandroid/type/clone.dart';

class SystemState implements Cloneable<SystemState> {
  List<SystemTreeData> systemTreeDatas;
  int selectTabIndex;
  ScrollController listController;

  @override
  SystemState clone() {
    return SystemState()
      ..systemTreeDatas = systemTreeDatas
      ..selectTabIndex = selectTabIndex
      ..listController = listController;
  }
}
