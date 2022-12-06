import 'package:dio/dio.dart';

/// 拦截器
class HttpInterceptors extends InterceptorsWrapper{

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("\n================== 请求数据 ==========================");
    print("url = ${options.uri.toString()}");
    print("headers = ${options.headers}");
    print("params = ${options.data}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("\n================== 响应数据 ==========================");
    print("code = ${response.statusCode}");
    print("data = ${response.data}");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("\n================== 错误响应数据 ======================");
    print("type = ${err.type}");
    print("message = ${err.message}");
    print("stackTrace = ${err.error}");
    return super.onError(err, handler);
  }
}