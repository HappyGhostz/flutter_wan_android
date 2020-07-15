import 'package:flutter/material.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/app_button.dart';
import 'package:flutterwanandroid/custom_widget/dialog/dialog.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/utils/router_utils.dart';

class LoginInfoDialog extends StatelessWidget {
  const LoginInfoDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var greyHead1 = Theme.of(context).textTheme.headline6.copyWith(color: AppColors.black, fontSize: 20);
    var greyBody2 = Theme.of(context).textTheme.bodyText2.copyWith(color: AppColors.grey, fontSize: 14, fontWeight: FontWeight.w400);
    return AppVerticalButtonDialog(
      title: Text(
        '提示',
        style: greyHead1,
      ),
      content: Text(
        '请先登录，才能查看内容哦!',
        style: greyBody2,
      ),
      contentPaddingTop: 16.0,
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    var minWidth = MediaQuery.of(context).size.width - 112;
    var actions = <Widget>[];
    actions.add(Padding(
      padding: EdgeInsets.only(
        top: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppButton(
            width: minWidth / 2,
            buttonColor: AppColors.primary,
            text: '取消',
            onPressed: () {
              Navigator.maybePop(context, [<String, String>{}]);
            },
          ),
          AppButton(
              width: minWidth / 2,
              text: '去登录',
              onPressed: () {
                Navigator.of(context).pop();
                RouterUtil.pushName(context, AppRouter.loginRouterName);
              }),
        ],
      ),
    ));
    return actions;
  }
}
