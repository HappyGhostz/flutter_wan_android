// ignore_for_file: constant_identifier_names
class NetPath {
  static const APP_BASE_URL = 'https://www.wanandroid.com';

  static const REGISTER = '/user/register';
  static const LOG_IN = '/user/login';
  static const BANNER = '/banner/json';
  static const TOP_ARTICLE = '/article/top/json';

  static String getFirstArticle(int index) {
    return '/article/list/$index/json';
  }

  static const WX_ARTICLE = '/wxarticle/chapters/json';

  ///wxarticle/list/408/1/json
  static String getPublicAccountHistoryArticle(int chapterId, int index) {
    return '/wxarticle/list/$chapterId/$index/json';
  }
}
