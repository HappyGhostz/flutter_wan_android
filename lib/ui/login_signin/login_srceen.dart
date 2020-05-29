import 'package:flutter/material.dart';
import 'package:flutterwanandroid/custom_widget/app_button.dart';
import 'package:flutterwanandroid/custom_widget/base_text_field.dart';
import 'package:flutterwanandroid/custom_widget/check_password_widget.dart';
import 'package:flutterwanandroid/custom_widget/fade_animation_widget.dart';
import 'package:flutterwanandroid/custom_widget/photo_hero.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_text_style.dart';
import 'package:flutterwanandroid/ui/login_signin/login_view_module.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key, this.viewModule}) : super(key: key);
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
                      _buildRememberAndComeBackPassword(),
                      const Spacer(),
                      _buildLoginButton(viewModule),
                      const SizedBox(height: 16.0),
                      _buildGoSignInWidget(viewModule),
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

  Widget _buildRememberAndComeBackPassword() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                child: CheckPasswordInfoWidget(
                  info: '记住密码',
                  initValue: true,
                ),
                onTap: () {},
              )
            ],
          ),
          Text(
            '忘记密码',
            style: AppTextStyle.caption(color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(LoginModuleView viewModule) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AppButton(
        text: '登陆',
        onPressed: viewModule.controllerPassWord.text.isNotEmpty ? () {} : null,
      ),
    );
  }

  Widget _buildGoSignInWidget(LoginModuleView viewModule) {
    return Padding(
      padding: EdgeInsets.only(top: 32.0, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '去注册',
            style: AppTextStyle.body(fontSize: 16.0, color: AppColors.white),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Card(
              shape: CircleBorder(),
              elevation: 2,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    viewModule.changeTheScreenType(false);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
