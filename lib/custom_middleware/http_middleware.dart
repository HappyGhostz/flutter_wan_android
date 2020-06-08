import 'package:flutterwanandroid/app_redux/app_action.dart';
import 'package:flutterwanandroid/app_redux/app_state.dart';
import 'package:flutterwanandroid/net/base_response_object.dart';
import 'package:redux/redux.dart';

void httpMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is HttpAction) {
    if (action.dioError != null) {
      store.dispatch(DioErrorAction(dioError: action.dioError, context: action.context));
    } else if (action.error != null) {
      store.dispatch(UnKnowExceptionAction(error: action.error, context: action.context));
    } else if (action.response != null) {
      var response = action.response;
      if (response.data != null) {
        var source = response.data as Map<String, dynamic>;
        var baseResponse = BaseResponse.fromJson(source);
        if (baseResponse.errorCode == -1001) {
          store.dispatch(VerificationFailedAction(context: action.context));
        } else if (baseResponse.errorCode != 0) {
          if (action.errorAction != null) {
            store.dispatch(action.errorAction);
          } else {
            store.dispatch(ApiErrorAction(errorMessage: baseResponse.errorMsg, context: action.context));
          }
        } else {
          if (action.action != null) {
            if (action.action is AppHttpResponseAction) {
              store.dispatch(action.action);
            } else {
              store.dispatch(action.action);
            }
          }
        }
      } else {
        next(action);
      }
    }
  } else {
    next(action);
  }
}
