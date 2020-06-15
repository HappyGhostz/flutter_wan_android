import 'package:flutterwanandroid/ui/web/redux/web_action.dart';
import 'package:flutterwanandroid/ui/web/redux/web_state.dart';
import 'package:redux/redux.dart';

final webReducer = combineReducers<WebState>([
  TypedReducer<WebState, ChangeProgressStatusAction>(_changeProgressStatusActionReducer),
]);

WebState _changeProgressStatusActionReducer(WebState state, ChangeProgressStatusAction action) {
  return state.clone()..isShowProgress = action.progressStatus;
}
