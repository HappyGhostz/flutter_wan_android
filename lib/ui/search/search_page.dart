import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_custom_widget.dart';
import 'package:flutterwanandroid/custom_widget/photo_hero.dart';
import 'package:flutterwanandroid/custom_widget/tag_widget.dart';
import 'package:flutterwanandroid/module/search/search_result.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/search/redux/search_action.dart';
import 'package:flutterwanandroid/ui/search/search_view_module.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/data_utils.dart';
import 'package:flutterwanandroid/utils/image_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';

class SearchPage extends StatelessWidget {
  SearchPage({
    Key key,
    this.currentIndex,
  }) : super(key: key);
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SearchViewModule>(
        converter: SearchViewModule.fromStore,
        onDispose: (store) {
          store.state.searchState.scrollController.dispose();
          store.state.searchState.textEditingController.dispose();
        },
        onInit: (store) {
          var searchState = store.state.searchState;
          searchState.textEditingController = TextEditingController();
          searchState.isEditing = false;
          searchState.currentIndex = currentIndex;
          searchState.isPerformingRequest = false;
          searchState.searchResultResponseModule = null;
          searchState.pageOffset = 0;
          searchState.dataLoadStatus = DataLoadStatus.loading;
          searchState.textEditingController.addListener(() {
            store.dispatch(UpdateEditStatusAction(isEdit: true));
          });
          store.dispatch(getHotKeyAction());
          store.dispatch(getHistorySearchKey());

          var listController = ScrollController();
          searchState.scrollController = listController;
          listController.addListener(() {
            if (listController.position.pixels == listController.position.maxScrollExtent) {
              if (!searchState.isPerformingRequest) {
                var searchState = store.state.searchState;
                store.dispatch(
                    loadMoreAction(searchState.keyWord, searchState.pageOffset, searchState.searchResultResponseModule, listController));
              }
            }
          });
        },
        builder: (context, vm) {
          return Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: AppColors.white,
              child: Column(
                children: <Widget>[
                  _buildSearchBar(context, vm),
                  CustomPageLoadWidget(
                    dataLoadStatus: vm.dataLoadStatus,
                    child: _buildDataWidget(vm, context),
                    tapGestureRecognizer: () {
                      if (vm.keyWord == null || vm.keyWord.isEmpty) {
                        vm.refreshHotKey();
                      } else {
                        vm.search(vm.keyWord, 0, currentIndex);
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _buildSearchBar(BuildContext context, SearchViewModule vm) {
    return Material(
      elevation: 8,
      child: Container(
        height: 90,
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0),
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            Expanded(
                child: Container(
              //height: double.infinity, //This is extra
              // Subtract sums of paddings and margins from actual width
              child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (keyWord) {
                  vm.search(keyWord, 0, currentIndex);
                  vm.saveHistoryKey(keyWord, vm.historyList);
                },
                controller: vm.textEditingController,
                cursorColor: AppColors.white,
                cursorWidth: 1,
                cursorRadius: Radius.circular(30.0),
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w300),
                decoration: InputDecoration(
                    hintText: currentIndex == 1 ? '${vm.publicAccountSearchName}:公众号内搜索' : 'Search(点这里)',
                    border: InputBorder.none,
                    hintStyle: AppTextStyle.body(fontSize: 14, fontWeight: FontWeight.w300, color: AppColors.black)),
              ),
            )),
            vm.isEditing
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      vm.textEditingController.text = '';
                      FocusScope.of(context).requestFocus(FocusNode());
                      vm.updateIsEditStatus(false);
                      vm.clearData();
                    })
                : SearchHero(
                    width: 30.0,
                    search: "search",
                    onTap: () {},
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataWidget(SearchViewModule vm, BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height - 90.0,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Text(
                  "大家都在搜",
                  style: AppTextStyle.head(color: Colors.grey),
                ),
              ),
              SliverToBoxAdapter(
                child: builerTags(vm),
              ),
              SliverToBoxAdapter(
                child: _buildHistoryInfo(vm),
              ),
              (vm.historyList == null || vm.historyList.isEmpty)
                  ? SliverToBoxAdapter(
                      child: Container(),
                    )
                  : _buildHistorys(vm)
            ],
          ),
        ),
        vm.searchResultResponseModule == null
            ? Container()
            : Container(
                color: AppColors.white,
                height: MediaQuery.of(context).size.height - 90.0,
                width: MediaQuery.of(context).size.width,
                child: _buildSearchResult(vm),
              )
      ],
    );
  }

  Widget builerTags(SearchViewModule vm) {
    return Wrap(
      spacing: 4.0,
      alignment: WrapAlignment.start,
      children: _builderTagView(vm),
    );
  }

  List<Widget> _builderTagView(SearchViewModule vm) {
    if (vm.searchHotKeyResponseModule == null) {
      return <Widget>[Container()];
    }
    var widgets = <Widget>[];
    for (var i = 0; i < vm.searchHotKeyResponseModule.hotKey.length; i++) {
      var tag = vm.searchHotKeyResponseModule.hotKey[i].name;
      var color = getAssetsColor();
      var gestureDetector = _buildeGesTag(tag, color, vm);
      widgets.add(gestureDetector);
    }
    return widgets;
  }

  Widget _buildeGesTag(String tag, Color color, SearchViewModule vm) {
    return GestureDetector(
      child: Chip(
        label: Text(
          tag,
          style: AppTextStyle.body2(color: AppColors.white),
        ),
        backgroundColor: color,
        shape: RoundedRectangleBorder(side: BorderSide(color: color)),
      ),
      onTap: () {
        vm.textEditingController.text = tag;
        vm.search(tag, 0, currentIndex);
        vm.saveHistoryKey(tag, vm.historyList);
      },
    );
  }

  Widget _buildHistoryInfo(SearchViewModule vm) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "搜索历史",
            style: AppTextStyle.body2(color: AppColors.black21),
          ),
          GestureDetector(
            onTap: () {
              vm.historyList.clear();
              vm.saveHistoryKey('', vm.historyList);
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.delete,
                  color: AppColors.greyAc,
                ),
                Text(
                  "清空",
                  style: AppTextStyle.body2(color: AppColors.black21),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorys(SearchViewModule vm) {
    var historys = vm.historyList;
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      if ((index + 1) == historys.length * 2) {
        return Container();
      } else if ((index + 1) % 2 == 0) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.0, top: 2.0),
          child: Divider(
            height: 1.0,
            color: AppColors.greyAc,
          ),
        );
      } else {
        final i = index ~/ 2;
        return _buildHitsoryItem(i, historys, vm);
      }
    }, childCount: historys.length * 2));
  }

  Widget _buildHitsoryItem(int index, List<String> historys, SearchViewModule vm) {
    var history = historys[index];
    return GestureDetector(
      onTap: () {
        vm.textEditingController.text = history;
        vm.search(history, 0, currentIndex);
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.timer,
              color: AppColors.greyAc,
            ),
            Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text(
                history,
                style: TextStyle(color: AppColors.greyAc),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResult(SearchViewModule vm) {
    return RefreshIndicator(
      backgroundColor: AppColors.white,
      child: ListView.separated(
          controller: vm.scrollController,
          itemBuilder: (context, index) {
            if (index == vm.searchResultResponseModule.searchResultModule.searchResults.length) {
              return _buildLoadMore(context, vm);
            }
            return _buildArticle(vm, index, context);
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 1,
              color: AppColors.greyAc,
            );
          },
          itemCount: vm.searchResultResponseModule != null ? vm.searchResultResponseModule.searchResultModule.searchResults.length + 1 : 1),
      onRefresh: () async {
        vm.search(vm.textEditingController.text, 0, currentIndex);
        return;
      },
    );
  }

  Widget _buildLoadMore(BuildContext context, SearchViewModule vm) {
    return Opacity(
      opacity: vm.isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildArticle(SearchViewModule vm, int articleIndexCount, BuildContext context) {
    var articleResult = vm.searchResultResponseModule.searchResultModule.searchResults[articleIndexCount];
    var isCurrentCollect = vm.collectIndexs == null ? null : vm.collectIndexs[articleIndexCount];
    var isCollect = isCurrentCollect ?? articleResult.collect ?? false;
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
              _buildArticleTitle(articleResult.title, vm, articleIndexCount, context),
              Padding(
                padding: edge16_8,
                child: Row(
                  children: <Widget>[
                    DataUtil.isToDay(articleResult.niceDate)
                        ? Padding(
                            padding: edgeRight_8,
                            child: TagWidget(
                              tagInfo: '新',
                              textInfoColor: AppColors.warning,
                              borderSideColor: AppColors.warning,
                            ),
                          )
                        : Container(),
                    _buildTagsView(articleResult.tags, vm),
                    _buildAuthorOrShareUser(articleResult.author, articleResult.shareUser, vm, context),
                    _buildArticleType(articleResult.superChapterName, articleResult.chapterName),
                  ],
                ),
              ),
              Padding(
                padding: edge16_8,
                child: _buildTimeInfo(articleResult.niceDate),
              ),
            ],
          ))
        ],
      ),
    );
  }

  IconButton _buildCollectWidget(bool collect, SearchViewModule vm, int indexCount, BuildContext context) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          vm.updateCollectAction(context, !collect, indexCount);
        });
  }

  Widget _buildArticleTitle(String title, SearchViewModule vm, int indexCount, BuildContext context) {
    Widget titileWidget;
    var searchKeys = <String>[];
    var titileSplites = <String>[];
    var htmlInfos = getDisplayInfoFromHtml(title);
    if (htmlInfos.length > 1) {
      for (var i = 0; i < htmlInfos.length; i++) {
        var htmlInfo = htmlInfos[i];
        var searchKey = getSearchKeyFromHtml(htmlInfo);
        searchKeys.add(searchKey);
      }
      var spliteTitle = title;
      var textSpansCopy = <TextSpan>[];
      for (var i = 0; i < searchKeys.length; i++) {
        var searchKey = searchKeys[i];
        var htmlInfo = htmlInfos[i];
        if (spliteTitle.contains(htmlInfo)) {
          titileSplites = spliteTitle.split(htmlInfo);
          var textSpans = <TextSpan>[
            TextSpan(text: titileSplites[0], style: AppTextStyle.head(color: AppColors.black)),
            TextSpan(text: searchKey, style: AppTextStyle.head(color: Theme.of(context).primaryColor)),
          ];
          textSpansCopy.addAll(textSpans);
          spliteTitle = titileSplites[1];
        }
      }
      var textSpans = <TextSpan>[
        TextSpan(text: spliteTitle, style: AppTextStyle.head(color: AppColors.black)),
      ];
      textSpansCopy.addAll(textSpans);

      titileWidget = RichText(
        text: TextSpan(
          children: textSpansCopy,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    } else if (htmlInfos.length == 1) {
      var searchKey = getSearchKeyFromHtml(htmlInfos[0]);
      var titleSplites = title.split(htmlInfos[0]);
      var textSpans = <TextSpan>[
        TextSpan(text: titleSplites[0], style: AppTextStyle.head(color: AppColors.black)),
        TextSpan(text: searchKey, style: AppTextStyle.head(color: Theme.of(context).primaryColor)),
        TextSpan(text: titleSplites[1], style: AppTextStyle.head(color: AppColors.black)),
      ];

      titileWidget = RichText(
        text: TextSpan(
          children: textSpans,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    } else {
      titileWidget = Text(
        title,
        maxLines: 2,
        style: AppTextStyle.head(color: AppColors.black),
        overflow: TextOverflow.ellipsis,
      );
    }
    return GestureDetector(
      onTap: () {
        var article = vm.searchResultResponseModule.searchResultModule.searchResults[indexCount];
        vm.goToSearchArticle(context, article);
      },
      child: Padding(
        padding: edge16_8,
        child: titileWidget,
      ),
    );
  }

  List<String> getDisplayInfoFromHtml(String display) {
    var regexp = RegExp('<em.*?em>');
    var allMatch = regexp.allMatches(display);
    var matchs = allMatch.map((e) => e.group(0)).toList();
//    var displayValue = regexp.stringMatch(display);
    return matchs;
  }

  String getSearchKeyFromHtml(String display) {
    var regexp = RegExp('>.*?<');
    var displayValue = regexp.stringMatch(display).replaceAll('>', '').replaceAll('<', '');
    return displayValue;
  }

  Widget _buildTagsView(List<Tags> tags, SearchViewModule vm) {
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

  Widget _buildAuthorOrShareUser(String author, String shareUser, SearchViewModule vm, BuildContext context) {
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
