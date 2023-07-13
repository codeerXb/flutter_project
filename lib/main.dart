import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:get/get.dart';

import 'core/http/http.dart';
import 'core/router/global_route.dart';
import 'generated/l10n.dart';

final GlobalRouter router = GlobalRouter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化请求过滤器
  XHttp.init();
  App.init();

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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final ToolbarController toolbarController = Get.put(ToolbarController());
  String language = '';
  @override
  initState() {
    //读取当前语言
    sharedGetData('lang', String).then(((res) {
      setState(() {
        language = res.toString();
      });
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
          return ToastUtils.init(GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              debugPrint('当前设置的语言lang$language');
              sharedGetData('lang', String).then((res) {
                String lang = res.toString();
                debugPrint('当前设置的语言1$lang---$locale---${lang.isNotEmpty}');
                if (lang != 'null') {
                  if (lang == 'zh_CN') {
                    debugPrint('当前设置的语言1-1');
                    S.load(const Locale('zh', 'CN'));
                    return const Locale('zh', 'CN');
                  } else if (lang == 'en_US') {
                    debugPrint('当前设置的语言1-2');
                    S.load(const Locale('en', 'US'));
                    return const Locale('en', 'US');
                  } else if (locale == null) {
                    debugPrint('当前设置的语言1-3');
                    return null;
                  }
                }
              });
              debugPrint('当前设置的语言1-4');
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
            key: navigatorKey,
            title: 'router',
            // 不显示debug标签
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: ((settings) {
              debugPrint('即将跳转:${settings.name}');
              return router.getRoutes(settings);
            }),
          ));
        });
  }
}
