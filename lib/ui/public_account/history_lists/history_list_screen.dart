import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/module/public_account/history_list_module.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/public_account/services/public_account_services.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';

class PublicAccountHistoryListScreen extends StatefulWidget {
  PublicAccountHistoryListScreen({
    Key key,
    @required this.chapterId,
    @required this.dio,
  }) : super(key: key);
  final int chapterId;
  final Dio dio;

  @override
  State<StatefulWidget> createState() => _PublicAccountHistoryListScreenState();
}

class _PublicAccountHistoryListScreenState extends State<PublicAccountHistoryListScreen> {
  DataLoadStatus publicAccountHistoryStatus;
  ScrollController scrollController;
  PublicAccountHistoryListModule publicAccountHistoryListModule;
  bool isPerformingRequest;
  int pageOffset;
  PublicAccountPageService publicAccountPageService;
  int chapterId;
  Map<int, bool> collects;

  @override
  void initState() {
    publicAccountHistoryStatus = DataLoadStatus.loading;
    isPerformingRequest = false;
    chapterId = widget.chapterId;
    pageOffset = 1;
    scrollController = ScrollController();
    publicAccountPageService = PublicAccountPageService(dio: widget.dio);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isPerformingRequest) {
          loadMore();
        }
      }
    });
    refreshHistoryData(0);
    super.initState();
  }

  void refreshHistoryData(int pageOffset) async {
    try {
      var historyData = await publicAccountPageService.getPublicAccountHistoryActicles(chapterId, pageOffset);
      if (historyData == null) {
        publicAccountHistoryStatus = DataLoadStatus.empty;
      } else if (historyData.errorCode < 0) {
        publicAccountHistoryStatus = DataLoadStatus.failure;
      } else {
        publicAccountHistoryListModule = historyData;
        publicAccountHistoryStatus = DataLoadStatus.loadCompleted;
        pageOffset = 2;
      }
      setState(() {});
    } on DioError catch (e) {
      print('PublicAccountHistoryListScreen Dio Error::${e.message}');
      publicAccountHistoryStatus = DataLoadStatus.failure;
      setState(() {});
    } catch (e) {
      publicAccountHistoryStatus = DataLoadStatus.failure;
      setState(() {});
    }
  }

  void loadMore() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      try {
        var historyData = await publicAccountPageService.getHistoryMoreData(publicAccountHistoryListModule, chapterId, pageOffset);

        Future.delayed(const Duration(microseconds: 500), () {
          if (historyData == null) {
            var edge = 72;
            var offsetFromBottom =
                // ignore: invalid_use_of_protected_member
                scrollController.position.maxScrollExtent -
                    // ignore: invalid_use_of_protected_member
                    scrollController.position.pixels;
            if (offsetFromBottom < edge) {
              scrollController.animateTo(scrollController.offset - (edge - offsetFromBottom),
                  duration: Duration(milliseconds: 500), curve: Curves.easeOut);
            }
            historyData = publicAccountHistoryListModule;
          }
          publicAccountHistoryListModule = historyData;
          pageOffset++;
          isPerformingRequest = false;
          setState(() {});
        });
      } on DioError catch (e) {
        print('publicAccountPageService::loadMore:${e.toString()}');
        _updateErrorInfo();
      } catch (e) {
        print('publicAccountPageService::loadMore:${e.toString()}');
        _updateErrorInfo();
      }
    }
  }

  void _updateErrorInfo() {
    Future.delayed(const Duration(microseconds: 500), () {
      var edge = 72;
      // ignore: invalid_use_of_protected_member
      var offsetFromBottom = scrollController.position.maxScrollExtent -
          // ignore: invalid_use_of_protected_member
          scrollController.position.pixels;
      if (offsetFromBottom < edge) {
        scrollController.animateTo(scrollController.offset - (edge - offsetFromBottom),
            duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      }
      setState(() {
        isPerformingRequest = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLoadWidget(
      dataLoadStatus: publicAccountHistoryStatus,
      itemBuilder: (context, index) {
        if (index == publicAccountHistoryListModule.historyListData.datas.length) {
          return _buildLoadMore();
        }
        return _buildHistoryItem(index);
      },
      itemCount: _buildItemCount(),
      scrollController: scrollController,
      onRefresh: () async {
        showLoadingView();
        refreshHistoryData(0);
        return;
      },
      tapGestureRecognizer: () {
        showLoadingView();
        refreshHistoryData(0);
      },
    );
  }

  Widget _buildLoadMore() {
    return Opacity(
      opacity: isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildHistoryItem(int index) {
    var historyItem = publicAccountHistoryListModule.historyListData.datas[index];
    var isCurrentCollect = collects == null ? null : collects[index];
    var isCollect = isCurrentCollect ?? historyItem.collect ?? false;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect ?? false, index, historyItem),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(historyItem.title, historyItem),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(historyItem.niceDate),
              ),
            ],
          ))
        ],
      ),
    );
  }

  IconButton _buildCollectWidget(bool collect, int index, HistoryDatas historyItem) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          _upDateCollect(context, !collect, index, historyItem);
        });
  }

  Widget _buildArticleTitle(String title, HistoryDatas historyItem) {
    return GestureDetector(
      onTap: () {
        var params = <String, dynamic>{};
        params[webTitle] = historyItem.title;
        params[webUrlKey] = historyItem.link;
        RouterUtil.pushName(context, AppRouter.webRouterName, params: params);
      },
      child: Padding(
        padding: edge16_8,
        child: Text(
          title,
          maxLines: 2,
          style: AppTextStyle.head(color: AppColors.black),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String niceDate) {
    return Padding(
      padding: edgeRight_8,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              '时间:',
              style: AppTextStyle.caption(color: AppColors.lightGrey2),
            ),
          ),
          Expanded(
              child: Text(
            niceDate,
            style: AppTextStyle.caption(color: AppColors.lightGrey2),
          )),
        ],
      ),
    );
  }

  int _buildItemCount() {
    if (publicAccountHistoryListModule != null) {
      return publicAccountHistoryListModule.historyListData.datas.length + 1;
    }
    return 1;
  }

  void showLoadingView() {
    publicAccountHistoryStatus = DataLoadStatus.loading;
    setState(() {});
  }

  void _upDateCollect(BuildContext context, bool collect, int index, HistoryDatas historyItem) async {
    try {
      showLoadingDialog<dynamic>(context);
      var id = historyItem.id;
      Response response;
      if (collect) {
        response = await widget.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await widget.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      dismissDialog<void>(context);
      var collectsCopy = <int, bool>{};
      collectsCopy[index] = collect;
      if (collects == null) {
        collects = collectsCopy;
      } else {
        collects.addAll(collectsCopy);
      }
      setState(() {});
    } on DioError catch (e) {
      dismissDialog<void>(context);
    } catch (e) {
      dismissDialog<void>(context);
    }
  }
}
