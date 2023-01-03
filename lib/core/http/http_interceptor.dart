import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart' as GetX;

/// 拦截器
class HttpInterceptors extends InterceptorsWrapper {
  final LoginController loginController = GetX.Get.put(LoginController());
  void appLogin(pwd) {
    Map<String, dynamic> data = {
      'username': 'admin',
      'password': utf8.decode(base64Decode(pwd)),
    };
    XHttp.get('/action/appLogin', data).then((res) {
      try {
        print("+++++++++++++");

        var d = json.decode(res.toString());
        print(d['token']);
        loginController.setSession(d['sessionid']);
        sharedAddAndUpdate("session", String, d['sessionid']);
        loginController.setToken(d['token']);
        sharedAddAndUpdate("token", String, d['token']);
        // print(d);
      } on FormatException catch (e) {
        print('----------');
        print(e);
      }
    }).catchError((onError) {});
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String token = loginController.login.token.value;
    String session = loginController.login.session.value;

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
    // 以 { 或者 [ 开头的
    RegExp exp = RegExp('^[{[]');
    if (!exp.hasMatch(response.data)) {
      appLogin(password);
    }
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
