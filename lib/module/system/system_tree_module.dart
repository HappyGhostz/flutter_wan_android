class SystemTreeResponseModule {
  List<SystemTreeData> systemTreeData;
  int errorCode;
  String errorMsg;

  SystemTreeResponseModule({this.systemTreeData, this.errorCode, this.errorMsg});

  SystemTreeResponseModule.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      systemTreeData = <SystemTreeData>[];
      json['data'].forEach((dynamic v) {
        systemTreeData.add(SystemTreeData.fromJson(v as Map<String, dynamic>));
      });
    }
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (systemTreeData != null) {
      data['data'] = systemTreeData.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class SystemTreeData {
  List<SystemChildren> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  SystemTreeData(
      {this.children, this.courseId, this.id, this.name, this.order, this.parentChapterId, this.userControlSetTop, this.visible});

  SystemTreeData.fromJson(Map<String, dynamic> json) {
    if (json['children'] != null) {
      children = <SystemChildren>[];
      json['children'].forEach((dynamic v) {
        children.add(SystemChildren.fromJson(v as Map<String, dynamic>));
      });
    }
    courseId = json['courseId'] as int;
    id = json['id'] as int;
    name = json['name'] as String;
    order = json['order'] as int;
    parentChapterId = json['parentChapterId'] as int;
    userControlSetTop = json['userControlSetTop'] as bool;
    visible = json['visible'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (children != null) {
      data['children'] = children.map((v) => v.toJson()).toList();
    }
    data['courseId'] = courseId;
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    data['parentChapterId'] = parentChapterId;
    data['userControlSetTop'] = userControlSetTop;
    data['visible'] = visible;
    return data;
  }
}

class SystemChildren {
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  SystemChildren({this.courseId, this.id, this.name, this.order, this.parentChapterId, this.userControlSetTop, this.visible});

  SystemChildren.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'] as int;
    id = json['id'] as int;
    name = json['name'] as String;
    order = json['order'] as int;
    parentChapterId = json['parentChapterId'] as int;
    userControlSetTop = json['userControlSetTop'] as bool;
    visible = json['visible'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['courseId'] = courseId;
    data['id'] = id;
    data['name'] = name;
    data['order'] = order;
    data['parentChapterId'] = parentChapterId;
    data['userControlSetTop'] = userControlSetTop;
    data['visible'] = visible;
    return data;
  }
}
