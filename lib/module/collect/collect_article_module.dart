class CollectArticleResponseModule {
  CollectArticleListData collectArticleListData;
  int errorCode;
  String errorMsg;

  CollectArticleResponseModule({this.collectArticleListData, this.errorCode, this.errorMsg});

  CollectArticleResponseModule.fromJson(Map<String, dynamic> json) {
    collectArticleListData = json['data'] != null ? CollectArticleListData.fromJson(json['data'] as Map<String, dynamic>) : null;
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (collectArticleListData != null) {
      data['data'] = collectArticleListData.toJson();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class CollectArticleListData {
  int curPage;
  List<CollectArticle> collectArticles;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  CollectArticleListData({this.curPage, this.collectArticles, this.offset, this.over, this.pageCount, this.size, this.total});

  CollectArticleListData.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'] as int;
    if (json['datas'] != null) {
      collectArticles = <CollectArticle>[];
      json['datas'].forEach((dynamic v) {
        collectArticles.add(CollectArticle.fromJson(v as Map<String, dynamic>));
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
    if (collectArticles != null) {
      data['datas'] = collectArticles.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    data['over'] = over;
    data['pageCount'] = pageCount;
    data['size'] = size;
    data['total'] = total;
    return data;
  }
}

class CollectArticle {
  String author;
  int chapterId;
  String chapterName;
  int courseId;
  String desc;
  String envelopePic;
  int id;
  String link;
  String niceDate;
  String origin;
  int originId;
  int publishTime;
  String title;
  int userId;
  int visible;
  int zan;

  CollectArticle(
      {this.author,
      this.chapterId,
      this.chapterName,
      this.courseId,
      this.desc,
      this.envelopePic,
      this.id,
      this.link,
      this.niceDate,
      this.origin,
      this.originId,
      this.publishTime,
      this.title,
      this.userId,
      this.visible,
      this.zan});

  CollectArticle.fromJson(Map<String, dynamic> json) {
    author = json['author'] as String;
    chapterId = json['chapterId'] as int;
    chapterName = json['chapterName'] as String;
    courseId = json['courseId'] as int;
    desc = json['desc'] as String;
    envelopePic = json['envelopePic'] as String;
    id = json['id'] as int;
    link = json['link'] as String;
    niceDate = json['niceDate'] as String;
    origin = json['origin'] as String;
    originId = json['originId'] as int;
    publishTime = json['publishTime'] as int;
    title = json['title'] as String;
    userId = json['userId'] as int;
    visible = json['visible'] as int;
    zan = json['zan'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['author'] = author;
    data['chapterId'] = chapterId;
    data['chapterName'] = chapterName;
    data['courseId'] = courseId;
    data['desc'] = desc;
    data['envelopePic'] = envelopePic;
    data['id'] = id;
    data['link'] = link;
    data['niceDate'] = niceDate;
    data['origin'] = origin;
    data['originId'] = originId;
    data['publishTime'] = publishTime;
    data['title'] = title;
    data['userId'] = userId;
    data['visible'] = visible;
    data['zan'] = zan;
    return data;
  }
}
