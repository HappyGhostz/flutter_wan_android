import 'package:dio/dio.dart';
import 'package:flutterwanandroid/module/public_account/history_list_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';

class PublicAccountPageService {
  PublicAccountPageService({this.dio});

  Dio dio;

  Future<Response<Map<String, dynamic>>> getWXChapters() async {
    var response = await dio.get<Map<String, dynamic>>(NetPath.WX_ARTICLE);
    return response;
  }

  Future<PublicAccountHistoryListModule> getPublicAccountHistoryActicles(int chapterId, int index) async {
    var response = await dio.get<Map<String, dynamic>>(NetPath.getPublicAccountHistoryArticle(chapterId, index));
    return PublicAccountHistoryListModule.fromJson(response.data);
  }

  Future<PublicAccountHistoryListModule> getHistoryMoreData(PublicAccountHistoryListModule historyModules, int chapterId, int index) async {
    var response = await dio.get<Map<String, dynamic>>(NetPath.getPublicAccountHistoryArticle(chapterId, index));

    if (response != null) {
      var historyArticle = PublicAccountHistoryListModule.fromJson(response.data);
      if (historyArticle.historyListData.datas == null || historyArticle.historyListData.datas.isEmpty) {
        return null;
      }
      var oldData = historyModules.getHistoryListData();
      oldData.datas.addAll(historyArticle.historyListData.datas);
      var newData = oldData
        ..clone()
        ..size = historyArticle.historyListData.size
        ..curPage = historyArticle.historyListData.curPage
        ..offset = historyArticle.historyListData.offset
        ..over = historyArticle.historyListData.over
        ..pageCount = historyArticle.historyListData.pageCount
        ..total = historyArticle.historyListData.total;

      return historyModules
        ..clone()
        ..errorCode = historyArticle.errorCode
        ..errorMsg = historyArticle.errorMsg
        ..historyListData = newData;
    }
    return null;
  }
}
