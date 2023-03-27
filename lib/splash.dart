import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';

import 'core/utils/shared_preferences_util.dart';
import 'core/utils/string_util.dart';
import 'core/utils/toast.dart';

/// 类似广告启动页
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const duration = Duration(seconds: 2);
  final LoginController loginController = Get.put(LoginController());

  void appLogin(pwd) {
    debugPrint('登录密码：$pwd');
    Map<String, dynamic> data = {
      'username': 'admin',
      'password': utf8.decode(base64Decode(pwd)),
    };
    XHttp.get('/action/appLogin', data).then((res) {
      try {
        debugPrint("+++++++++++++");
        var d = json.decode(res.toString());
        debugPrint('登录成功${d['token']}');
        loginController.setSession(d['sessionid']);
        sharedAddAndUpdate("session", String, d['sessionid']);
        loginController.setToken(d['token']);
        sharedAddAndUpdate("token", String, d['token']);
        // debugPrint(d);
      } on FormatException catch (e) {
        debugPrint('登录错误1$e');
        Get.offNamed("/get_equipment");
      }
    }).catchError((onError) {
      Get.offNamed("/get_equipment");
      debugPrint('登录错误2${onError.toString()}');
    });
  }

  @override
  void initState() {
    super.initState();
    String password = '';

    Timer? timer = Timer.periodic(const Duration(minutes: 0), (timer) {});

    ///查询本地保存的登录信息
    sharedGetData("user_token", String).then((data) {
      printInfo(info: 'USER TOKEN${data.toString()}');
      if (data != null) {
        // 看是否存储了设备的sn和密码
        sharedGetData('deviceSn', String).then((sn) {
          if (sn != null) {
            debugPrint('设备sn号$sn');
            sharedGetData(sn.toString(), String).then((value) {
              debugPrint('设备登录：$value');
              if (value != null) {
                // 存储了，开启定时器登录
                password = value.toString();
                appLogin(password);

                timer = Timer.periodic(const Duration(minutes: 5), (timer) {
                  debugPrint('登录当前时间${DateTime.now()}');
                  appLogin(password);
                });
              } else {
                // 未存储，取消定时器，跳转到搜索设备页面
                timer?.cancel();
                timer = null;
                Future.delayed(duration, () => Get.offNamed("/get_equipment"));
              }
            });
            Future.delayed(duration, () => Get.offNamed("/home"));
          } else {
            Future.delayed(duration, () => Get.offNamed("/get_equipment"));
          }
        });
      } else {
        Future.delayed(duration, () => Get.offNamed("/user_login"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.fill,
            width: 750.w,
            height: 1440.h,
          ),
        ),
      ),
    );
  }
}
