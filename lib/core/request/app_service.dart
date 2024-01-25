import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:dio/dio.dart';
import '../../pages/login/login_controller.dart';
import 'package:get/get.dart';

import '../utils/shared_preferences_util.dart';

const _tokenExpirationTime = Duration(minutes: 1);

// 设备登录单例类
class AppAuthService {
  static final AppAuthService _singleton = AppAuthService._internal();
  final LoginController loginController = Get.put(LoginController());
  var dio = Dio();
  factory AppAuthService() {
    return _singleton;
  }

  Timer _tokenRefreshTimer = Timer(Duration.zero, () {});
  late String _token;
  Map<String, String> user = {};

  AppAuthService._internal() {
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
  //   dio.options.headers = {
  //   'Accept': 'application/json,*/*',
  //   'Content-Type': 'application/json',
  // };
    _startTokenRefreshTimer();
  }

  Future<String> login(String username, String password) async {
    Map<String, dynamic> data = {
      'username': username,
      'password': utf8.decode(base64Decode(password)),
    };
    try {
      final response = await dio.post(
          '${BaseConfig.cloudBaseUrl}/platform/appCustomer/login',
          data: data);

      var d = json.decode(response.toString());
      debugPrint('登录成功${d['data']['token']}');
      _token = d['data']['token'];
      loginController.setUserToken(d['data']['token']);
      sharedAddAndUpdate("userToken", String, d['data']['token']);
      user = {
        'name': username,
        'pwd': password,
      };
      return d['token'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> refreshToken() async {
    // 此处正常应该拿着token去get新的token
    // 但是设备只有一个登录接口
    final response = await login(user['name']!, user['pwd']!);
    return response;
  }

  void _startTokenRefreshTimer() {
    _tokenRefreshTimer = Timer.periodic(_tokenExpirationTime, (_) {
      refreshToken();
    });
  }

  void _stopTokenRefreshTimer() {
    _tokenRefreshTimer.cancel();
  }

  void logout() {
    _stopTokenRefreshTimer();
  }

  String get token => _token;

  bool get isLoggedIn => _token.isNotEmpty;
}
