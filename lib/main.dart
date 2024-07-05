import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:get/get.dart';
import 'core/http/http.dart';
import 'core/router/global_route.dart';
import 'generated/l10n.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'core/utils/global_nav_context.dart';
import 'package:package_info_plus/package_info_plus.dart';

final GlobalRouter router = GlobalRouter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getCurrentAppVersion();
  // 初始化请求过滤器
  App.init();

  final info = NetworkInfo();
  final wifiGateway = await info.getWifiGatewayIP();
  debugPrint('当前wifi的网关地址$wifiGateway');
  if (Platform.isAndroid) {
    BaseConfig.baseUrl = "http://192.168.1.1";
    // debugPrint('安卓设备wifi的网关地址${BaseConfig.baseUrl}');
  }else {
    BaseConfig.baseUrl = "http://$wifiGateway";
    // debugPrint('iOSwifi的网关地址${BaseConfig.baseUrl}');
  }
  
  if (wifiGateway != null && wifiGateway.isNotEmpty) {
    sharedAddAndUpdate("baseLocalUrl", String, BaseConfig.baseUrl);
  }
  XHttp.init();

  //顶部状态栏透明
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(const MyApp());
}

  Future<void> getCurrentAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersionCode = packageInfo.version;
    debugPrint("当前的App版本是:$currentVersionCode");
    sharedAddAndUpdate("currentAppVersion", String, currentVersionCode);
  }

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ToolbarController toolbarController = Get.put(ToolbarController());
  String language = 'en_US';
  @override
  initState() {
    //读取当前语言
    sharedGetData('lang', String).then(((res) {
      if (res != null) {
        setState(() {
          language = res.toString();
        });
      }
      printInfo(info: '当前设置的语言${res.toString()}');
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(750, 1334),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          //国际化
          return ToastUtils.init(
            GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              sharedGetData('lang', String).then((res) {
                String lang = res.toString();
                debugPrint('当前设置的语言1$lang---$locale---${lang.isNotEmpty}');
                if (lang != 'null') {
                  if (lang == 'en_US') {
                    S.load(const Locale('en', 'US'));
                    return const Locale('en', 'US');
                  }
                } else {
                  S.load(const Locale('en', 'US'));
                  return const Locale('en', 'US');
                }
              });

              if (locale.toString().split('_').length > 1) {
                S.load(Locale(locale.toString().split('_')[0],
                    locale.toString().split('_')[1]));
                return Locale(locale.toString().split('_')[0],
                    locale.toString().split('_')[1]);
              } else {
                S.load(Locale(locale.toString().split('_')[0], null));
                return Locale(locale.toString().split('_')[0], null);
              }
            },
            locale: const Locale('en', 'US'),
            fallbackLocale: const Locale('en', 'US'),
            navigatorKey: GlobalContext.navigatorKey,
            title: 'router',
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: ((settings) {
              debugPrint('即将跳转:${settings.name}');
              return router.getRoutes(settings);
            }),
            theme: ThemeData(
              switchTheme: SwitchThemeData(
                thumbColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.white.withOpacity(.48);
                  }
                  return Colors.white;
                }),
                trackColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return null;
                  }
                  if (states.contains(MaterialState.selected)) {
                    return Colors.green;
                  }
                  return null;
                }),
              ),
            ),
          ));
        });
  }
}
