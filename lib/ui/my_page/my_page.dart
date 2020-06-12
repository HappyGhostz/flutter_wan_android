import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/custom_widget/app_button.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/my_page/my_view_module.dart';
import 'package:flutterwanandroid/ui/my_page/redux/my_page_action.dart';
import 'package:flutterwanandroid/utils/image_utils.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';
import 'package:redux/src/store.dart';

import '../../app_router.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MyViewModule>(
      converter: MyViewModule.fromStore,
      onInit: (store) {
        store.state.myState.isRefresh = true;
        initDataAction(store);
      },
      builder: (context, vm) {
        return Container(
          color: AppColors.white,
          child: CustomScrollView(
            physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: <Widget>[
              _buildMyMessageWidget(vm, context),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.build, title: '项目'),
              ),
              _buildDivider(height: 1),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.category, title: '体系'),
              ),
              _buildDivider(height: 1),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.question_answer, title: '问答'),
              ),
              _buildDivider(title: '积分', padding: EdgeInsets.only(top: 4, right: 4, left: 8, bottom: 4)),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.assessment, title: '积分排行榜'),
              ),
              _buildDivider(height: 1),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.person_add, title: '个人积分获取'),
              ),
              _buildDivider(title: '收藏', padding: EdgeInsets.only(top: 4, right: 4, left: 8, bottom: 4)),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.collections_bookmark, title: '收藏文章列表'),
              ),
              _buildDivider(height: 1),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.collections, title: '收藏文章'),
              ),
              _buildDivider(height: 1),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.computer, title: '收藏网站列表'),
              ),
              _buildDivider(height: 1),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.public, title: '收藏网址'),
              ),
              _buildDivider(height: 16),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.crop_square, title: '广场'),
              ),
              _buildDivider(height: 1),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.share, title: '分享文章列表'),
              ),
              _buildDivider(height: 1),
              SliverToBoxAdapter(
                child: _buildRowItem(context, itemIcon: Icons.language, title: '常用网站'),
              ),
              SliverToBoxAdapter(
                child: _buildLogoutWidget(vm, context),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Text(
                        'Or',
                      ),
                    )
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: _buildLogInWidget(vm, context),
              ),
            ],
          ),
        );
      },
    );
  }

  void initDataAction(Store<AppState> store) {
    store.dispatch(upDateAccountDataAction());
    store.dispatch(updateIntegralDataAction());
    store.dispatch(updateCollectionDataAction());
    store.dispatch(updateWebCollectionDataAction());
    store.dispatch(updateMyShareDataAction());
  }

  Widget _buildRowItem(BuildContext context, {IconData itemIcon, String title}) {
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Container(
            child: Icon(
              itemIcon,
              color: Theme.of(context).primaryColor,
            ),
            padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 16),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, top: 8, right: 16, bottom: 16),
            child: Text(
              title,
              style: AppTextStyle.caption(color: AppColors.black, fontSize: 18),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(left: 8, top: 8, right: 16, bottom: 16),
            child: Icon(
              Icons.keyboard_arrow_right,
              color: AppColors.lightGrey2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyMessageWidget(MyViewModule vm, BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 280,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Color(0xFFF9A825), Color(0xFFBBDEFB), Color(0xFF0288D1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
            ),
            Positioned(
                top: 24,
                left: 16,
                right: 16,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  elevation: 4,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    height: 240,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Card(
                              elevation: 2,
                              shape: CircleBorder(),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundImage: vm.isLogin
                                    ? AssetImage(
                                        getAssetsImage(),
                                      )
                                    : AssetImage(
                                        'assets/people.webp',
                                      ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                            ),
                            Expanded(
                                child: Text(
                              vm.name,
                              style: AppTextStyle.head(fontSize: 24, color: Theme.of(context).primaryColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            )),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: vm.isRefresh
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        vm.refresh();
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.refresh,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            '刷新',
                                            style: AppTextStyle.caption(color: Theme.of(context).primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 24),
                          child: Divider(
                            height: 1,
                            color: AppColors.lightGrey3,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    vm.integralModule == null ? '0' : '${vm.integralModule?.integralData?.coinCount ?? 0}',
                                    style: AppTextStyle.caption(fontSize: 18, color: Theme.of(context).primaryColor),
                                  ),
                                  Text(
                                    '积分',
                                    style: AppTextStyle.caption(color: Theme.of(context).primaryColor, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    _getCollectNum(vm),
                                    style: AppTextStyle.caption(fontSize: 18, color: Theme.of(context).primaryColor),
                                  ),
                                  Text(
                                    '收藏',
                                    style: AppTextStyle.caption(color: Theme.of(context).primaryColor, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    vm.myShareModule == null ? '0' : '${vm.myShareModule?.shareData?.shareArticles?.total ?? 0}',
                                    style: AppTextStyle.caption(fontSize: 18, color: Theme.of(context).primaryColor),
                                  ),
                                  Text(
                                    '分享',
                                    style: AppTextStyle.caption(color: Theme.of(context).primaryColor, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _buildDivider({
    double height,
    String title,
    EdgeInsetsGeometry padding,
  }) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.lightGrey3,
        height: height == null ? null : height,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 0.0),
        child: title == null
            ? null
            : Text(
                title,
                style: AppTextStyle.caption(fontSize: 14, color: AppColors.lightGrey1),
              ),
      ),
    );
  }

  Widget _buildLogoutWidget(MyViewModule vm, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 48,
        left: 16,
        right: 16,
      ),
      child: AppButton(
        buttonColor: Theme.of(context).primaryColor,
        text: '退出',
        onPressed: vm.isLogin
            ? () {
                vm.logout(context);
              }
            : null,
      ),
    );
  }

  Widget _buildLogInWidget(MyViewModule vm, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 48),
      child: AppButton(
        buttonColor: Theme.of(context).primaryColor,
        text: '登陆/注册',
        onPressed: !vm.isLogin
            ? () {
                RouterUtil.pushName(context, AppRouter.loginRouterName);
              }
            : null,
      ),
    );
  }

  String _getCollectNum(MyViewModule vm) {
    if (vm.webCollectModule != null || vm.articleCollectModule != null) {
      var webCollectCount = vm.webCollectModule?.webCollectDatas?.length ?? 0;
      var articleCollectCount = vm.articleCollectModule?.articleCollectData?.total ?? 0;
      var total = webCollectCount + articleCollectCount;
      return '${total}';
    }
    return '0';
  }
}
