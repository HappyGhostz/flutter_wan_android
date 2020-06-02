import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/app_button.dart';
import 'package:flutterwanandroid/custom_widget/dialog/dialog.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({
    Key key,
    @required this.content,
    @required this.onClick,
  }) : super(key: key);
  final String content;
  final Function() onClick;

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
        content,
        style: greyBody2,
      ),
      contentPaddingTop: 16.0,
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    var actions = <Widget>[];
    var button = Theme.of(context).textTheme.button.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16);
    actions.add(Padding(
      padding: EdgeInsets.only(
        top: 16,
      ),
      child: AppButton(
        buttonColor: AppColors.primary,
        text: '确定',
        onPressed: () {
          Navigator.maybePop(context);
          onClick();
        },
        textStyle: button,
      ),
    ));
    return actions;
  }
}
