import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/app_button.dart';
import 'package:flutterwanandroid/custom_widget/base_text_field.dart';
import 'package:flutterwanandroid/custom_widget/fade_animation_widget.dart';
import 'package:flutterwanandroid/custom_widget/photo_hero.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/login_signin/login_view_module.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({Key key, this.viewModule}) : super(key: key);
  final LoginModuleView viewModule;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          'assets/login_background.jpeg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
        LayoutBuilder(builder: (context, viewportConstraints) {
          return Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: viewportConstraints.maxWidth, minHeight: viewportConstraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTopRowWidget(viewModule),
                      const SizedBox(height: 60.0),
                      _buildUserName(viewModule),
                      const SizedBox(height: 16.0),
                      _buildPassword(viewModule),
                      const SizedBox(height: 16.0),
                      _buildConfirmPassword(viewModule),
                      const Spacer(),
                      _buildLoginButton(viewModule),
                      const SizedBox(height: 16.0),
                      _buildGoLoginWidget(viewModule),
                    ],
                  ),
                ),
              ),
            ),
          );
        })
      ],
    );
  }

  Row _buildTopRowWidget(LoginModuleView viewModule) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Card(
            elevation: 2,
            shape: CircleBorder(),
            child: ClipOval(
              child: Center(
                child: ClipRect(
                  child: HeroPhoto(
                    photo: viewModule.icon,
                    width: 120,
                    height: 120,
                    fit: BoxFit.fitWidth,
                  ), // Photo
                ),
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16),
              child: FadeAnimationWidget(
                child: Text(
                  viewModule.famousSentence[0],
                  style: AppTextStyle.liShuBody(),
                  maxLines: 2,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16, left: 16),
              child: FadeAnimationWidget(
                child: Text(
                  viewModule.famousSentence[1],
                  style: AppTextStyle.liShuBody(),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPassword(LoginModuleView viewModule) {
    return Container(
      padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
      child: Column(
        children: <Widget>[
          AppBassTextField.password(
            isShowPassword: viewModule.isShowPassword,
            controller: viewModule.controllerPassWord,
            focusNode: viewModule.editPasswordFocusNode,
            prefixIconColor: viewModule.editPasswordFocusNode.hasFocus ? AppColors.white : AppColors.greyLightMild,
            suffixIconColor: AppColors.white,
            hintText: '密码',
            hintTextStyle: AppTextStyle.body2(color: AppColors.greyLightMild),
            labelText: '密码',
            textStyle: AppTextStyle.body2(color: AppColors.white),
            textInputAction: TextInputAction.done,
            primaryColor: AppColors.white,
            onChanged: (value) {},
            showPasswordCallback: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildUserName(LoginModuleView viewModule) {
    return Padding(
      key: const Key('usernameTextField'),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBassTextField.userName(
        focusNode: viewModule.usernameFocusNode,
        errorTextStyle: AppTextStyle.caption(color: AppColors.warning),
        controller: viewModule.controllerUsername,
        primaryColor: AppColors.white,
        prefixIconColor: viewModule.usernameFocusNode.hasFocus ? AppColors.white : AppColors.greyLightMild,
        hintText: '请输入昵称',
        hintTextStyle: AppTextStyle.body2(color: AppColors.greyLightMild),
        textStyle: AppTextStyle.body2(color: AppColors.white),
        textInputAction: TextInputAction.next,
        labelText: '昵称',
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildConfirmPassword(LoginModuleView viewModule) {
    return Container(
      padding: const EdgeInsets.only(top: 0.0, left: 16.0, right: 16.0),
      child: Column(
        children: <Widget>[
          AppBassTextField.password(
            isShowPassword: viewModule.isShowPassword,
            controller: viewModule.controllerConfirmPassWord,
            focusNode: viewModule.editConfirmPasswordFocusNode,
            prefixIconColor: viewModule.editConfirmPasswordFocusNode.hasFocus ? AppColors.white : AppColors.greyLightMild,
            suffixIconColor: AppColors.white,
            hintText: '确认密码',
            hintTextStyle: AppTextStyle.body2(color: AppColors.greyLightMild),
            labelText: '确认密码',
            textStyle: AppTextStyle.body2(color: AppColors.white),
            textInputAction: TextInputAction.done,
            primaryColor: AppColors.white,
            onChanged: (value) {},
            showPasswordCallback: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(LoginModuleView viewModule) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AppButton(
        text: '注册',
        onPressed: viewModule.controllerConfirmPassWord.text.isNotEmpty ? () {} : null,
      ),
    );
  }

  Widget _buildGoLoginWidget(LoginModuleView viewModule) {
    return Padding(
      padding: EdgeInsets.only(top: 32.0, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Card(
              shape: CircleBorder(),
              elevation: 2,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    viewModule.changeTheScreenType(true);
                  }),
            ),
          ),
          Text(
            '去登陆',
            style: AppTextStyle.body(fontSize: 16.0, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
