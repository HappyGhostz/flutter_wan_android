import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

enum TodoMenuOptions {
  todoDefault,
  todoWork,
  todoStudy,
  todoLife,
}

typedef MenuItemSelectCallBack = Function(TodoMenuOptions todoMenuOptions);

class TodoMenu extends StatelessWidget {
  TodoMenu(this.itemSelectCallBack, this.currentOption);

  final MenuItemSelectCallBack itemSelectCallBack;
  final TodoMenuOptions currentOption;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TodoMenuOptions>(
      offset: Offset(0, 56),
      onSelected: (TodoMenuOptions value) {
        switch (value) {
          case TodoMenuOptions.todoDefault:
            itemSelectCallBack(TodoMenuOptions.todoDefault);
            break;
          case TodoMenuOptions.todoWork:
            itemSelectCallBack(TodoMenuOptions.todoWork);
            break;
          case TodoMenuOptions.todoStudy:
            itemSelectCallBack(TodoMenuOptions.todoStudy);
            break;
          case TodoMenuOptions.todoLife:
            itemSelectCallBack(TodoMenuOptions.todoLife);
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<TodoMenuOptions>>[
        PopupMenuItem<TodoMenuOptions>(
          value: TodoMenuOptions.todoDefault,
          child: _buildMenuItemWidget(context, Icons.perm_device_information, '默认', currentOption == TodoMenuOptions.todoDefault),
        ),
        PopupMenuItem<TodoMenuOptions>(
          value: TodoMenuOptions.todoWork,
          child: _buildMenuItemWidget(context, Icons.work, '工作', currentOption == TodoMenuOptions.todoWork),
        ),
        PopupMenuItem<TodoMenuOptions>(
          value: TodoMenuOptions.todoStudy,
          child: _buildMenuItemWidget(context, Icons.note_add, '学习', currentOption == TodoMenuOptions.todoStudy),
        ),
        PopupMenuItem<TodoMenuOptions>(
          value: TodoMenuOptions.todoLife,
          child: _buildMenuItemWidget(context, Icons.store, '生活', currentOption == TodoMenuOptions.todoLife),
        ),
      ],
    );
  }

  Widget _buildMenuItemWidget(BuildContext context, IconData icon, String title, bool isCurrent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          title,
          style: TextStyle(color: isCurrent ? Theme.of(context).primaryColor : AppColors.black),
        ),
      ],
    );
  }
}
