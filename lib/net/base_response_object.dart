class BaseResponse {
  BaseResponse({
    this.data,
    this.errorCode,
    this.errorMsg,
  });

  dynamic data;
  String errorMsg;
  int errorCode;

  factory BaseResponse.fromJson(Map<String, dynamic> srcJson) {
    var baseResponse = BaseResponse();
    baseResponse.data = srcJson['data'];
    baseResponse.errorCode = srcJson['errorCode'] as int;
    baseResponse.errorMsg = srcJson['errorMsg'] as String;
    return baseResponse;
  }
}
