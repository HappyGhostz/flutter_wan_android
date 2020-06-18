import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/app_button.dart';
import 'package:flutterwanandroid/custom_widget/base_text_field.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';
import 'package:flutterwanandroid/utils/data_utils.dart';

typedef EditSaveCallBack = Function(String title, String content, String time);

class EditDialog extends StatefulWidget {
  EditDialog({
    Key key,
    this.title,
    this.editItemTitle,
    this.content,
    this.dateTime,
    this.callBack,
  }) : super(key: key);
  final String title;
  final String editItemTitle;
  final String content;
  final String dateTime;
  final EditSaveCallBack callBack;

  @override
  State<StatefulWidget> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  TextEditingController titleController;
  TextEditingController detailController;
  TextEditingController timeController;
  FocusNode titleFocusNode;
  FocusNode detailFocusNode;
  FocusNode timeFocusNode;

  String errorInfo = '';

  @override
  void initState() {
    titleController = TextEditingController();
    detailController = TextEditingController();
    timeController = TextEditingController();
    titleFocusNode = FocusNode();
    detailFocusNode = FocusNode();
    timeFocusNode = FocusNode();

    timeController.text = widget.dateTime ?? DataUtil.todayStr() ?? '';
    titleController.text = widget.editItemTitle ?? '';
    detailController.text = widget.content ?? '';
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    detailController.dispose();
    timeController.dispose();
    titleFocusNode.dispose();
    detailFocusNode.dispose();
    timeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, viewportConstraints) {
      return Container(
        margin: MediaQuery.of(context).viewInsets,
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Center(
          child: SingleChildScrollView(
            child: IntrinsicHeight(
              child: Material(
                elevation: 24.0,
                color: Colors.white,
                type: MaterialType.card,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      _buildTitleAndCloseWidget(context),
                      Divider(
                        height: 1,
                        color: AppColors.lightGrey1,
                      ),
                      _buildEditTitle(context),
                      _buildDetailWidget(context),
                      _buildTimeWidget(context),
                      errorInfo.isNotEmpty ? _buildErrorInfo() : Container(),
                      _buildButton(context, viewportConstraints.minWidth - 112),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTitleAndCloseWidget(BuildContext context) {
    var greyHead1 = Theme.of(context).textTheme.headline6.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: 20,
        );
    return Padding(
      padding: EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            widget.title ?? 'data',
            style: greyHead1,
          )),
          IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).maybePop([<String, String>{}]);
              }),
        ],
      ),
    );
  }

  Widget _buildEditTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '标题',
            style: AppTextStyle.caption(fontSize: 18, color: AppColors.grey),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(
              left: 16,
            ),
            child: AppBassTextField(
              controller: titleController,
              focusNode: titleFocusNode,
              textInputAction: TextInputAction.next,
              primaryColor: Theme.of(context).primaryColor,
              customizedInputDecoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
              ),
              textStyle: AppTextStyle.body(fontSize: 14),
              onSubmitted: (value) {
                detailFocusNode.requestFocus();
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildDetailWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '详情',
            style: AppTextStyle.caption(fontSize: 18, color: AppColors.grey),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(
              left: 16,
            ),
            child: AppBassTextField(
              controller: detailController,
              focusNode: detailFocusNode,
              textInputAction: TextInputAction.next,
              primaryColor: Theme.of(context).primaryColor,
              customizedInputDecoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
              ),
              textStyle: AppTextStyle.body(fontSize: 14),
              textInputType: TextInputType.multiline,
              minLines: 1,
              onSubmitted: (value) {
                timeFocusNode.requestFocus();
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTimeWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '时间',
            style: AppTextStyle.caption(fontSize: 18, color: AppColors.grey),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(
              left: 16,
            ),
            child: AppBassTextField(
              controller: timeController,
              focusNode: timeFocusNode,
              textInputAction: TextInputAction.done,
              primaryColor: Theme.of(context).primaryColor,
              customizedInputDecoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
              ),
              textStyle: AppTextStyle.body(fontSize: 14),
              textInputType: TextInputType.text,
              minLines: 1,
              maxLines: 1,
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildErrorInfo() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Text(
        errorInfo,
        style: AppTextStyle.body(fontSize: 16, color: AppColors.warning),
      ),
    );
  }

  Widget _buildButton(BuildContext context, double minWidth) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
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
              text: '保存',
              onPressed: () {
                if (titleController.text.isEmpty || timeController.text.isEmpty) {
                  errorInfo = '标题或时间不能为空！';
                  setState(() {});
                } else {
                  var resultParam = <String, String>{
                    editTitleKey: titleController.text,
                    editContentKey: detailController.text,
                    editTimeKey: timeController.text,
                  };
                  Navigator.of(context).maybePop([resultParam]);
                }
              }),
        ],
      ),
    );
  }
}
