import 'package:flutterwanandroid/module/first_page/article.dart';
import 'package:flutterwanandroid/module/first_page/banner.dart';
import 'package:flutterwanandroid/module/first_page/top_article.dart';

class FirstPageModule {
  FirstPageModule({
    this.banner,
    this.articleModule,
    this.topArticle,
    this.errorCode,
    this.errorMsg,
    this.isLoadMore,
  });
  Banner banner;
  ArticleModule articleModule;
  TopArticle topArticle;
  int errorCode;
  String errorMsg;
  bool isLoadMore;
}
