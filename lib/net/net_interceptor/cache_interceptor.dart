import 'package:dio/dio.dart';
import 'package:flutterwanandroid/utils/constent_utils.dart';

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  final _cache = <Uri, Response>{};

  @override
  Future onRequest(RequestOptions options) async {
    var response = _cache[options.uri];
    if (options.extra[refreshCacheResponse] == true) {
      return options;
    } else if (response != null) {
      return response;
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    _cache[response.request.uri] = response;
  }

  @override
  Future onError(DioError e) async {
    print('onError: $e');
  }
}
