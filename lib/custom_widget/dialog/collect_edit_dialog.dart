import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/app_button.dart';
import 'package:flutterwanandroid/custom_widget/base_text_field.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

typedef EditSaveCallBack = Function(String title, String content, String time);

class CollectEditDialog extends StatefulWidget {
  CollectEditDialog({
    Key key,
    this.editInfo,
    this.title,
    this.author,
    this.content,
    this.callBack,
  }) : super(key: key);
  final String editInfo;
  final String title;
  final String author;
  final String content;
  final EditSaveCallBack callBack;

  @override
  State<StatefulWidget> createState() => _CollectEditDialogState();
}

class _CollectEditDialogState extends State<CollectEditDialog> {
  TextEditingController titleController;
  TextEditingController detailController;
  TextEditingController authorController;
  FocusNode titleFocusNode;
  FocusNode detailFocusNode;
  FocusNode authorFocusNode;

  String errorInfo = '';

  @override
  void initState() {
    titleController = TextEditingController();
    detailController = TextEditingController();
    authorController = TextEditingController();
    titleFocusNode = FocusNode();
    detailFocusNode = FocusNode();
    authorFocusNode = FocusNode();

    detailController.text = widget.content ?? '';
    titleController.text = widget.title ?? '';
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    detailController.dispose();
    authorController.dispose();
    titleFocusNode.dispose();
    detailFocusNode.dispose();
    authorFocusNode.dispose();
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
                      _buildAuthorWidget(context),
                      _buildDetailWidget(context),
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
            widget.editInfo ?? '编辑',
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
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          ),
          textStyle: AppTextStyle.body(fontSize: 14),
          onSubmitted: (value) {
            authorFocusNode.requestFocus();
          },
        ),
      ),
    );
  }

  Widget _buildDetailWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
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
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          ),
          textStyle: AppTextStyle.body(fontSize: 14),
          textInputType: TextInputType.multiline,
          minLines: 1,
          onSubmitted: (value) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
        ),
      ),
    );
  }

  Widget _buildAuthorWidget(BuildContext context) {
    if (widget.author == null) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
        ),
        child: AppBassTextField(
          controller: authorController,
          focusNode: authorFocusNode,
          textInputAction: TextInputAction.done,
          primaryColor: Theme.of(context).primaryColor,
          customizedInputDecoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0)),
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          ),
          textStyle: AppTextStyle.body(fontSize: 14),
          textInputType: TextInputType.text,
          minLines: 1,
          maxLines: 1,
          onSubmitted: (value) {
            detailFocusNode.requestFocus();
          },
        ),
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
                if (titleController.text.isEmpty ||
                    (widget.author != null && authorController.text.isEmpty) ||
                    detailController.text.isEmpty) {
                  errorInfo = '内容不能为空！';
                  setState(() {});
                } else {
                  var resultParam = <String, String>{
                    editTitleKey: titleController.text,
                    editContentKey: detailController.text,
                    editTimeKey: authorController.text ?? '',
                  };
                  Navigator.of(context).maybePop([resultParam]);
                }
              }),
        ],
      ),
    );
  }
}
