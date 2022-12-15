import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

/// 拦截器
class HttpInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint("\n================== 请求数据 ==========================");
    debugPrint("url = ${options.uri.toString()}");
    debugPrint("headers = ${options.headers}");
    debugPrint("params = ${options.data}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("\n================== 响应数据 ==========================");
    debugPrint("code = ${response.statusCode}");
    debugPrint("data = ${response.data}");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint("\n================== 错误响应数据 ======================");
    debugPrint("type = ${err.type}");
    debugPrint("message = ${err.message}");
    debugPrint("stackTrace = ${err.error}");
    return super.onError(err, handler);
  }
}
