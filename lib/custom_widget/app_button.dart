import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

enum AppButtonType { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.textStyle,
    this.buttonColor,
    this.type = AppButtonType.primary,
    this.width,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final Function() onPressed;
  final AppButtonType type;
  final TextStyle textStyle;
  final Color buttonColor;
  final double width;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 48.0,
      minWidth: width ?? double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
        side: type == AppButtonType.secondary ? const BorderSide(color: AppColors.grey) : BorderSide.none,
      ),
      disabledColor: AppColors.lightGrey2,
      color: type == AppButtonType.secondary ? AppColors.white : buttonColor ?? AppColors.primary,
      onPressed: onPressed,
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              color: () {
                if (type == AppButtonType.secondary) {
                  return AppColors.grey;
                }
                return onPressed == null ? AppColors.lightGrey1 : AppColors.white;
              }(),
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
