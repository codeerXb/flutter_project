import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/l10n.dart';

import 'package:flutter_template/pages/login/login_controller.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GetX;
import 'package:get/get_core/src/get_main.dart';

/// 拦截器
class HttpAppInterceptors extends InterceptorsWrapper {
  final LoginController loginController = GetX.Get.put(LoginController());

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String appLoginFlag = 'true';
    Object? authorization = await sharedGetData("user_token", String);
    debugPrint('authorization--$authorization');

    Map<String, dynamic> header = {
      "Authorization": authorization,
      "appLoginFlag": appLoginFlag.toString(),
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
    debugPrint("\n================== 云平台响应数据==========================");
    debugPrint("code = ${response.statusCode}");
    debugPrint("data = ${response.data}");
    try {
      final Map<String, dynamic> responseData;
      if (response.data is String) {
        responseData = json.decode(response.data) as Map<String, dynamic>;
      } else {
        responseData = response.data as Map<String, dynamic>;
      }

      if (responseData.containsKey("code")) {
        int code = responseData["code"];

        // 9999：用户令牌不能为空
        // 9998：平台登录标识不能为空
        // 900：用户令牌过期或非法
        // 9997：平台登录标识非法
        if (code == 9998 || code == 9997 || code == 900 || code == 9999) {
          // 处理登录过期的情况
          ToastUtils.error(S.current.tokenExpired);
          Get.offNamed("/user_login");
          sharedDeleteData('user_phone');
          sharedDeleteData('user_token');
          sharedDeleteData('deviceSn');
          debugPrint('清除用户信息');
        }
      }
    } catch (e, stackTrace) {
      printError(info: e.toString());
      printError(info: stackTrace.toString());
      // 处理异常
    }

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
