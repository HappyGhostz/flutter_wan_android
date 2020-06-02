import 'package:flutter/material.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
/*
* log in input
*
* example
*
* AppBassTextField.userName(
                  errorText: errorText,
                  hintText: "Enter Username",
                  primaryColor: AppColors.color,
                  helperText: 'At least 8 characters',
                  helperTextStyle: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFF9A9A9A),
                    wordSpacing: 4,
                  ),
                  hintTextStyle:
                      TextStyle(wordSpacing: 6.0, fontSize: 14.0, color: Color(0xFF9A9A9A), textBaseline: TextBaseline.ideographic),
                  textStyle: TextStyle(fontSize: 14.0, color: Colors.black, textBaseline: TextBaseline.ideographic),
                  onChanged: (value) {
                    ///do something
                  })
*
*
*
*
* */

typedef ValueChanged<String> = void Function(String value);

// ignore: must_be_immutable
class AppBassTextField extends StatelessWidget {
  AppBassTextField(
      {Key key,
      this.textInputType,
      this.textStyle,
      this.onChanged,
      this.primaryColor,
      this.onSubmitted,
      this.maxLength,
      this.obscureText,
      this.errorText,
      this.hintText,
      this.helperText,
      this.errorTextStyle,
      this.hintTextStyle,
      this.helperTextStyle,
      this.controller,
      this.focusNode,
      this.textInputAction,
      this.textCapitalization,
      this.customizedInputDecoration,
      this.isShowPassword,
      this.showPasswordCallback,
      this.labelText,
      this.labelTextStyle,
      this.enabled,
      this.prefixIconColor,
      this.suffixIconColor,
      this.prefix})
      : super(key: key);

  AppBassTextField.password(
      {@required this.focusNode,
      this.textStyle,
      this.onChanged,
      this.primaryColor,
      this.onSubmitted,
      this.errorText,
      this.hintText,
      this.helperText,
      this.errorTextStyle,
      this.hintTextStyle,
      this.helperTextStyle,
      this.controller,
      this.textInputAction,
      this.textCapitalization,
      this.isShowPassword,
      this.showPasswordCallback,
      this.labelText,
      this.labelTextStyle,
      this.prefixIconColor,
      this.suffixIconColor,
      this.enabled})
      : customizedInputDecoration = InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: primaryColor ?? AppColors.primary, width: 1.0)),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: prefixIconColor ?? AppColors.greyAc,
          ),
          focusedErrorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          errorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          suffixIcon: IconButton(
              icon: Icon(
                isShowPassword ? Icons.visibility : Icons.visibility_off,
                color: suffixIconColor ?? AppColors.primary,
              ),
              onPressed: showPasswordCallback == null ? () {} : showPasswordCallback),
        ),
        textInputType = TextInputType.text,
        obscureText = isShowPassword,
        maxLength = null;

  AppBassTextField.passwordUnderline({
    @required this.focusNode,
    this.textStyle,
    this.onChanged,
    this.primaryColor,
    this.onSubmitted,
    this.errorText,
    this.hintText,
    this.helperText,
    this.errorTextStyle,
    this.hintTextStyle,
    this.helperTextStyle,
    this.controller,
    this.textInputAction,
    this.textCapitalization,
    this.isShowPassword,
    this.showPasswordCallback,
    this.labelText,
    this.labelTextStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.enabled,
  })  : customizedInputDecoration = InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: primaryColor ?? AppColors.primary, width: 1.0)),
          focusedErrorBorder:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          errorBorder:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          suffixIcon: focusNode.hasFocus
              ? IconButton(
                  icon: Icon(
                    isShowPassword ? Icons.visibility : Icons.visibility_off,
                    color: suffixIconColor ?? AppColors.primary,
                  ),
                  onPressed: showPasswordCallback == null ? () {} : showPasswordCallback)
              : null,
        ),
        textInputType = TextInputType.text,
        obscureText = !isShowPassword,
        maxLength = null;

  AppBassTextField.userName({
    this.textStyle,
    this.onChanged,
    this.primaryColor,
    this.onSubmitted,
    this.errorText,
    this.hintText,
    this.helperText,
    this.errorTextStyle,
    this.hintTextStyle,
    this.helperTextStyle,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization,
    this.isShowPassword,
    this.showPasswordCallback,
    this.labelText,
    this.labelTextStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.enabled,
  })  : customizedInputDecoration = InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: primaryColor ?? AppColors.primary, width: 1.0)),
          focusedErrorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          errorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          prefixIcon: Icon(
            Icons.account_circle,
            color: prefixIconColor ?? AppColors.white,
          ),
        ),
        textInputType = TextInputType.text,
        obscureText = false,
        maxLength = null;

  AppBassTextField.usernameUnderline({
    this.textStyle,
    this.onChanged,
    this.primaryColor,
    this.onSubmitted,
    this.errorText,
    this.hintText,
    this.helperText,
    this.errorTextStyle,
    this.hintTextStyle,
    this.helperTextStyle,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization,
    this.isShowPassword,
    this.showPasswordCallback,
    this.labelText,
    this.labelTextStyle,
    this.enabled,
    this.prefixIconColor,
    this.suffixIconColor,
    this.prefix,
  })  : customizedInputDecoration = InputDecoration(
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor ?? AppColors.primary, width: 1.0)),
          focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          prefix: prefix,
        ),
        textInputType = TextInputType.text,
        obscureText = false,
        maxLength = null;

  AppBassTextField.noIcon({
    this.textStyle,
    this.onChanged,
    this.primaryColor,
    this.onSubmitted,
    this.errorText,
    this.obscureText,
    this.hintText,
    this.helperText,
    this.errorTextStyle,
    this.hintTextStyle,
    this.helperTextStyle,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization,
    this.isShowPassword,
    this.showPasswordCallback,
    this.labelText,
    this.labelTextStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.enabled,
  })  : customizedInputDecoration = InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: primaryColor ?? AppColors.primary, width: 1.0)),
          focusedErrorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          errorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
        ),
        textInputType = TextInputType.text,
        maxLength = null;

  AppBassTextField.enterEmail({
    this.textStyle,
    this.onChanged,
    this.primaryColor,
    this.onSubmitted,
    this.errorText,
    this.obscureText,
    this.hintText,
    this.helperText,
    this.errorTextStyle,
    this.hintTextStyle,
    this.helperTextStyle,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization,
    this.isShowPassword,
    this.showPasswordCallback,
    this.labelText,
    this.labelTextStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.enabled,
  })  : customizedInputDecoration = InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: primaryColor ?? AppColors.primary, width: 1.0)),
          focusedErrorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          errorBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          prefixIcon: Icon(
            Icons.email,
            color: AppColors.greyAc,
          ),
        ),
        textInputType = TextInputType.text,
        maxLength = null;

  AppBassTextField.enterEmailUnderline({
    this.textStyle,
    this.onChanged,
    this.primaryColor,
    this.onSubmitted,
    this.errorText,
    this.obscureText,
    this.hintText,
    this.helperText,
    this.errorTextStyle,
    this.hintTextStyle,
    this.helperTextStyle,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.textCapitalization,
    this.isShowPassword,
    this.showPasswordCallback,
    this.labelText,
    this.labelTextStyle,
    this.prefixIconColor,
    this.suffixIconColor,
    this.enabled,
  })  : customizedInputDecoration = InputDecoration(
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.greyAc, width: 1.0)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor ?? AppColors.primary, width: 1.0)),
          focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
          errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.warning, width: 1.0)),
        ),
        textInputType = TextInputType.text,
        maxLength = null;

  final int maxLength;
  Color primaryColor;
  final TextInputType textInputType;
  final TextStyle textStyle;
  final TextStyle errorTextStyle;
  final TextStyle hintTextStyle;
  final TextStyle helperTextStyle;
  final String errorText;
  final String hintText;
  final String helperText;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final InputDecoration customizedInputDecoration;
  final bool isShowPassword;
  final VoidCallback showPasswordCallback;
  final String labelText;
  final TextStyle labelTextStyle;
  final bool enabled;
  final Color prefixIconColor;
  final Color suffixIconColor;
  Widget prefix;

  @override
  Widget build(BuildContext context) {
    primaryColor ??= AppColors.primary;

    return Container(
      child: Column(
        children: <Widget>[
          _buildInputText(),
        ],
      ),
    );
  }

  Widget _buildInputText() {
    return Theme(
        data: ThemeData(primaryColor: primaryColor),
        child: TextField(
            enabled: enabled,
            focusNode: focusNode,
            controller: controller,
            key: key,
            keyboardType: textInputType,
            textInputAction: textInputAction,
            autofocus: false,
            maxLength: maxLength,
            maxLines: 1,
            cursorColor: primaryColor,
            cursorRadius: const Radius.circular(20.0),
            cursorWidth: 1.0,
            style: textStyle ?? AppTextStyle.body2(color: AppColors.lightGrey1),
            obscureText: obscureText ?? false,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: customizedInputDecoration.copyWith(
                  errorText: errorText,
                  errorStyle: errorTextStyle,
                  labelText: labelText,
                  labelStyle: labelTextStyle ?? const TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
                  hintText: labelText == null ? hintText : null,
                  hintStyle: hintTextStyle ?? AppTextStyle.body2(color: AppColors.greyLightMild),
                  helperText: helperText,
                  helperStyle: helperTextStyle ?? AppTextStyle.caption(color: AppColors.greyLightMild),
                  counter: errorText == null ? null : _buildErrorCounter(errorText, errorTextStyle),
                ) ??
                InputDecoration(
                  errorText: errorText,
                  errorStyle: errorTextStyle,
                  labelText: labelText,
                  labelStyle: labelTextStyle ?? const TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
                  hintText: labelText == null ? hintText : null,
                  hintStyle: hintTextStyle ?? AppTextStyle.body2(color: AppColors.greyLightMild),
                  helperText: helperText,
                  helperStyle: helperTextStyle ?? AppTextStyle.caption(color: AppColors.greyLightMild),
                  counter: errorText == null ? null : _buildErrorCounter(errorText, errorTextStyle),
                )));
  }

  Widget _buildErrorCounter(String errorText, TextStyle errorTextStyle) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              errorText,
              style: errorTextStyle ?? AppTextStyle.caption(color: AppColors.warning),
            ),
          ),
        ),
        Icon(
          Icons.error,
          color: AppColors.warning,
          size: 16.0,
        )
      ],
    );
  }
}
