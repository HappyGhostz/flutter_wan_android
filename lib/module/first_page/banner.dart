class Banner {
  List<BannerData> bannerData;
  int errorCode;
  String errorMsg;

  Banner({this.bannerData, this.errorCode, this.errorMsg});

  Banner.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      bannerData = <BannerData>[];
      json['data'].forEach((dynamic value) {
        bannerData.add(BannerData.fromJson(value as Map<String, dynamic>));
      });
    }
    errorCode = json['errorCode'] as int;
    errorMsg = json['errorMsg'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    if (bannerData != null) {
      data['data'] = bannerData.map((v) => v.toJson()).toList();
    }
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    return data;
  }
}

class BannerData {
  String desc;
  int id;
  String imagePath;
  int isVisible;
  int order;
  String title;
  int type;
  String url;

  BannerData({this.desc, this.id, this.imagePath, this.isVisible, this.order, this.title, this.type, this.url});

  BannerData.fromJson(Map<String, dynamic> json) {
    desc = json['desc'] as String;
    id = json['id'] as int;
    imagePath = json['imagePath'] as String;
    isVisible = json['isVisible'] as int;
    order = json['order'] as int;
    title = json['title'] as String;
    type = json['type'] as int;
    url = json['url'] as String;
  }

  Map<String, dynamic> toJson() {
    var data = <String, dynamic>{};
    data['desc'] = desc;
    data['id'] = id;
    data['imagePath'] = imagePath;
    data['isVisible'] = isVisible;
    data['order'] = order;
    data['title'] = title;
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}
