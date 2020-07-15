class IntegralPrivateListResponseModule {
  IntegralPrivateListData integralPrivateListData;
  int errorCode;
  String errorMsg;

  IntegralPrivateListResponseModule({this.integralPrivateListData, this.errorCode, this.errorMsg});

  IntegralPrivateListResponseModule.fromJson(Map<String, dynamic> json) {
    integralPrivateListData = json['data'] != null ? IntegralPrivateListData.fromJson(json['data'] as Map<String, dynamic>) : null;
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (integralPrivateListData != null) {
      data['data'] = integralPrivateListData.toJson();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class IntegralPrivateListData {
  int curPage;
  List<IntegralPrivate> integralPrivates;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  IntegralPrivateListData({this.curPage, this.integralPrivates, this.offset, this.over, this.pageCount, this.size, this.total});

  IntegralPrivateListData.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'] as int;
    if (json['datas'] != null) {
      integralPrivates = <IntegralPrivate>[];
      json['datas'].forEach((dynamic v) {
        integralPrivates.add(IntegralPrivate.fromJson(v as Map<String, dynamic>));
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
    if (integralPrivates != null) {
      data['datas'] = integralPrivates.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    data['over'] = over;
    data['pageCount'] = pageCount;
    data['size'] = size;
    data['total'] = total;
    return data;
  }
}

class IntegralPrivate {
  int coinCount;
  int date;
  String desc;
  int id;
  String reason;
  int type;
  int userId;
  String userName;

  IntegralPrivate({this.coinCount, this.date, this.desc, this.id, this.reason, this.type, this.userId, this.userName});

  IntegralPrivate.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'] as int;
    date = json['date'] as int;
    desc = json['desc'] as String;
    id = json['id'] as int;
    reason = json['reason'] as String;
    type = json['type'] as int;
    userId = json['userId'] as int;
    userName = json['userName'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['coinCount'] = coinCount;
    data['date'] = date;
    data['desc'] = desc;
    data['id'] = id;
    data['reason'] = reason;
    data['type'] = type;
    data['userId'] = userId;
    data['userName'] = userName;
    return data;
  }
}
