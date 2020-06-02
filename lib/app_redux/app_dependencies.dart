import 'package:shared_preferences/shared_preferences.dart';

class AppDependency {
  AppDependency({this.sharedPreferences});

  SharedPreferences sharedPreferences;
}
