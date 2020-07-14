import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/system/system_tree_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UpdateSelectTabIndexAction {
  UpdateSelectTabIndexAction({
    this.index,
  });

  int index;
}

class UpdateSystemTreeDatasAction {
  UpdateSystemTreeDatasAction({
    this.systemTreeDatas,
  });

  List<SystemTreeData> systemTreeDatas;
}

ThunkAction<AppState> getSystemTreeDataAction() {
  return (Store<AppState> store) async {
    try {
      var systemTreeResponse = await store.state.dio.get<Map<String, dynamic>>(NetPath.SYSTEM_TREE);
      var systemTreeResponseModule = SystemTreeResponseModule.fromJson(systemTreeResponse.data);
      if (systemTreeResponseModule.errorCode == 0) {
        store.dispatch(UpdateSystemTreeDatasAction(systemTreeDatas: systemTreeResponseModule.systemTreeData));
      } else {
        store.dispatch(UpdateSystemTreeDatasAction(systemTreeDatas: null));
      }
    } catch (e) {
      store.dispatch(UpdateSystemTreeDatasAction(systemTreeDatas: null));
    }
  };
}
