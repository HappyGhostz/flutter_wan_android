import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/author/author_view_module.dart';
import 'package:flutterwanandroid/ui/author/redux/author_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class AuthorPage extends StatelessWidget {
  AuthorPage({
    Key key,
    @required this.author,
  }) : super(key: key);
  final String author;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthorViewModule>(
        onInit: (store) {
          var state = store.state.authorState;
          state.dataLoadStatus = DataLoadStatus.loading;
          state.isPerformingRequest = false;
          var listController = ScrollController();
          state.scrollController = listController;
          listController.addListener(() {
            if (listController.position.pixels == listController.position.maxScrollExtent) {
              if (!state.isPerformingRequest) {
                var authorState = store.state.authorState;
                store.dispatch(loadMoreAction(authorState.pageOffset, authorState.articleModule, listController, author));
              }
            }
          });
          store.dispatch(loadInitAuthorDataAction(0, author));
        },
        onDispose: (store) {
          store.state.authorState.scrollController.dispose();
        },
        converter: AuthorViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text(author),
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              tapGestureRecognizer: () {
                vm.refreshAuthorPageData(author);
              },
              itemBuilder: (context, index) {
                if (index == _buildItemCount(vm) - 1) {
                  return _buildLoadMore(context, vm);
                } else {
                  return _buildArticle(context, vm, index);
                }
              },
              itemCount: _buildItemCount(vm),
              onRefresh: () async {
                vm.refreshAuthorPageData(author);
                return;
              },
              scrollController: vm.scrollController,
            ),
          );
        });
  }

  int _buildItemCount(AuthorViewModule vm) {
    var itemCount = 0;
    if (vm.articleModule != null) {
      itemCount = vm.articleModule.data.datas.length + 1;
    }
    return itemCount;
  }

  Widget _buildLoadMore(BuildContext context, AuthorViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildArticle(BuildContext context, AuthorViewModule vm, int articleIndexCount) {
    var article = vm.articleModule.data.datas[articleIndexCount];
    var isCurrentCollect = vm.collectIndexs == null ? null : vm.collectIndexs[articleIndexCount];
    var isCollect = isCurrentCollect ?? article.collect ?? false;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect, vm, articleIndexCount, context),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(article.title, vm, articleIndexCount, context),
              Padding(
                padding: edge16_8,
                child: Row(
                  children: <Widget>[
                    _buildAuthor(article.author, vm),
                    _buildArticleType(article.superChapterName, article.chapterName),
                  ],
                ),
              ),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(article.niceDate),
              ),
            ],
          ))
        ],
      ),
    );
  }

  IconButton _buildCollectWidget(bool collect, AuthorViewModule vm, int indexCount, BuildContext context) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          vm.updateCollectAction(context, !collect, indexCount);
        });
  }

  Widget _buildArticleTitle(String title, AuthorViewModule vm, int indexCount, BuildContext context) {
    return GestureDetector(
      onTap: () {
        var article = vm.articleModule.data.datas[indexCount];
        vm.goToArticle(context, article);
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

  Widget _buildAuthor(String author, AuthorViewModule vm) {
    var title = '';
    title = '作者';
    return Padding(
      padding: edgeRight_8,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              '$title:',
              style: AppTextStyle.caption(color: AppColors.lightGrey2),
            ),
          ),
          Text(
            author,
            style: AppTextStyle.caption(color: AppColors.black),
          )
        ],
      ),
    );
  }

  Widget _buildArticleType(String superChapterName, String chapterName) {
    return Expanded(
        child: GestureDetector(
      child: Padding(
        padding: edgeRight_8,
        child: Row(
          children: <Widget>[
            Text(
              '分类:',
              style: AppTextStyle.caption(color: AppColors.lightGrey2),
            ),
            Padding(
              padding: EdgeInsets.only(right: 2),
              child: Text(
                superChapterName,
                style: AppTextStyle.caption(color: AppColors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 2),
              child: Text(
                '/',
                style: AppTextStyle.caption(color: AppColors.lightGrey2),
              ),
            ),
            Expanded(
              child: Text(
                chapterName,
                style: AppTextStyle.caption(color: AppColors.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ));
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
}
