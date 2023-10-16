import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../pages/login/login_controller.dart';
import '../http/http.dart';
import 'package:get/get.dart';
import '../utils/shared_preferences_util.dart';

const _tokenExpirationTime = Duration(minutes: 1);

// 设备登录单例类
class AuthService {
  static final AuthService _singleton = AuthService._internal();
  final LoginController loginController = Get.put(LoginController());

  factory AuthService() {
    return _singleton;
  }

  Timer _tokenRefreshTimer = Timer(Duration.zero, () {});
  late String _token;
  Map<String, String> user = {};

  AuthService._internal() {
    _startTokenRefreshTimer();
  }

  Future<String> login(String username, String password) async {
    Map<String, dynamic> data = {
      'username': username,
      'password': utf8.decode(base64Decode(password)),
    };
    try {
      final response = await XHttp.get('/action/appLogin', data);

      var d = json.decode(response.toString());
      debugPrint('登录成功${d['token']}');
      loginController.setSession(d['sessionid']);
      sharedAddAndUpdate("session", String, d['sessionid']);
      loginController.setToken(d['token']);
      sharedAddAndUpdate("token", String, d['token']);
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

  // void _setToken(String token) {
  //   setState(() {
  //     _token = token;
  //   });
  // }

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

  bool get isLoggedIn => _token != null;
}
