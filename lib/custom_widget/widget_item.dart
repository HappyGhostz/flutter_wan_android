import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';

class WidgetItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final int index; //用于计算border
  final int totalCount;
  final int rowLength;

  WidgetItem({
    this.title,
    this.onTap,
    this.index,
    this.totalCount,
    this.rowLength,
  });

  Border _buildBorder(BuildContext context) {
    Border _border;
    var isRight = (index % rowLength) == (rowLength - 1); //是不是最右边的,决定是否有右侧边框
    var currentRow = (index + 1) % rowLength > 0 ? (index + 1) ~/ rowLength + 1 : (index + 1) ~/ rowLength;
    var totalRow = totalCount % rowLength > 0 ? totalCount ~/ rowLength + 1 : totalCount ~/ rowLength;
    if (currentRow < totalRow && isRight) {
      //不是最后一行,是最右边
      _border = Border(
        bottom: const BorderSide(width: 1.0, color: AppColors.greyAc),
      );
    }
    if (currentRow < totalRow && !isRight) {
      _border = Border(
        right: const BorderSide(width: 1.0, color: AppColors.greyAc),
        bottom: const BorderSide(width: 1.0, color: AppColors.greyAc),
      );
    }
    if (currentRow == totalRow && !isRight) {
      _border = Border(
        right: const BorderSide(width: 1.0, color: AppColors.greyAc),
      );
    }
    return _border;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: _buildBorder(context),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Center(
          child: SizedBox(
            height: 60,
            width: 60,
            child: Text(
              title ?? '',
              style: AppTextStyle.head(color: Theme.of(context).primaryColor, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
