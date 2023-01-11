import 'dart:async';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';

import '../../core/utils/app_update_util.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/widget/common_widget.dart';
import '../../core/widget/custom_app_bar.dart';

/// 系统设置
class SystemSettings extends StatefulWidget {
  const SystemSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SystemSettingsState();
}

class _SystemSettingsState extends State<SystemSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '系统设置'),
      body: SingleChildScrollView(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidget.simpleWidgetWithUserDetail("版本更新", callBack: () {
                print("版本更新");
                if (false) {
                  /// 这里先注释掉
                  AppUpdateUtils().updateApp(fromHome: false);
                }
              }),
              CommonWidget.simpleWidgetWithUserDetail("隐私政策", callBack: () {
                print("隐私政策");
              }),
              CommonWidget.simpleWidgetWithUserDetail("用户协议", callBack: () {
                print("用户协议");
              }),
              CommonWidget.buttonWidget(
                  title: '退出登录',
                  background: Colors.white,
                  fontColor: Colors.red,
                  callBack: loginout),
            ],
          ),
        ),
      ),
    );
  }

  /// 退出登录
  void loginout() async {
    // 这里还需要调用后台接口的方法
    Dio dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback = (cert, host, port) {
        return true; // 返回true强制通过
      };
      return null;
    };
    try {
      await dio.post('${BaseConfig.baseUrl}/action/logout');
    } on DioError catch (err) {
      if (err.message.toString().contains('302')) {
        sharedDeleteData("loginInfo");
        sharedClearData();
        Get.offAllNamed("/get_equipment");
      } else {
        ToastUtils.error('退出登录失败，请检查网络！');
      }
      printError(info: err.toString());
    }
  }
}
