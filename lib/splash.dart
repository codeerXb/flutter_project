import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';

import 'core/utils/shared_preferences_util.dart';

/// 类似广告启动页
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const duration = Duration(seconds: 2);
  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();

    /// 查询本地保存的云登录信息
    sharedGetData("user_token", String).then((data) {
      printInfo(info: 'USER TOKEN${data.toString()}');
      if (data != null) {
        // 是否存储了设备sn
        sharedGetData('deviceSn', String).then((sn) {
          if (sn != null) {
            debugPrint('设备sn号$sn');
            Future.delayed(duration, () => Get.offNamed("/home"));
          } else {
            Future.delayed(duration, () => Get.offNamed("/get_equipment"));
          }
        });
      } else {
        // 没有信息则为登录过云端账号，返回云端登录页
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
