import 'package:flutterwanandroid/module/navigation/navigation_module.dart';
import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class NavigationState extends Cloneable<NavigationState> {
  DataLoadStatus dataLoadStatus;
  NavigationModule navigationModule;

  @override
  NavigationState clone() {
    return NavigationState()
      ..dataLoadStatus = dataLoadStatus
      ..navigationModule = navigationModule;
  }
}
