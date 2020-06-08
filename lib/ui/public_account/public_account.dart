import 'package:flutter/cupertino.dart';
import 'package:flutterwanandroid/style/app_colors.dart';

class PublicAccountPage extends StatelessWidget {
//  PublicAccountPage({
//    Key key,
//  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColors.white,
      child: Center(
        child: Text('PublicAccount Page'),
      ),
    );
  }
}
