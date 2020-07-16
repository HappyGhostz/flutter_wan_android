import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/page_show_widget.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_constent_padding.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/collect/collect_web/collect_web_view_module.dart';
import 'package:flutterwanandroid/ui/collect/collect_web/reducer/collect_web_action.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/dialog_manager.dart';

class CollectWebScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CollectWebViewModule>(
        onInit: (store) {
          store.state.collectWebState.dataLoadStatus = DataLoadStatus.loading;
          store.dispatch(loadCollectWebListDataAction());
        },
        onDispose: (store) async {
          var isFirstEnterCollectWeb = await store.state.appDependency.sharedPreferences.getBool(isFirstEnterCollectWebKey);
          if (isFirstEnterCollectWeb == null || !isFirstEnterCollectWeb) {
            await store.state.appDependency.sharedPreferences.setBool(isFirstEnterCollectWebKey, true);
          }
          store.state.collectWebState.scrollController?.dispose();
        },
        onInitialBuild: (vm) {
          vm.showPromptInfo(context);
        },
        converter: CollectWebViewModule.fromStore,
        builder: (context, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('收藏网页列表'),
              actions: <Widget>[
                _buildAddWebWidget(context, vm),
              ],
            ),
            body: PageLoadWidget(
              dataLoadStatus: vm.dataLoadStatus,
              itemBuilder: (context, index) {
                return _buildDataWidget(vm, index, context);
              },
              itemCount: _buildItemCount(vm),
              onRefresh: () async {
                vm.refreshData();
                return;
              },
              scrollController: ScrollController(),
              tapGestureRecognizer: () {
                vm.refreshData();
              },
            ),
          );
        });
  }

  int _buildItemCount(CollectWebViewModule vm) {
    if (vm.collectWebs == null) {
      return 1;
    }
    return vm.collectWebs.length;
  }

  Widget _buildDataWidget(CollectWebViewModule vm, int index, BuildContext context) {
    var collectWeb = vm.collectWebs[index];
    return Dismissible(
        key: Key('key${collectWeb.id}'),
        background: Container(
          color: AppColors.warning,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.edit,
                color: AppColors.white,
              ),
              Text(
                '编辑',
                style: AppTextStyle.caption(color: AppColors.white),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          color: AppColors.warning,
          child: Row(
            children: <Widget>[
              Spacer(),
              Text(
                '删除',
                style: AppTextStyle.caption(color: AppColors.white),
              ),
              Icon(
                Icons.delete,
                color: AppColors.white,
              ),
            ],
          ),
        ),
        onDismissed: (direction) {
          vm.cancelCollect(context, collectWeb);
        },
        confirmDismiss: (direction) async {
          bool isDismiss;
          if (direction == DismissDirection.endToStart) {
            isDismiss = true;
          } else {
            var params = await showCollectEditDialog(
              context,
              title: collectWeb.name,
              editItemTitle: '编辑',
              content: collectWeb.link,
            );
            if (params.isEmpty) {
              return Future.value(false);
            }
            vm.editCollectWeb(context, collectWeb, params);
            isDismiss = false;
          }
          return Future.value(isDismiss);
        },
        child: GestureDetector(
          onTap: () {
            vm.pushWebPage(context, collectWeb);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: AppColors.white,
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildArticleTitle(collectWeb.name, vm, index, context),
              ],
            ),
          ),
        ));
  }

  Widget _buildArticleTitle(String title, CollectWebViewModule vm, int indexCount, BuildContext context) {
    return Padding(
      padding: edge16_8,
      child: Text(
        title,
        maxLines: 2,
        style: AppTextStyle.head(color: Theme.of(context).primaryColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildAddWebWidget(BuildContext context, CollectWebViewModule vm) {
    return Container(
      child: IconButton(
          icon: Icon(
            Icons.add,
            color: AppColors.white,
          ),
          onPressed: () async {
            var params = await showCollectEditDialog(
              context,
              title: '请输入网站名称',
              editItemTitle: '新增网站',
              content: '请输入链接地址',
            );
            if (params.isEmpty) {
              return;
            }
            vm.addCollectWeb(context, params);
          }),
    );
  }
}
