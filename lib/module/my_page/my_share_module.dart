import 'package:flutterwanandroid/module/first_page/article.dart';

class MyShareModule {
  ShareData shareData;
  int errorCode;
  String errorMsg;

  MyShareModule({this.shareData, this.errorCode, this.errorMsg});

  MyShareModule.fromJson(Map<String, dynamic> json) {
    shareData = json['data'] != null ? ShareData.fromJson(json['data'] as Map<String, dynamic>) : null;
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (shareData != null) {
      data['data'] = shareData.toJson();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class ShareData {
  CoinInfo coinInfo;
  ShareArticles shareArticles;

  ShareData({this.coinInfo, this.shareArticles});

  ShareData.fromJson(Map<String, dynamic> json) {
    coinInfo = json['coinInfo'] != null ? CoinInfo.fromJson(json['coinInfo'] as Map<String, dynamic>) : null;
    shareArticles = json['shareArticles'] != null ? ShareArticles.fromJson(json['shareArticles'] as Map<String, dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (coinInfo != null) {
      data['coinInfo'] = coinInfo.toJson();
    }
    if (shareArticles != null) {
      data['shareArticles'] = shareArticles.toJson();
    }
    return data;
  }
}

class CoinInfo {
  int coinCount;
  int level;
  String rank;
  int userId;
  String username;

  CoinInfo({this.coinCount, this.level, this.rank, this.userId, this.username});

  CoinInfo.fromJson(Map<String, dynamic> json) {
    coinCount = json['coinCount'] as int ?? 0;
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

class ShareArticles {
  int curPage;
  List<ShareArticleData> shareArticleDatas;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  ShareArticles({this.curPage, this.shareArticleDatas, this.offset, this.over, this.pageCount, this.size, this.total});

  ShareArticles.fromJson(Map<String, dynamic> json) {
    curPage = json['curPage'] as int;
    if (json['datas'] != null) {
      shareArticleDatas = <ShareArticleData>[];
      json['datas'].forEach((dynamic v) {
        shareArticleDatas.add(ShareArticleData.fromJson(v as Map<String, dynamic>));
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
    if (shareArticleDatas != null) {
      data['datas'] = shareArticleDatas.map((v) => v.toJson()).toList();
    }
    data['offset'] = offset;
    data['over'] = over;
    data['pageCount'] = pageCount;
    data['size'] = size;
    data['total'] = total;
    return data;
  }
}

class ShareArticleData {
  String apkLink;
  int audit;
  String author;
  bool canEdit;
  int chapterId;
  String chapterName;
  bool collect;
  int courseId;
  String desc;
  String descMd;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String niceShareDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  int selfVisible;
  int shareDate;
  String shareUser;
  int superChapterId;
  String superChapterName;
  List<Tags> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;

  ShareArticleData(
      {this.apkLink,
      this.audit,
      this.author,
      this.canEdit,
      this.chapterId,
      this.chapterName,
      this.collect,
      this.courseId,
      this.desc,
      this.descMd,
      this.envelopePic,
      this.fresh,
      this.id,
      this.link,
      this.niceDate,
      this.niceShareDate,
      this.origin,
      this.prefix,
      this.projectLink,
      this.publishTime,
      this.selfVisible,
      this.shareDate,
      this.shareUser,
      this.superChapterId,
      this.superChapterName,
      this.tags,
      this.title,
      this.type,
      this.userId,
      this.visible,
      this.zan});

  ShareArticleData.fromJson(Map<String, dynamic> json) {
    apkLink = json['apkLink'] as String;
    audit = json['audit'] as int;
    author = json['author'] as String;
    canEdit = json['canEdit'] as bool;
    chapterId = json['chapterId'] as int;
    chapterName = json['chapterName'] as String;
    collect = json['collect'] as bool;
    courseId = json['courseId'] as int;
    desc = json['desc'] as String;
    descMd = json['descMd'] as String;
    envelopePic = json['envelopePic'] as String;
    fresh = json['fresh'] as bool;
    id = json['id'] as int;
    link = json['link'] as String;
    niceDate = json['niceDate'] as String;
    niceShareDate = json['niceShareDate'] as String;
    origin = json['origin'] as String;
    prefix = json['prefix'] as String;
    projectLink = json['projectLink'] as String;
    publishTime = json['publishTime'] as int;
    selfVisible = json['selfVisible'] as int;
    shareDate = json['shareDate'] as int;
    shareUser = json['shareUser'] as String;
    superChapterId = json['superChapterId'] as int;
    superChapterName = json['superChapterName'] as String;
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((dynamic v) {
        tags.add(Tags.fromJson(v as Map<String, dynamic>));
      });
    }
    title = json['title'] as String;
    type = json['type'] as int;
    userId = json['userId'] as int;
    visible = json['visible'] as int;
    zan = json['zan'] as int;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['apkLink'] = apkLink;
    data['audit'] = audit;
    data['author'] = author;
    data['canEdit'] = canEdit;
    data['chapterId'] = chapterId;
    data['chapterName'] = chapterName;
    data['collect'] = collect;
    data['courseId'] = courseId;
    data['desc'] = desc;
    data['descMd'] = descMd;
    data['envelopePic'] = envelopePic;
    data['fresh'] = fresh;
    data['id'] = id;
    data['link'] = link;
    data['niceDate'] = niceDate;
    data['niceShareDate'] = niceShareDate;
    data['origin'] = origin;
    data['prefix'] = prefix;
    data['projectLink'] = projectLink;
    data['publishTime'] = publishTime;
    data['selfVisible'] = selfVisible;
    data['shareDate'] = shareDate;
    data['shareUser'] = shareUser;
    data['superChapterId'] = superChapterId;
    data['superChapterName'] = superChapterName;
    if (tags != null) {
      data['tags'] = tags.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    data['type'] = type;
    data['userId'] = userId;
    data['visible'] = visible;
    data['zan'] = zan;
    return data;
  }
}
