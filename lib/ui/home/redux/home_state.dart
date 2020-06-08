import 'package:flutterwanandroid/type/clone.dart';

class HomeState implements Cloneable<HomeState> {
  int currentIndex;

  @override
  HomeState clone() {
    return HomeState()..currentIndex;
  }
}
