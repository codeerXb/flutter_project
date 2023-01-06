import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GetX;
import 'package:flutter_template/pages/login/model/exception_login.dart';
import '../../core/utils/toast.dart';

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
        debugPrint("++++++relogin+++++++");

        var d = json.decode(res.toString());
        loginController.setSession(d['sessionid']);
        sharedAddAndUpdate("session", String, d['sessionid']);
        loginController.setToken(d['token']);
        sharedAddAndUpdate("token", String, d['token']);
        // print(d);
      } on FormatException catch (e) {
        debugPrint('-----get loginRes FormatException-----');
        debugPrint(e.toString());
      }
    }).catchError((err) {
      if (err.response != null) {
        var resjson = json.decode(err.response.toString());
        var errRes = ExceptionLogin.fromJson(resjson);
        if (errRes.success == false) {
          GetX.Get.offNamed('/loginPage');
          if (errRes.code == 201) {
            ToastUtils.toast('密码错误');
          } else if (errRes.code == 202) {
            ToastUtils.error('已锁定，${errRes.webLoginRetryTimeout}s后解锁');
          }
        }
        debugPrint('登录失败：${errRes.code}');
      }
    });
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
    // 以 { 或者 [ 开头的，空字符串
    RegExp exp = RegExp(r'^$|^[{[]');
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
    debugPrint("response = ${err.response}");
    return super.onError(err, handler);
  }
}
