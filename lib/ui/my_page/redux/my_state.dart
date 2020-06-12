import 'package:flutterwanandroid/module/my_page/article_collect_module.dart';
import 'package:flutterwanandroid/module/my_page/my_integral_module.dart';
import 'package:flutterwanandroid/module/my_page/my_share_module.dart';
import 'package:flutterwanandroid/module/my_page/web_collect_module.dart';
import 'package:flutterwanandroid/type/clone.dart';

class MyState extends Cloneable<MyState> {
  bool isRefresh;
  bool isLogin;
  String name;
  IntegralModule integralModule;
  WebCollectModule webCollectModule;
  ArticleCollectModule articleCollectModule;
  MyShareModule myShareModule;

  @override
  MyState clone() {
    return MyState()
      ..isRefresh = isRefresh
      ..isLogin = isLogin
      ..name = name
      ..integralModule = integralModule
      ..articleCollectModule = articleCollectModule
      ..webCollectModule = webCollectModule
      ..myShareModule = myShareModule;
  }
}
