import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_template/pages/login/login_controller.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GetX;

/// 拦截器
class HttpInterceptors extends InterceptorsWrapper {
  final LoginController loginController = GetX.Get.put(LoginController());

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String token = loginController.login.token.value;
    String session = loginController.login.session.value;
    // String token = 'd302214d-b02c-4abe-933d-c530b604c9d1';
    // String session = '::webs.session::a9296e73e3daf429d402074990f1363d';
    Map<String, dynamic> header = {
      "Cookie": '-goahead-session-=$session; token=$token'
    };
    options.headers = header;
    options.path = '${options.uri.toString()}&_csrf_token=$token';
    options.queryParameters = {};
    debugPrint("\n================== 请求数据 ==========================");
    debugPrint("url = ${options.uri.toString()}");
    debugPrint("headers = ${options.headers}");
    debugPrint("params = ${options.data}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String isSn = loginController.isSn.value;
    String password = '';
    // debugPrint("\n================== issn ==========================");
    // debugPrint(isSn);
    if (isSn != '') {
      password = loginController.sn[isSn.toString()];
      // debugPrint(password);
    }
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
    debugPrint("response = ${err.response}");
    return super.onError(err, handler);
  }
}
