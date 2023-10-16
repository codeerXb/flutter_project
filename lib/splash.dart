import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
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
  final LocalAuthentication auth = LocalAuthentication();
  // 默认验证不通过
  bool _authorized = false;
  // 定义是否开始验证
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();

    // 验证是否支持
    auth.isDeviceSupported().then((bool isSupported) {
      if (isSupported) {
        init();
      } else {
        Future.delayed(duration, () => Get.offNamed("/user_login"));
      }
    }).catchError((e) {
      debugPrint(e.toString());
      Future.delayed(duration, () => Get.offNamed("/user_login"));
    });
  }

  Future<void> init() async {
    // --- 查询是否开启生物验证功能 ---
    bool isOpenAuth = true;
    var isAuth = await sharedGetData('biometricsAuth', bool);
    if (isAuth != null) {
      isOpenAuth = isAuth as bool;
    } else {
      // 存入默认值
      sharedAddAndUpdate('biometricsAuth', bool, isOpenAuth);
    }
    if (isOpenAuth) {
      // --- 做本地指纹验证 ---
      // 异步调用验证接口,根据返回结果更新验状态
      await _authenticateWithBiometrics();
      // --- 验证通过之后跳转 ---
      if (_authorized) {
        debugPrint('指纹验证通过：$_authorized');

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
      } else {
        // --- 验证失败之后跳转用户登录页 ---
        debugPrint('指纹验证不通过：$_authorized');
        Future.delayed(duration, () => Get.offNamed("/user_login"));
      }
    } else {
      // --- 未开启生物认证 ---
      Future.delayed(duration, () => Get.offNamed("/user_login"));
    }
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isAuthenticating = false;
      });
      return;
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _authorized = authenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/splash.png',
                fit: BoxFit.cover,
                // width: 750.w,
                // height: 1440.h,
              ),
            ),
            if (_isAuthenticating)
              ElevatedButton(
                onPressed: _cancelAuthentication,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Cancel Authentication'),
                    Icon(Icons.cancel),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
