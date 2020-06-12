class IntegralModule {
  IntegralData integralData;
  int errorCode;
  String errorMsg;

  IntegralModule({this.integralData, this.errorCode, this.errorMsg});

  IntegralModule.fromJson(Map<String, dynamic> json) {
    integralData = json['data'] != null ? IntegralData.fromJson(json['data'] as Map<String, dynamic>) : null;
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (integralData != null) {
      data['data'] = integralData.toJson();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class IntegralData {
  int coinCount;
  int level;
  String rank;
  int userId;
  String username;

  IntegralData({this.coinCount, this.level, this.rank, this.userId, this.username});

  IntegralData.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'] != null ? json['coinCount'] as int : 0;
    level = json['level'] != null ? json['level'] as int : 0;
    rank = json['rank'] as String;
    userId = json['userId'] as int;
    username = json['username'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['coinCount'] = coinCount;
    data['level'] = level;
    data['rank'] = rank;
    data['userId'] = userId;
    data['username'] = username;
    return data;
  }
}
