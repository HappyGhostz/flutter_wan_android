import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwanandroid/net/base_response_object.dart';

abstract class AppAction {}

class AppHttpResponseAction {
  BaseResponse baseResponse;
}

class AppResponseErrorAction {
  BaseResponse baseResponse;
}

class UpdateSplashImgAction extends AppAction {
  UpdateSplashImgAction({this.img, this.famousSentence});

  String img;
  List<String> famousSentence;
}

class DioErrorAction extends AppAction {
  DioErrorAction({this.dioError, this.context});

  DioError dioError;
  BuildContext context;
}

class UnKnowExceptionAction extends AppAction {
  UnKnowExceptionAction({this.error, this.context});

  String error;
  BuildContext context;
}

class VerificationFailedAction extends AppAction {
  VerificationFailedAction({this.context});

  BuildContext context;
}

class ApiErrorAction extends AppAction {
  ApiErrorAction({this.context, this.errorMessage});

  BuildContext context;
  String errorMessage;
}

class HttpAction {
  Response response;
  DioError dioError;
  BuildContext context;
  String error;
  AppHttpResponseAction action;
  AppResponseErrorAction errorAction;
//  ThunkAction<AppState> customThunkAction;

  HttpAction({
    this.response,
    this.error,
    this.context,
    this.dioError,
    this.action,
    this.errorAction,
//    this.customThunkAction,
  });
}
