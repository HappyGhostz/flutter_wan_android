library linear_loading_indicator;

import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

part 'linear_loading_indicator_line.dart';
part 'linear_loading_indicator_panel.dart';

const double _lineHeight = 8.0;

class LinearLoadingIndicator extends StatelessWidget {
  Widget get _divider => Container(
        height: _lineHeight,
        width: double.infinity,
        color: AppColors.greyLightExtreme,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
          child: _IndicatorPanel(),
        ),
        _divider,
        Container(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: _IndicatorPanel(),
        ),
        _divider,
        Container(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 64.0),
          child: _IndicatorPanel(),
        ),
      ],
    );
  }
}
