class WebCollectModule {
  List<WebCollectData> webCollectDatas;
  int errorCode;
  String errorMsg;

  WebCollectModule({this.webCollectDatas, this.errorCode, this.errorMsg});

  WebCollectModule.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      webCollectDatas = <WebCollectData>[];
      json['data'].forEach((dynamic v) {
        webCollectDatas.add(WebCollectData.fromJson(v as Map<String, dynamic>));
      });
    }
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (webCollectDatas != null) {
      data['data'] = webCollectDatas.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class WebCollectData {
  String desc;
  String icon;
  int id;
  String link;
  String name;
  int order;
  int userId;
  int visible;

  WebCollectData({this.desc, this.icon, this.id, this.link, this.name, this.order, this.userId, this.visible});

  WebCollectData.fromJson(Map<String, dynamic> json) {
    desc = json['desc'] as String;
    icon = json['icon'] as String;
    id = json['id'] as int;
    link = json['link'] as String;
    name = json['name'] as String;
    order = json['order'] as int;
    userId = json['userId'] as int;
    visible = json['visible'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['desc'] = desc;
    data['icon'] = icon;
    data['id'] = id;
    data['link'] = link;
    data['name'] = name;
    data['order'] = order;
    data['userId'] = userId;
    data['visible'] = visible;
    return data;
  }
}
