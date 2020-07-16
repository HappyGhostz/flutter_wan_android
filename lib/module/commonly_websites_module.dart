class CommonlyUsedWebSitesResponseModule {
  List<CommonlyUsedWebSitesData> commonlyUsedWebSitesDatas;
  int errorCode;
  String errorMsg;

  CommonlyUsedWebSitesResponseModule({this.commonlyUsedWebSitesDatas, this.errorCode, this.errorMsg});

  CommonlyUsedWebSitesResponseModule.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      commonlyUsedWebSitesDatas = <CommonlyUsedWebSitesData>[];
      json['data'].forEach((dynamic v) {
        commonlyUsedWebSitesDatas.add(CommonlyUsedWebSitesData.fromJson(v as Map<String, dynamic>));
      });
    }
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (commonlyUsedWebSitesDatas != null) {
      data['data'] = commonlyUsedWebSitesDatas.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class CommonlyUsedWebSitesData {
  String icon;
  int id;
  String link;
  String name;
  int order;
  int visible;

  CommonlyUsedWebSitesData({this.icon, this.id, this.link, this.name, this.order, this.visible});

  CommonlyUsedWebSitesData.fromJson(Map<String, dynamic> json) {
    icon = json['icon'] as String;
    id = json['id'] as int;
    link = json['link'] as String;
    name = json['name'] as String;
    order = json['order'] as int;
    visible = json['visible'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['icon'] = icon;
    data['id'] = id;
    data['link'] = link;
    data['name'] = name;
    data['order'] = order;
    data['visible'] = visible;
    return data;
  }
}
