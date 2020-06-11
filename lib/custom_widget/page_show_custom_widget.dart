import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/loading/empty_page.dart';
import 'package:flutterwanandroid/custom_widget/loading/linear_loading_indicator.dart';
import 'package:flutterwanandroid/custom_widget/loading/load_error_page.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class CustomPageLoadWidget extends StatelessWidget {
  CustomPageLoadWidget({
    Key key,
    @required this.dataLoadStatus,
    this.tapGestureRecognizer,
    @required this.child,
  }) : super(key: key);
  final DataLoadStatus dataLoadStatus;
  final Function() tapGestureRecognizer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    switch (dataLoadStatus) {
      case DataLoadStatus.failure:
        return Container(
          child: Center(
            child: ErrorPage(
              tapGestureRecognizer: TapGestureRecognizer()..onTap = tapGestureRecognizer,
            ),
          ),
        );
      case DataLoadStatus.empty:
        return Container(
          child: Center(
            child: EmptyPage(
              tapGestureRecognizer: TapGestureRecognizer()..onTap = tapGestureRecognizer,
            ),
          ),
        );
      case DataLoadStatus.loading:
        return Container(
          child: Center(child: LinearLoadingIndicator()),
        );
      case DataLoadStatus.loadCompleted:
        return child;
      default:
        return Container(
          child: Center(child: LinearLoadingIndicator()),
        );
    }
  }
}
