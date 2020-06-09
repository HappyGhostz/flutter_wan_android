import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/module/public_account/tab_bar_module.dart';
import 'package:flutterwanandroid/ui/public_account/redux/public_account_action.dart';
import 'package:redux/redux.dart';

class PublicAccountViewModule {
  PublicAccountViewModule({
    this.publicAccountTabBarModule,
  });

  PublicAccountTabBarModule publicAccountTabBarModule;
  Function(BuildContext context) refreshChapterData;

  static PublicAccountViewModule fromStore(Store<AppState> store) {
    var state = store.state.publicAccountPageState;
    return PublicAccountViewModule()
      ..publicAccountTabBarModule = state.publicAccountTabBarModule
      ..refreshChapterData = (context) {
        store.dispatch(initTabBarData(context));
      };
  }
}
