class TodoModule {
  TodoData todoData;
  int errorCode;
  String errorMsg;

  TodoModule({this.todoData, this.errorCode, this.errorMsg});

  TodoModule.fromJson(Map<String, dynamic> json) {
    todoData = json['data'] != null ? TodoData.fromJson(json['data'] as Map<String, dynamic>) : null;
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (todoData != null) {
      data['data'] = todoData.toJson();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class TodoData {
  int curPage;
  List<Todo> todos;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  TodoData({this.curPage, this.todos, this.offset, this.over, this.pageCount, this.size, this.total});

  TodoData.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'] as int;
    if (json['datas'] != null) {
      todos = <Todo>[];
      json['datas'].forEach((dynamic v) {
        todos.add(Todo.fromJson(v as Map<String, dynamic>));
      });
    }
    offset = json['offset'] as int;
    over = json['over'] as bool;
    pageCount = json['pageCount'] as int;
    size = json['size'] as int;
    total = json['total'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['curPage'] = curPage;
    if (todos != null) {
      data['datas'] = todos.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    data['over'] = over;
    data['pageCount'] = pageCount;
    data['size'] = size;
    data['total'] = total;
    return data;
  }
}

class Todo {
  int completeDate;
  String completeDateStr;
  String content;
  int date;
  String dateStr;
  int id;
  int priority;
  int status;
  String title;
  int type;
  int userId;

  Todo(
      {this.completeDate,
      this.completeDateStr,
      this.content,
      this.date,
      this.dateStr,
      this.id,
      this.priority,
      this.status,
      this.title,
      this.type,
      this.userId});

  Todo.fromJson(Map<String, dynamic> json) {
    completeDate = json['completeDate'] as int;
    completeDateStr = json['completeDateStr'] as String;
    content = json['content'] as String;
    date = json['date'] as int;
    dateStr = json['dateStr'] as String;
    id = json['id'] as int;
    priority = json['priority'] as int;
    status = json['status'] as int;
    title = json['title'] as String;
    type = json['type'] as int;
    userId = json['userId'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['completeDate'] = completeDate;
    data['completeDateStr'] = completeDateStr;
    data['content'] = content;
    data['date'] = date;
    data['dateStr'] = dateStr;
    data['id'] = id;
    data['priority'] = priority;
    data['status'] = status;
    data['title'] = title;
    data['type'] = type;
    data['userId'] = userId;
    return data;
  }
}
