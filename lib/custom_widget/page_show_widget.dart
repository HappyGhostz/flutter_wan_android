import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/loading/empty_page.dart';
import 'package:flutterwanandroid/custom_widget/loading/linear_loading_indicator.dart';
import 'package:flutterwanandroid/custom_widget/loading/load_error_page.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

typedef RefreshCallback = Future<void> Function();

class PageLoadWidget extends StatelessWidget {
  PageLoadWidget({
    Key key,
    @required this.dataLoadStatus,
    this.tapGestureRecognizer,
    @required this.itemBuilder,
    @required this.itemCount,
    @required this.scrollController,
    @required this.onRefresh,
    this.separatorBuilder,
  }) : super(key: key);
  final DataLoadStatus dataLoadStatus;
  final Function() tapGestureRecognizer;
  final RefreshCallback onRefresh;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final int itemCount;
  final ScrollController scrollController;

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
      default:
        return _buildDataPage(dataLoadStatus, context);
    }
  }

  Widget _buildDataPage(DataLoadStatus dataLoadStatus, BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.white,
      child: _buildLoadingOrCompletedPage(dataLoadStatus),
      onRefresh: onRefresh,
    );
  }

  Widget _buildLoadingOrCompletedPage(DataLoadStatus dataLoadStatus) {
    switch (dataLoadStatus) {
      case DataLoadStatus.loading:
        return Container(
          child: Center(child: LinearLoadingIndicator()),
        );
      case DataLoadStatus.loadCompleted:
        return ListView.separated(
            controller: scrollController,
            itemBuilder: itemBuilder,
            separatorBuilder: separatorBuilder ??
                (context, index) {
                  return Divider(
                    height: 1,
                    color: AppColors.greyAc,
                  );
                },
            itemCount: itemCount);
      default:
        return Container(
          child: Center(child: LinearLoadingIndicator()),
        );
    }
  }
}
