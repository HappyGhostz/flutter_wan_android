import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

// ignore_for_file: unused_field
class AppTextStyle {
  ///////////////////////////////////////////////////////////////////////////
  // Font weight
  ///////////////////////////////////////////////////////////////////////////

  static const FontWeight _lightWeight = FontWeight.w300;
  static const FontWeight _regularWeight = FontWeight.w400;
  static const FontWeight _mediumWeight = FontWeight.w500;
  static const FontWeight _boldWeight = FontWeight.w600;
  static const FontWeight _xBoldWeight = FontWeight.w900;

  ///////////////////////////////////////////////////////////////////////////
  // Font Size
  ///////////////////////////////////////////////////////////////////////////

  static const double _fontSizeExtraLarge = 32.0;
  static const double _fontSizeLarge = 24.0;
  static const double _fontSizeMedium = 20.0;
  static const double _fontSizeRegular = 16.0;
  static const double _fontSizeSmall = 14.0;
  static const double _fontSizeExtraSmall = 12.0;
  static const double _fontSizeMediumSmall = 10.0;

  ///////////////////////////////////////////////////////////////////////////
  //Type Styles
  ///////////////////////////////////////////////////////////////////////////

  static TextStyle sectionHeading() => TextStyle(
        fontWeight: _mediumWeight,
        fontSize: _fontSizeRegular,
        color: AppColors.grey,
      );

  static TextStyle hintText({double fontSize = 14.0, Color color = AppColors.lightGrey1}) => TextStyle(
        color: color,
        fontSize: fontSize,
      );

  static TextStyle _body1(
          {double fontSize = _fontSizeExtraSmall,
          Color color = AppColors.lightGrey1,
          FontWeight fontWeight = _mediumWeight,
          String fontFamily = 'RegularScript',
          FontStyle fontStyle = FontStyle.normal}) =>
      TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: fontFamily,
        fontStyle: fontStyle,
        fontWeight: fontWeight,
      );

  static TextStyle body(
          {double fontSize = _fontSizeRegular,
          Color color = AppColors.lightGrey1,
          FontWeight fontWeight = _mediumWeight,
          String fontFamily,
          FontStyle fontStyle = FontStyle.normal}) =>
      _body1(fontSize: fontSize, color: color, fontWeight: fontWeight, fontFamily: fontFamily, fontStyle: fontStyle);

  static TextStyle liShuBody() {
    return _body1(fontSize: _fontSizeLarge, color: AppColors.black, fontWeight: _mediumWeight, fontFamily: 'Lishu');
  }

  static TextStyle caption({Color color = AppColors.black, TextDecoration decoration}) =>
      TextStyle(fontWeight: _regularWeight, fontSize: _fontSizeExtraSmall, color: color, decoration: decoration ?? TextDecoration.none);

  static TextStyle body2({Color color = AppColors.black}) => TextStyle(fontWeight: _regularWeight, fontSize: _fontSizeSmall, color: color);
}
