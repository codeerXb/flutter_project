import 'dart:async';
import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'core/http/http.dart';
import 'core/router/global_route.dart';
import 'generated/l10n.dart';
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
    print('登录密码：$pwd');
    Map<String, dynamic> data = {
      'username': 'admin',
      'password': utf8.decode(base64Decode(pwd)),
    };
    XHttp.get('/action/appLogin', data).then((res) {
      try {
        print("+++++++++++++");
        var d = json.decode(res.toString());
        print('登录成功${d['token']}');
        loginController.setSession(d['sessionid']);
        sharedAddAndUpdate("session", String, d['sessionid']);
        loginController.setToken(d['token']);
        sharedAddAndUpdate("token", String, d['token']);
        // print(d);
      } on FormatException catch (e) {
        print('登录错误1$e');
        Get.offNamed("/get_equipment");
      }
    }).catchError((onError) {
      Get.offNamed("/get_equipment");
      debugPrint('登录错误2${onError.toString()}');
    });
  }

  final ToolbarController toolbarController = Get.put(ToolbarController());
  var language = '';
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    //读取当前语言
    // sharedGetData('langue', String).then(((res) {
    //   if (res != null) {
    //     language = res.toString();
    //   }
    //   print('当前语言----->$language');
    // }));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          //国际化
          return ToastUtils.init(GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            // localeResolutionCallback: (locale, supportedLocales) {
            //   if (language == '中文') {
            //     return const Locale('zh', 'CN');
            //   }else if(language == 'English'){
            //     return const Locale('en', 'US');

            //   }
            // },
            key: navigatorKey,
            title: 'smawave',
            // 不显示debug标签
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: ((settings) {
              var name = settings.name;
              // 进入首页之后，存在token直接进入并启用定时器：每5min调用一次登录接口更新程序
              // 不存在则关闭定时器，返回搜索界面
              if (name == '/home') {
                print('即将进入home页面');
                sharedGetData(loginController.isSn.value.toString(), String)
                    .then((value) {
                  print('设备登录：$value');
                  if (value != null) {
                    password = value.toString();
                    _timer =
                        Timer.periodic(const Duration(minutes: 5), (timer) {
                      debugPrint('登录当前时间${DateTime.now()}');
                      appLogin(password);
                    });
                  } else {
                    // _timer?.cancel();
                    // _timer = null;
                    RouteSettings equipment = const RouteSettings(
                        name: '/get_equipment', arguments: null);
                    print('跳转equipment:$equipment');
                  }
                });
              }
              print('setting:$settings');
              return router.getRoutes(settings);
            }),
          ));
        });
  }
}
