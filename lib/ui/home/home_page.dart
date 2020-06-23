import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/app_router.dart';
import 'package:flutterwanandroid/custom_widget/photo_hero.dart';
import 'package:flutterwanandroid/style/app_colors.dart';
import 'package:flutterwanandroid/style/app_theme.dart';
import 'package:flutterwanandroid/ui/home/home_view_module.dart';
import 'package:flutterwanandroid/ui/to_do_page/to_do_screen.dart';

const double _fabDimension = 56.0;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeViewModule>(
      converter: HomeViewModule.fromStore,
      onInit: (store) {
        store.state.homeState.currentIndex = 0;
      },
      builder: (context, viewModule) {
        return Scaffold(
          appBar: AppBar(
            title: Text(getCurrentPageAppTitle(viewModule)),
            actions: <Widget>[
              SearchHero(
                width: 30.0,
                search: "search",
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.search);
                },
              ),
            ],
          ),
          body: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: viewModule.pageController,
              itemCount: getPages().length,
              itemBuilder: (context, index) {
                return getPages()[index];
              }),
          bottomNavigationBar: Theme(
            data: appThemeData.copyWith(canvasColor: AppColors.white),
            child: BottomNavigationBar(
              currentIndex: viewModule.currentIndex,
              onTap: (newIndex) {
                viewModule.pageController.animateToPage(newIndex, duration: Duration(milliseconds: 500), curve: Curves.ease);
//                viewModule.pageController.jumpToPage(newIndex);
                viewModule.changeNextPage(newIndex);
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('首页'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.open_in_new),
                  title: Text('公众号'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.navigation),
                  title: Text('导航'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pets),
                  title: Text('我的'),
                ),
              ],
            ),
          ),
          floatingActionButton: OpenContainer(
            transitionType: ContainerTransitionType.fade,
            openBuilder: (BuildContext context, VoidCallback _) {
              return ToDoScreen();
            },
            closedElevation: 6.0,
            closedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(_fabDimension / 2),
              ),
            ),
            closedColor: Theme.of(context).primaryColor,
            closedBuilder: (BuildContext context, VoidCallback openContainer) {
              return SizedBox(
                height: _fabDimension,
                width: _fabDimension,
                child: Center(
                  child: Icon(
                    Icons.border_color,
                    color: AppColors.white,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
