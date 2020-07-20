import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/dialog/loading_dialog.dart';
import 'package:flutterwanandroid/custom_widget/load_more.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/module/project/project_list_module.dart';
import 'package:flutterwanandroid/net/base_response_object.dart';
import 'package:flutterwanandroid/net/net_path/net_path.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/image_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';

class ProjectListScreen extends StatefulWidget {
  ProjectListScreen({
    Key key,
    @required this.chapterId,
    @required this.dio,
  }) : super(key: key);
  final int chapterId;
  final Dio dio;

  @override
  State<StatefulWidget> createState() => ProjectListScreenState();
}

class ProjectListScreenState extends State<ProjectListScreen> {
  DataLoadStatus projectLoadStatus;
  ScrollController scrollController;
  bool isPerformingRequest;
  int pageOffset;
  int chapterId;
  Map<int, bool> collects;
  var projects = <Projects>[];

  @override
  void initState() {
    projectLoadStatus = DataLoadStatus.loading;
    isPerformingRequest = false;
    chapterId = widget.chapterId;
    pageOffset = 1;
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!isPerformingRequest) {
          loadMore();
        }
      }
    });
    super.initState();
    refreshHistoryData(1);
  }

  void refreshHistoryData(int index) async {
    try {
      var projectsResponse =
          await widget.dio.get<Map<String, dynamic>>(NetPath.getProjects(index), queryParameters: <String, dynamic>{'cid': chapterId});
      var projectListResponseModule = ProjectListResponseModule.fromJson(projectsResponse.data);
      if (projectListResponseModule == null ||
          projectListResponseModule.projectListData == null ||
          projectListResponseModule.projectListData.projects == null ||
          projectListResponseModule.projectListData.projects.isEmpty) {
        projectLoadStatus = DataLoadStatus.empty;
      } else if (projectListResponseModule.errorCode < 0) {
        projectLoadStatus = DataLoadStatus.failure;
      } else {
        projects = projectListResponseModule.projectListData.projects;
        projectLoadStatus = DataLoadStatus.loadCompleted;
        pageOffset = 2;
      }
      setState(() {});
    } catch (e) {
      projectLoadStatus = DataLoadStatus.failure;
      if (!mounted) {
        return;
      }
      setState(() {});
    }
  }

  void loadMore() async {
    if (!isPerformingRequest) {
      setState(() {
        isPerformingRequest = true;
      });
      try {
        var projectsMoreResponse = await widget.dio.get<Map<String, dynamic>>(NetPath.getProjects(pageOffset));
        var projectListResponseMoreModule = ProjectListResponseModule.fromJson(projectsMoreResponse.data);
        Future.delayed(const Duration(microseconds: 500), () {
          if (projectListResponseMoreModule == null ||
              projectListResponseMoreModule.projectListData == null ||
              projectListResponseMoreModule.projectListData.projects == null ||
              projectListResponseMoreModule.projectListData.projects.isEmpty) {
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
          } else {
            projects.addAll(projectListResponseMoreModule.projectListData.projects);
            pageOffset++;
          }
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
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLoadWidget(
      dataLoadStatus: projectLoadStatus,
      itemBuilder: (context, index) {
        if (index == projects.length) {
          return _buildLoadMore();
        }
        return _buildHistoryItem(index);
      },
      itemCount: projects.length + 1,
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

  void showLoadingView() {
    projectLoadStatus = DataLoadStatus.loading;
    setState(() {});
  }

  Widget _buildLoadMore() {
    return Opacity(
      opacity: isPerformingRequest ? 1.0 : 0.0,
      child: LoadMorePage(),
    );
  }

  Widget _buildHistoryItem(int index) {
    var projectItem = projects[index];
    var isCurrentCollect = collects == null ? null : collects[index];
    var isCollect = isCurrentCollect ?? projectItem.collect ?? false;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollectWidget(isCollect ?? false, index, projectItem),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildArticleTitle(projectItem.title, projectItem),
              Padding(
                padding: edge16_8,
                child: _buildSubjectTitle(projectItem.desc),
              ),
              Padding(
                padding: edge16_8,
                child: _buildTimeAndNameInfo(projectItem.niceDate, projectItem.author),
              ),
            ],
          )),
          SizedBox(
            width: 72,
            child: FadeInImage.assetNetwork(
              placeholder: getAssetsImage(),
              image: projectItem.envelopePic,
              width: MediaQuery.of(context).size.width,
              height: 75.0,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  IconButton _buildCollectWidget(bool collect, int index, Projects projectItem) {
    return IconButton(
        icon: Icon(
          collect ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          _upDateCollect(context, !collect, index, projectItem);
        });
  }

  Widget _buildArticleTitle(String title, Projects project) {
    return GestureDetector(
      onTap: () {
        var params = <String, dynamic>{};
        params[webTitle] = project.title;
        params[webUrlKey] = project.link;
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

  void _upDateCollect(BuildContext context, bool collect, int index, Projects projectItem) async {
    try {
      showLoadingDialog<dynamic>(context);
      var id = projectItem.id;
      Response<Map<String, dynamic>> response;
      if (collect) {
        response = await widget.dio.post<Map<String, dynamic>>(NetPath.collectArticle(id));
      } else {
        response = await widget.dio.post<Map<String, dynamic>>(NetPath.unCollectArticle(id));
      }
      dismissDialog<void>(context);
      var baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.errorCode == -1001) {
        var store = StoreProvider.of<AppState>(context);
        store.dispatch(VerificationFailedAction(context: context));
      } else {
        var collectsCopy = <int, bool>{};
        collectsCopy[index] = collect;
        if (collects == null) {
          collects = collectsCopy;
        } else {
          collects.addAll(collectsCopy);
        }
        setState(() {});
      }
    } on DioError catch (e) {
      dismissDialog<void>(context);
    } catch (e) {
      dismissDialog<void>(context);
    }
  }

  Widget _buildSubjectTitle(String desc) {
    return Text(
      desc ?? '',
      style: AppTextStyle.caption(color: AppColors.lightGrey2, fontSize: 14),
      maxLines: 6,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTimeAndNameInfo(String niceDate, String author) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                niceDate ?? '',
                style: AppTextStyle.caption(color: AppColors.lightGrey2),
              ),
            )),
        Expanded(
            child: Text(
          author ?? '',
          style: AppTextStyle.caption(color: AppColors.lightGrey2),
        )),
      ],
    );
  }
}
