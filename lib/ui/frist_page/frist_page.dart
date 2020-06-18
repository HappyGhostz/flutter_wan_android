import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/banner.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/custom_widget/tag_widget.dart';
import 'package:flutterwanandroid/module/first_page/article.dart';
import 'package:flutterwanandroid/module/first_page/banner.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/frist_page/first_page_view_module.dart';
import 'package:flutterwanandroid/ui/frist_page/redux/first_page_action.dart';
import 'package:flutterwanandroid/ui/frist_page/services/first_page_service.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/data_utils.dart';
import 'package:flutterwanandroid/utils/image_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FirstPageViewModule>(
      onInit: (store) {
        var firstPageState = store.state.firstPageState;
        firstPageState.firstPageStatus = DataLoadStatus.loading;
        firstPageState.isPerformingRequest = false;
        firstPageState.currentIndex = 0;
        firstPageState.pageOffset = 0;
        firstPageState.firstPageService = FirstPageService(dio: store.state.dio);
        var listController = ScrollController();
        firstPageState.scrollController = listController;
        listController.addListener(() {
          if (listController.position.pixels == listController.position.maxScrollExtent) {
            if (!firstPageState.isPerformingRequest) {
              var firstPageState = store.state.firstPageState;
              store.dispatch(loadMoreAction(firstPageState.pageOffset, firstPageState.firstPageModule, listController));
            }
          }
        });
        store.dispatch(loadInitDataAction(0));
      },
      onDispose: (store) {
        store.state.firstPageState.scrollController.dispose();
      },
      converter: FirstPageViewModule.fromStore,
      builder: (context, vm) {
        return PageLoadWidget(
          dataLoadStatus: vm.firstPageStatus,
          tapGestureRecognizer: () {
            vm.refreshFirstPageData();
          },
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildBanner(context, vm);
            } else if (index == _buildItemCount(vm) - 1) {
              return _buildLoadMore(context, vm);
            } else if (index <= vm.firstPageModule.topArticle.data.length) {
              var topArticleIndexCount = index - 1;
              return _buildTopArticle(vm, topArticleIndexCount, context);
            } else {
              var articleIndexCount = index - vm.firstPageModule.topArticle.data.length - 1;
              return _buildArticle(vm, articleIndexCount, context);
            }
          },
          itemCount: _buildItemCount(vm),
          onRefresh: () async {
            vm.refreshFirstPageData();
            return;
          },
          scrollController: vm.scrollController,
        );
      },
    );
  }

  Widget _buildTopArticle(FirstPageViewModule vm, int topArticleIndexCount, BuildContext context) {
    var topArticleData = vm.firstPageModule.topArticle.data[topArticleIndexCount];
    var isCurrentCollect = vm.collectIndexs == null ? false : vm.collectIndexs[topArticleIndexCount];
    var isCollect = false;
    if (topArticleData.collect != null && topArticleData.collect && vm.collectIndexs == null) {
      isCollect = topArticleData.collect;
    } else {
      isCollect = isCurrentCollect ?? topArticleData.collect ?? false;
    }
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect, vm, true, topArticleIndexCount, context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildArticleTitle(topArticleData.title, vm, true, topArticleIndexCount, context),
                Padding(
                  padding: edge16_8,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: edgeRight_2,
                        child: TagWidget(
                          tagInfo: '置顶',
                          textInfoColor: AppColors.warning,
                          borderSideColor: AppColors.warning,
                        ),
                      ),
                      DataUtil.isToDay(topArticleData.niceDate)
                          ? Padding(
                              padding: edgeRight_4,
                              child: TagWidget(
                                tagInfo: '新',
                                textInfoColor: AppColors.warning,
                                borderSideColor: AppColors.warning,
                              ),
                            )
                          : Container(),
                      _buildTagsView(topArticleData.tags, vm),
                      _buildAuthorOrShareUser(topArticleData.author, topArticleData.shareUser, vm, context),
                      _buildArticleType(topArticleData.superChapterName, topArticleData.chapterName),
                    ],
                  ),
                ),
                Padding(
                  padding: edge16_8,
                  child: _buildTimeInfo(topArticleData.niceDate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticle(FirstPageViewModule vm, int articleIndexCount, BuildContext context) {
    var article = vm.firstPageModule.articleModule.data.datas[articleIndexCount];
    var isCurrentCollect = vm.collectIndexs == null ? false : vm.collectIndexs[articleIndexCount];
    var isCollect = isCurrentCollect ?? article.collect ?? false;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect, vm, false, articleIndexCount, context),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(article.title, vm, false, articleIndexCount, context),
              Padding(
                padding: edge16_8,
                child: Row(
                  children: <Widget>[
                    DataUtil.isToDay(article.niceDate)
                        ? Padding(
                            padding: edgeRight_8,
                            child: TagWidget(
                              tagInfo: '新',
                              textInfoColor: AppColors.warning,
                              borderSideColor: AppColors.warning,
                            ),
                          )
                        : Container(),
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

  IconButton _buildCollectWidget(bool collect, FirstPageViewModule vm, bool isTopArticle, int indexCount, BuildContext context) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          vm.updateCollectAction(context, !collect, isTopArticle, indexCount);
        });
  }

  int _buildItemCount(FirstPageViewModule vm) {
    var itemCount = 0;
    if (vm.firstPageModule != null) {
      itemCount = vm.firstPageModule.topArticle.data.length + vm.firstPageModule.articleModule.data.datas.length + 1;
    }
    return itemCount;
  }

  Widget _buildBanner(BuildContext context, FirstPageViewModule vm) {
    return BannerView(
      cycleRolling: true,
      banners: _buildBannerView(vm.firstPageModule.banner.bannerData, context),
      intervalDuration: Duration(seconds: 5),
      itemTextInfo: (index) {
        var ad = vm.firstPageModule.banner.bannerData[index];
        return ad.title ?? '......';
      },
      height: 200.0,
    );
  }

  List<Widget> _buildBannerView(List<BannerData> banner, BuildContext context) {
    var widget = <Widget>[];
    for (var i = 0; i < banner.length; i++) {
      var bannerData = banner[i];
      widget.add(GestureDetector(
        child: FadeInImage.assetNetwork(
          placeholder: getAssetsImage(),
          image: bannerData.imagePath,
          width: MediaQuery.of(context).size.width,
          height: 75.0,
          fit: BoxFit.fill,
        ),
        onTap: () {},
      ));
    }
    return widget;
  }

  Widget _buildLoadMore(BuildContext context, FirstPageViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildArticleTitle(String title, FirstPageViewModule vm, bool isTop, int indexCount, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isTop) {
          var topArticle = vm.firstPageModule.topArticle.data[indexCount];
          vm.goToTopArticle(context, topArticle);
        } else {
          var article = vm.firstPageModule.articleModule.data.datas[indexCount];
          vm.goToArticle(context, article);
        }
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

  Widget _buildTagsView(List<Tags> tags, FirstPageViewModule vm) {
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
            textInfoColor: vm.tagTextInfoColor ?? AppColors.primary,
            borderSideColor: AppColors.primary,
            backgroundColor: vm.tabBackgroundTagViewColor ?? AppColors.white,
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

  Widget _buildAuthorOrShareUser(String author, String shareUser, FirstPageViewModule vm, BuildContext context) {
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
          RouterUtil.pushName(context, AppRouter.authorArticleRouterName, params: <String, dynamic>{
            authorKey: author,
          });
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
              style: AppTextStyle.caption(color: vm.tabBackgroundNameColor ?? AppColors.black),
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
