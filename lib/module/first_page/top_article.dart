import 'package:flutterwanandroid/module/first_page/article.dart';

class TopArticle {
  List<Data> data;
  int errorCode;
  String errorMsg;

  TopArticle({this.data, this.errorCode, this.errorMsg});

  TopArticle.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((dynamic v) {
        data.add(Data.fromJson(v as Map<String, dynamic>));
      });
    }
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
