import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';

import 'package:flutter_template/pages/login/login_controller.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GetX;

/// 拦截器
class HttpAppInterceptors extends InterceptorsWrapper {
  final LoginController loginController = GetX.Get.put(LoginController());

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    sharedGetData("user_token", String).then((data) {
      loginController.setUserToken(data);
    });

    String appLoginFlag = 'true';
    String authorization = loginController.login.userToken.value;
    debugPrint('authorization--$authorization');

    Map<String, dynamic> header = {
      "Authorization": authorization,
      "appLoginFlag": appLoginFlag,
    };
    options.headers = header;
    options.path = options.uri.toString();

    options.queryParameters = {};
    debugPrint("\n================== 云平台请求数据 ==========================");
    debugPrint("url = ${options.uri.toString()}");
    debugPrint("Authorization = ${options.headers}");
    debugPrint("params = ${options.data}");
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String isSn = loginController.isSn.value;
    String password = '';
    if (isSn != '') {
      password = loginController.sn[isSn.toString()];
    }
    debugPrint("\n================== 云平台响应数据==========================");
    debugPrint("code = ${response.statusCode}");
    debugPrint("data = ${response.data}");

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint("\n================== 云平台错误响应数据 ======================");
    debugPrint("type = ${err.type}");
    debugPrint("message = ${err.message}");
    debugPrint("stackTrace = ${err.error}");
    debugPrint("response = ${err.response}");
    return super.onError(err, handler);
  }
}
