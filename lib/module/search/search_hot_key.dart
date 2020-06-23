class SearchHotKeyResponseModule {
  List<SearchHotKey> hotKey;
  int errorCode;
  String errorMsg;

  SearchHotKeyResponseModule({this.hotKey, this.errorCode, this.errorMsg});

  SearchHotKeyResponseModule.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      hotKey = <SearchHotKey>[];
      json['data'].forEach((dynamic v) {
        hotKey.add(SearchHotKey.fromJson(v as Map<String, dynamic>));
      });
    }
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (hotKey != null) {
      data['data'] = hotKey.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class SearchHotKey {
  int id;
  String link;
  String name;
  int order;
  int visible;

  SearchHotKey({this.id, this.link, this.name, this.order, this.visible});

  SearchHotKey.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    link = json['link'] as String;
    name = json['name'] as String;
    order = json['order'] as int;
    visible = json['visible'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['id'] = id;
    data['link'] = link;
    data['name'] = name;
    data['order'] = order;
    data['visible'] = visible;
    return data;
  }
}
