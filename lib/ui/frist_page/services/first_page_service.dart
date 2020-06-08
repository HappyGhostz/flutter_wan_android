import 'package:dio/dio.dart';
import 'package:flutterwanandroid/module/first_page/article.dart';
import 'package:flutterwanandroid/module/first_page/banner.dart';
import 'package:flutterwanandroid/module/first_page/fist_page_module.dart';
import 'package:flutterwanandroid/module/first_page/top_article.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';

class FirstPageService {
  FirstPageService({this.dio});

  Dio dio;

  Future<FirstPageModule> getFirstPageData(int index) async {
    var response = await Future.wait([
      dio.get<Map<String, dynamic>>(NetPath.BANNER),
      dio.get<Map<String, dynamic>>(NetPath.TOP_ARTICLE),
      dio.get<Map<String, dynamic>>(NetPath.getFirstArticle(index)),
    ]);
    var errorCode = 0;
    var errorMessage = '';
    if (response != null) {
      var bannerData = response[0].data;
      var banner = Banner.fromJson(bannerData);
      var topArticle = TopArticle.fromJson(response[1].data);
      var article = ArticleModule.fromJson(response[2].data);
      if (banner.errorCode < 0) {
        errorCode = banner.errorCode;
        errorMessage = banner.errorMsg;
      } else if (topArticle.errorCode < 0) {
        errorCode = article.errorCode;
        errorMessage = article.errorMsg;
      } else if (article.errorCode < 0) {
        errorCode = article.errorCode;
        errorMessage = article.errorMsg;
      }
      return FirstPageModule(banner: banner, articleModule: article, topArticle: topArticle, errorCode: errorCode, errorMsg: errorMessage);
    }
    return null;
  }

  Future<FirstPageModule> getFirstPageMoreData(FirstPageModule firstPageModule, int index) async {
    var response = await dio.get<Map<String, dynamic>>(NetPath.getFirstArticle(index));
    if (response != null) {
      var article = ArticleModule.fromJson(response.data);
      if (article.data.datas == null || article.data.datas.isEmpty) {
        return firstPageModule..isLoadMore = false;
      }
      var data = firstPageModule.articleModule.data;
      data.datas.addAll(article.data.datas);

      return FirstPageModule(
          isLoadMore: true,
          banner: firstPageModule.banner,
          articleModule: firstPageModule.articleModule,
          topArticle: firstPageModule.topArticle,
          errorCode: firstPageModule.errorCode,
          errorMsg: firstPageModule.errorMsg);
    }
    return firstPageModule..isLoadMore = false;
  }
}
