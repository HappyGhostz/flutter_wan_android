class IntegralRankListResponseModule {
  IntegralRankListData integralRankListData;
  int errorCode;
  String errorMsg;

  IntegralRankListResponseModule({this.integralRankListData, this.errorCode, this.errorMsg});

  IntegralRankListResponseModule.fromJson(Map<String, dynamic> json) {
    integralRankListData = json['data'] != null ? IntegralRankListData.fromJson(json['data'] as Map<String, dynamic>) : null;
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (integralRankListData != null) {
      data['data'] = integralRankListData.toJson();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class IntegralRankListData {
  int curPage;
  List<IntegralRank> integralRanks;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  IntegralRankListData({this.curPage, this.integralRanks, this.offset, this.over, this.pageCount, this.size, this.total});

  IntegralRankListData.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'] as int;
    if (json['datas'] != null) {
      integralRanks = <IntegralRank>[];
      json['datas'].forEach((dynamic v) {
        integralRanks.add(IntegralRank.fromJson(v as Map<String, dynamic>));
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
    if (integralRanks != null) {
      data['datas'] = integralRanks.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    data['over'] = over;
    data['pageCount'] = pageCount;
    data['size'] = size;
    data['total'] = total;
    return data;
  }
}

class IntegralRank {
  int coinCount;
  int level;
  String rank;
  int userId;
  String username;

  IntegralRank({this.coinCount, this.level, this.rank, this.userId, this.username});

  IntegralRank.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'] as int;
    level = json['level'] as int;
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
