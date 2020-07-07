class ProjectTabResponseModule {
  List<ProjectTabData> projectTabData;
  int errorCode;
  String errorMsg;

  ProjectTabResponseModule({this.projectTabData, this.errorCode, this.errorMsg});

  ProjectTabResponseModule.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      projectTabData = <ProjectTabData>[];
      json['data'].forEach((dynamic v) {
        projectTabData.add(ProjectTabData.fromJson(v as Map<String, dynamic>));
      });
    }
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (projectTabData != null) {
      data['data'] = projectTabData.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class ProjectTabData {
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  ProjectTabData({this.courseId, this.id, this.name, this.order, this.parentChapterId, this.userControlSetTop, this.visible});

  ProjectTabData.fromJson(Map<String, dynamic> json) {
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
