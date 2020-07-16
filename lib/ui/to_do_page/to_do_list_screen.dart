import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_custom_widget.dart';
import 'package:flutterwanandroid/module/to_do_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

List<IconData> images = [Icons.wb_sunny, Icons.brightness_3];

class TodoListScreen extends StatefulWidget {
  TodoListScreen({
    Key key,
    @required this.dio,
    @required this.tabData,
    @required this.status,
    @required this.type,
    @required this.num,
    @required this.title,
  }) : super(key: key);
  final Dio dio;
  final String tabData;
  final String title;
  final int status;
  final int type;
  final int num;

  @override
  State<StatefulWidget> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  DataLoadStatus currentStatus;
  List<Todo> todos = <Todo>[];
  ScrollController scrollController;
  TodoData todoData;
  bool isPerformingRequest;
  int pageOffset;

  @override
  void initState() {
    pageOffset = 1;
    isPerformingRequest = false;
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isPerformingRequest) {
          loadMore();
        }
      }
    });
    initData();
    super.initState();
  }

  void initData() {
    currentStatus = DataLoadStatus.loading;
    _getTodoListData();
  }

  void refresh() {
    currentStatus = DataLoadStatus.loading;
    setState(() {});
    _getTodoListData();
  }

  void _getTodoListData() async {
    try {
      var params = <String, dynamic>{
        'type': widget.type,
        'status': widget.status,
      };
      var toDoResponse = await widget.dio.get<Map<String, dynamic>>(NetPath.getTodoLists(1), queryParameters: params);
      var todoModule = TodoModule.fromJson(toDoResponse.data);
      if (todoModule.errorCode == -1001) {
        RouterUtil.pushReplacementNamed(context, AppRouter.loginRouterName);
      } else if (todoModule.errorCode < 0) {
        setState(() {
          currentStatus = DataLoadStatus.failure;
        });
      } else {
        if (todoModule == null || todoModule.todoData == null || todoModule.todoData.todos == null || todoModule.todoData.todos.isEmpty) {
          setState(() {
            currentStatus = DataLoadStatus.empty;
          });
        } else {
          var todoList = todoModule.todoData.todos;
          var todo = todoModule.todoData;
          setState(() {
            currentStatus = DataLoadStatus.loadCompleted;
            todos = todoList;
            todoData = todo;
            pageOffset = 2;
          });
        }
      }
    } catch (e) {
      setState(() {
        currentStatus = DataLoadStatus.failure;
      });
    }
  }

  void loadMore() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      try {
        var params = <String, dynamic>{
          'type': widget.type,
          'status': widget.status,
        };
        var toDoResponse = await widget.dio.get<Map<String, dynamic>>(NetPath.getTodoLists(pageOffset), queryParameters: params);
        var todoModule = TodoModule.fromJson(toDoResponse.data);

        Future.delayed(const Duration(microseconds: 500), () {
          if (todoModule == null || todoModule.todoData == null || todoModule.todoData.todos == null || todoModule.todoData.todos.isEmpty) {
            var edge = 72;
            var offsetFromBottom =
                // ignore: invalid_use_of_protected_member
                scrollController.position.maxScrollExtent -
                    // ignore: invalid_use_of_protected_member
                    scrollController.position.pixels;
            if (offsetFromBottom < edge) {
              scrollController.animateTo(scrollController.offset - (edge - offsetFromBottom),
                  duration: Duration(milliseconds: 500), curve: Curves.easeOut);
            }
            isPerformingRequest = false;
            setState(() {});
          } else {
            var todoList = todoModule.todoData.todos;
            var todo = todoModule.todoData;
            todos.addAll(todoList);
            todoData = todo;
            pageOffset++;
            isPerformingRequest = false;
            setState(() {});
          }
        });
      } on DioError catch (e) {
        print('publicAccountPageService::loadMore:${e.toString()}');
        _updateErrorInfo();
      } catch (e) {
        print('publicAccountPageService::loadMore:${e.toString()}');
        _updateErrorInfo();
      }
    }
  }

  void _updateErrorInfo() {
    Future.delayed(const Duration(microseconds: 500), () {
      var edge = 72;
      // ignore: invalid_use_of_protected_member
      var offsetFromBottom = scrollController.position.maxScrollExtent -
          // ignore: invalid_use_of_protected_member
          scrollController.position.pixels;
      if (offsetFromBottom < edge) {
        scrollController.animateTo(scrollController.offset - (edge - offsetFromBottom),
            duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      }
      setState(() {
        isPerformingRequest = false;
      });
    });
  }

  @override
  void didUpdateWidget(TodoListScreen oldWidget) {
    if (oldWidget.type != widget.type || oldWidget.num != widget.num) {
      initData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageLoadWidget(
      dataLoadStatus: currentStatus,
      child: _buildDataWidget(context),
      tapGestureRecognizer: refresh,
    );
  }

  Widget _buildDataWidget(BuildContext context) {
    return RefreshIndicator(
        child: Timeline.builder(
            itemCount: _buildItemCount(),
            controller: scrollController,
            lineColor: Theme.of(context).primaryColor,
            position: TimelinePosition.Left,
            itemBuilder: (context, index) {
              if (index == todos.length) {
                return _buildLoadMore();
              }
              var todo = todos[index];
              return TimelineModel(_buildItemChild(todo, context),
                  position: TimelineItemPosition.random,
//                  iconBackground: Theme.of(context).primaryColor,
                  iconBackground: Colors.amber,
                  icon: Icon(
                    getIconData(),
                    color: AppColors.white,
                  ));
            }),
        onRefresh: () async {
          refresh();
          return Future.value(true);
        });
  }

  int _buildItemCount() {
    return todos.length + 1;
  }

  TimelineModel _buildLoadMore() {
    return TimelineModel(
        Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: LoadMorePage(),
        ),
        position: TimelineItemPosition.random,
        iconBackground: Colors.amber,
        icon: Icon(
          getIconData(),
          color: AppColors.white,
        ));
  }

  Widget _buildItemChild(Todo todo, BuildContext context) {
    return Card(
      elevation: 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                child: Text(
                  todo.title ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.head(color: AppColors.black, fontSize: 24),
                ),
                padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24, top: 8, right: 8, bottom: 8),
                child: Text(
                  todo.content ?? '',
                  style: AppTextStyle.caption(color: AppColors.lightGrey1),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
                child: Text(
                  '时间:${todo.dateStr}',
                  style: AppTextStyle.caption(color: AppColors.lightGrey1),
                ),
              ),
            ],
          )),
          Column(
            children: <Widget>[
              widget.status == 0
                  ? IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _changeStatusForTodoItem(todo.id, todo.status, context);
                      })
                  : IconButton(
                      icon: Icon(
                        Icons.call_missed,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        _changeStatusForTodoItem(todo.id, todo.status, context);
                      }),
              IconButton(
                  icon: Icon(
                    Icons.create,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _editTodoItem(context, todo.title, todo.content, todo.dateStr, todo.id);
                  }),
              IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _deletedTodoItem(context, todo.id);
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Future _editTodoItem(BuildContext context, String title, String content, String dateStr, int id) async {
    var params = await showEditDialog(context, title: 'TODO-${widget.title}', editItemTitle: title, content: content, dateTime: dateStr);
    if (params.isEmpty) {
      return;
    }
    // ignore: unawaited_futures
    showLoadingDialog<void>(context);
    var formData = FormData.fromMap(<String, dynamic>{
      'title': params[editTitleKey],
      'content': params[editContentKey],
      'date': params[editTimeKey],
      'status': widget.status,
    });
    try {
      var updateResponse = await widget.dio.post<Map<String, dynamic>>(NetPath.updateTodoItem(id), data: formData);
      dismissDialog<void>(context);
      var errorCode = updateResponse.data['errorCode'] as int;
      var errorMsg = updateResponse.data['errorMsg'] as String;
      if (errorCode == 0) {
        refresh();
      } else {
        showExceptionInfo(context, errorMsg);
      }
    } catch (e) {
      dismissDialog<void>(context);
      showExceptionInfo(context, e.toString());
    }
  }

  IconData getIconData() {
    var nextInt = Random().nextInt(images.length);
    return images[nextInt];
  }

  void _changeStatusForTodoItem(int id, int status, BuildContext context) async {
    // ignore: unawaited_futures
    showLoadingDialog<void>(context);
    var statusNew = 0;

    if (status == 0) {
      statusNew = 1;
    }
    var data = FormData.fromMap(<String, dynamic>{
      'status': statusNew,
    });
    try {
      var changeStatusResponse = await widget.dio.post<Map<String, dynamic>>(NetPath.changeStatusForTodo(id), data: data);
      dismissDialog<void>(context);
      var errorCode = changeStatusResponse.data['errorCode'] as int;
      var errorMsg = changeStatusResponse.data['errorMsg'] as String;
      if (errorCode == 0) {
        refresh();
      } else {
        showExceptionInfo(context, errorMsg);
      }
    } catch (e) {
      dismissDialog<void>(context);
      showExceptionInfo(context, e.toString());
    }
  }

  void _deletedTodoItem(BuildContext context, int id) async {
    // ignore: unawaited_futures
    showLoadingDialog<void>(context);
    try {
      var changeStatusResponse = await widget.dio.post<Map<String, dynamic>>(NetPath.deletedTodoItem(id));
      dismissDialog<void>(context);
      var errorCode = changeStatusResponse.data['errorCode'] as int;
      var errorMsg = changeStatusResponse.data['errorMsg'] as String;
      if (errorCode == 0) {
        refresh();
      } else {
        showExceptionInfo(context, errorMsg);
      }
    } catch (e) {
      dismissDialog<void>(context);
      showExceptionInfo(context, e.toString());
    }
  }
}
