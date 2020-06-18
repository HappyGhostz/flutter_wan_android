// ignore_for_file: constant_identifier_names
class NetPath {
  static const APP_BASE_URL = 'https://www.wanandroid.com';

  static const REGISTER = '/user/register';
  static const LOG_IN = '/user/login';
  static const BANNER = '/banner/json';
  static const TOP_ARTICLE = '/article/top/json';
  static const NAVIGATION = '/navi/json';
  static const INTEGRAL = '/lg/coin/userinfo/json';
  static const WEB_COLLECT = '/lg/collect/usertools/json';
  static const LOGOUT = '/user/logout/json';
  static const ADD_TODO = '/lg/todo/add/json';

  static String getFirstArticle(int index) {
    return '/article/list/$index/json';
  }

  static const WX_ARTICLE = '/wxarticle/chapters/json';

  ///wxarticle/list/408/1/json
  static String getPublicAccountHistoryArticle(int chapterId, int index) {
    return '/wxarticle/list/$chapterId/$index/json';
  }

  ///lg/collect/list/0/json
  static String getArticleCollect(int index) {
    return '/lg/collect/list/$index/json';
  }

  ///user/lg/private_articles/1/json
  static String getMyShare(int index) {
    return '/user/lg/private_articles/$index/json';
  }

  ///  /lg/collect/1165/json
  static String collectArticle(int id) {
    return '/lg/collect/$id/json';
  }

  static String unCollectArticle(int id) {
    return '/lg/uncollect_originId/$id/json';
  }

  static String getTodoLists(int index) {
    return '/lg/todo/v2/list/$index/json';
  }

  static String changeStatusForTodo(int id) {
    return '/lg/todo/done/$id/json';
  }

  static String updateTodoItem(int id) {
    return '/lg/todo/update/$id/json';
  }

  static String deletedTodoItem(int id) {
    return '/lg/todo/delete/$id/json';
  }

  static String getAuthorList(int index) {
    return '/article/list/$index/json';
  }
}
