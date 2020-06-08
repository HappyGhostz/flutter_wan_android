import 'package:flutterwanandroid/ui/home/redux/home_action.dart';
import 'package:flutterwanandroid/ui/home/redux/home_state.dart';
import 'package:redux/redux.dart';

final homeReducer = combineReducers<HomeState>([
  TypedReducer<HomeState, CurrentPageAction>(_currentPageActionReducer),
]);

HomeState _currentPageActionReducer(HomeState state, CurrentPageAction action) {
  return state.clone()..currentIndex = action.currentIndex;
}
