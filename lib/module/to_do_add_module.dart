class TodoAddResponseModule {
  TodoAdd todoAdd;
  int errorCode;
  String errorMsg;

  TodoAddResponseModule({this.todoAdd, this.errorCode, this.errorMsg});

  TodoAddResponseModule.fromJson(Map<String, dynamic> json) {
    todoAdd = json['data'] != null ? TodoAdd.fromJson(json['data'] as Map<String, dynamic>) : null;
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (todoAdd != null) {
      data['data'] = todoAdd.toJson();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class TodoAdd {
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

  TodoAdd(
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

  TodoAdd.fromJson(Map<String, dynamic> json) {
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
