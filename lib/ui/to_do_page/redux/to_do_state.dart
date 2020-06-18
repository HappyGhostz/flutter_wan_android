import 'package:flutterwanandroid/type/clone.dart';
import 'package:flutterwanandroid/ui/to_do_page/to_do_menu_widget.dart';

class TodoState extends Cloneable<TodoState> {
  TodoMenuOptions currentOptions;
  String currentOptionTitle;
  int currentOptionType;
  int addNum;

  @override
  TodoState clone() {
    return TodoState()
      ..currentOptions = currentOptions
      ..addNum = addNum
      ..currentOptionTitle = currentOptionTitle
      ..currentOptionType = currentOptionType;
  }
}
