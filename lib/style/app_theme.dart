import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

ThemeData appThemeData = ThemeData(
  brightness: Brightness.light,
//  primaryColor: AppColors.primary60,
  canvasColor: AppColors.lightGrey4,
  highlightColor: Colors.transparent,
  splashColor: Colors.transparent,
  textTheme: TextTheme(
    headline6: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    bodyText2: TextStyle(fontSize: 14),
    // Text by default will inherit this style
    bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    caption: TextStyle(fontSize: 12),
    subtitle2: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    button: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
  ),
  buttonTheme: ButtonThemeData(
    padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    //adds padding inside the button
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //limits the touch area to the button area
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
    ),
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    focusColor: AppColors.primary,
  ),
  fontFamily: 'RegularScript',
  cursorColor: AppColors.primary,
);
