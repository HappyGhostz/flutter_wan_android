import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/custom_widget/tag_widget.dart';
import 'package:flutterwanandroid/module/wenda/wen_da_module.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/wen_da/reducer/wen_da_action.dart';
import 'package:flutterwanandroid/ui/wen_da/wenda_view_module.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class WendaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WendaViewModule>(
        onInit: (store) {
          store.state.wendaState.scrollController = ScrollController();
          store.state.wendaState.isPerformingRequest = false;
          store.state.wendaState.pageOffset = 1;
          store.state.wendaState.dataLoadStatus = DataLoadStatus.loading;
          store.state.wendaState.scrollController.addListener(() {
            if (store.state.wendaState.scrollController.position.pixels ==
                store.state.wendaState.scrollController.position.maxScrollExtent) {
              if (!store.state.wendaState.isPerformingRequest) {
                store.dispatch(loadMoreAction(store.state.wendaState.wendaLists, store.state.wendaState.pageOffset));
              }
            }
          });
          store.dispatch(loadWendaListDataAction(1));
        },
        converter: WendaViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('问答'),
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                if (index == vm.wendaLists.length) {
                  return _buildLoadMore(vm);
                }
                return _buildDataWidget(vm, index, context);
              },
              itemCount: _buildItemCount(vm),
              scrollController: vm.scrollController,
              onRefresh: () async {
                vm.refreshData(1);
                return;
              },
              tapGestureRecognizer: () {
                vm.refreshData(1);
              },
            ),
          );
        });
  }

  int _buildItemCount(WendaViewModule vm) {
    if (vm.wendaLists == null) {
      return 1;
    }
    return vm.wendaLists.length + 1;
  }

  Widget _buildLoadMore(WendaViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildDataWidget(WendaViewModule vm, int index, BuildContext context) {
    var article = vm.wendaLists[index];
    var isCurrentCollect = vm.collectIndexs == null ? null : vm.collectIndexs[index];
    var isCollect = isCurrentCollect ?? article.collect ?? false;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect, vm, index, context),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(article.title, vm, article, context),
              Padding(
                padding: edge16_8,
                child: Row(
                  children: <Widget>[
                    _buildTagsView(article.tags, vm),
                    _buildAuthorOrShareUser(article.author, article.shareUser, vm, context),
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

  IconButton _buildCollectWidget(bool collect, WendaViewModule vm, int indexCount, BuildContext context) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          vm.updateCollectAction(context, !collect, indexCount);
        });
  }

  Widget _buildArticleTitle(String title, WendaViewModule vm, WendaModule wendaModule, BuildContext context) {
    return GestureDetector(
      onTap: () {
        vm.goToArticle(context, wendaModule);
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

  Widget _buildTagsView(List<Tags> tags, WendaViewModule vm) {
    if (tags == null || tags.isEmpty) {
      return Container();
    }
    var tagWidgets = <Widget>[];
    for (var tag in tags) {
      var tagChild = GestureDetector(
        onTapDown: (detail) {
//          vm.changeTagViewColorForTapDown(AppColors.primary, AppColors.white);
        },
        onTap: () {
//          vm.changeTagViewColorForTapDown(AppColors.white, AppColors.primary);
        },
        child: Padding(
          padding: EdgeInsets.only(right: 2, left: 2),
          child: TagWidget(
            tagInfo: tag.name,
            textInfoColor: AppColors.primary,
            borderSideColor: AppColors.primary,
            backgroundColor: AppColors.white,
          ),
        ),
      );
      tagWidgets.add(tagChild);
    }
    var tagRow = Padding(
      padding: edgeRight_8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tagWidgets,
      ),
    );
    return tagRow;
  }

  Widget _buildAuthorOrShareUser(String author, String shareUser, WendaViewModule vm, BuildContext context) {
    var name = '';
    var title = '';
    if (author.isNotEmpty) {
      name = author;
      title = '作者';
    } else {
      name = shareUser;
      title = '分享人';
    }
    return GestureDetector(
      onTapDown: (detail) {
//        vm.changeNameColorForTapDown(Colors.blue);
      },
      onTapUp: (detail) {
//        vm.changeNameColorForTapDown(AppColors.black);
      },
      onTap: () {
        if (author.isNotEmpty) {
          vm.goToAuthor(context, author);
        }
      },
      child: Padding(
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
              name,
              style: AppTextStyle.caption(color: AppColors.black),
            )
          ],
        ),
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
