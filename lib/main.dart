import 'dart:async';
import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'core/http/http.dart';
import 'core/router/global_route.dart';
import 'pages/login/login_controller.dart';

final GlobalRouter router = GlobalRouter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化下载插件
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  // 初始化请求过滤器
  XHttp.init();
  // 初始化定位
  await AmapLocation.instance.updatePrivacyShow(true);
  await AmapLocation.instance.updatePrivacyAgree(true);
  await AmapLocation.instance.init(iosKey: BaseConfig.gdIosKey);
  //顶部状态栏透明
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String password = '';

  final LoginController loginController = Get.put(LoginController());

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  Timer? _timer = Timer.periodic(const Duration(minutes: 0), (timer) {});

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
        print('----------$e');
        Get.offNamed("/get_equipment");
      }
    }).catchError((onError) {
      Get.offNamed("/get_equipment");
      debugPrint(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ToastUtils.init(GetMaterialApp(
            key: navigatorKey,
            title: 'APP模板',
            // 不显示debug标签
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: ((settings) {
              printInfo(info: "+++++++++${settings.name}");
              if (settings.name == '/home') {
                printInfo(info: "----------${settings.name}");

                sharedGetData(loginController.isSn.value.toString(), String)
                    .then((value) {
                  if (value != null) {
                    password = value.toString();
                    _timer =
                        Timer.periodic(const Duration(minutes: 5), (timer) {
                      debugPrint('当前时间${DateTime.now()}');
                      appLogin(password);
                    });
                  } else {
                    _timer?.cancel();
                    _timer = null;
                  }
                });
              }
              return router.getRoutes(settings);
            }),
          ));
        });
  }
}
