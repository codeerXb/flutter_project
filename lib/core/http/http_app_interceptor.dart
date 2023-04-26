import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';

import 'package:flutter_template/pages/login/login_controller.dart';
// ignore: library_prefixes
import 'package:get/get.dart' as GetX;
import 'package:get/get_core/src/get_main.dart';

import '../../generated/l10n.dart';
import '../utils/toast.dart';

// 创建一个code的model
class CodeModel {
  int? code;

  CodeModel({this.code});

  CodeModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    return data;
  }
}

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
    // 登录过期处理
    if (CodeModel.fromJson(jsonDecode(response.data.toString())).code == 900) {
      ToastUtils.error(S.current.tokenExpired);
      Get.offNamed("/user_login");
      sharedDeleteData('user_phone');
      sharedDeleteData('user_token');
      debugPrint('清除用户信息');
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
