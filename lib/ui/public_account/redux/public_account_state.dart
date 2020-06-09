import 'package:flutterwanandroid/module/public_account/tab_bar_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/ui/public_account/services/public_account_services.dart';

class PublicAccountState extends Cloneable<PublicAccountState> {
  PublicAccountPageService publicAccountPageService;
  PublicAccountTabBarModule publicAccountTabBarModule;

  @override
  PublicAccountState clone() {
    return PublicAccountState()
      ..publicAccountPageService = publicAccountPageService
      ..publicAccountTabBarModule = publicAccountTabBarModule;
  }
}
