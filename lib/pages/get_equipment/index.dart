import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/get_equipment/water_ripple_painter.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:get/get.dart';

class Equipment extends StatefulWidget {
  const Equipment({super.key});

  @override
  State<Equipment> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Equipment> {
  final LoginController loginController = Get.put(LoginController());
  final ToolbarController toolbarController = Get.put(ToolbarController());

  EquipmentData equipmentData = EquipmentData();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      getEquipmentData();
      return;
    });

    loginController.setLoading(true);
  }

  void appLogin(pwd, sn, vn) {
    Map<String, dynamic> data = {
      'username': 'superadmin',
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
        Get.offNamed("/home", arguments: {"sn": sn, "vn": vn});
        // print(d);
      } on FormatException catch (e) {
        print('----------');
        Get.offNamed("/loginPage", arguments: {"sn": sn, "vn": vn});
        print('The provided string is not valid JSON');
        print(e);
      }
    }).catchError((onError) {
      Get.offNamed("/loginPage", arguments: {"sn": sn, "vn": vn});

      debugPrint(onError.toString());
    });
  }

  void getEquipmentData() {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","systemVersionHw","systemVersionRunning","systemVersionUboot","systemVersionSn","networkLanSettingsMac","networkLanSettingIp","networkLanSettingMask","systemRunningTime"]'
    };

    XHttp.get('/pub/pub_data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        if (equipmentData.systemVersionSn == null ||
            equipmentData.systemVersionSn !=
                EquipmentData.fromJson(d).systemVersionSn) {
          setState(() {
            equipmentData = EquipmentData.fromJson(d);
          });
        }
      } on FormatException catch (e) {
        setState(() {
          equipmentData = EquipmentData(
              systemProductModel: null,
              systemVersionRunning: '',
              systemVersionSn: '');
        });
        debugPrint(e.toString());
      }
    }).catchError((onError) {
      if (mounted) {
        setState(() {
          equipmentData = EquipmentData(
              systemProductModel: null,
              systemVersionRunning: '',
              systemVersionSn: '');
        });
      }
      debugPrint(onError.toString());
    });
  }

  Timer? timer;
  @override
  void dispose() {
    super.dispose();
    // 组件销毁时判断Timer是否仍然处于激活状态，是则取消
    if (timer != null) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //     onPressed: () {
          //       Get.offAllNamed("/user_login");
          //     },
          //     icon: const Icon(
          //       Icons.arrow_back_ios,
          //       color: Colors.black,
          //     )),
          centerTitle: true,
          title: Text(
            S.of(context).DiscoveryEqu,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        body: Obx(
          () => ListView(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 100.w),
                ),
                Center(
                    child: SizedBox(
                        height: 300.w,
                        width: 300.w,
                        child: WaterRipple(
                          key: childKey,
                        ))),
                Padding(
                  padding: EdgeInsets.only(top: 120.w),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      if (loginController.loading.value)
                        Center(
                          child: Text(
                            S.of(context).Scanning,
                            style: TextStyle(
                              fontSize: 36.sp,
                              height: 2.5,
                            ),
                          ),
                        ),
                      if (equipmentData.systemProductModel == null &&
                          !loginController.loading.value)
                        Center(
                            child: Text(S.of(context).noDevice,
                                style: TextStyle(
                                  fontSize: 36.sp,
                                  height: 2.5,
                                ))),
                      if (!loginController.loading.value)
                        TextButton(
                          onPressed: () {
                            childKey.currentState!.controllerForward();
                            int num = 0;
                            timer = Timer.periodic(
                                const Duration(milliseconds: 1000), (time) {
                              if (num > 5) {
                                timer?.cancel();
                              }
                              num += 2;
                              // 确保页面存在时，调用异步方法
                              if (mounted) getEquipmentData();
                            });
                          },
                          child: Text(S.of(context).rescan),
                        ),
                    ],
                  ),
                ),
                if (equipmentData.systemProductModel != null)
                  Card(
                    elevation: 5, //设置卡片阴影的深度
                    shape: const RoundedRectangleBorder(
                      //设置卡片圆角
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.all(10), //设置卡片外边距
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.asset("assets/images/router.png",
                              fit: BoxFit.fitWidth, height: 60, width: 40),
                          title:
                              Text(equipmentData.systemProductModel.toString()),
                          subtitle: Text(
                            'SN ${equipmentData.systemVersionSn.toString()}',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              //底部导航回到第一页
                              toolbarController.setPageIndex(0);
                              loginController.setEquipment('systemVersionSn',
                                  equipmentData.systemVersionSn);
                              childKey.currentState!.controllerStop();
                              sharedGetData(
                                      equipmentData.systemVersionSn.toString(),
                                      String)
                                  .then((data) {
                                debugPrint('objectobjectobjectobject$data');
                                if (data != null) {
                                  appLogin(data, equipmentData.systemVersionSn,
                                      equipmentData.systemProductModel);
                                  loginController.setSn(
                                      equipmentData.systemVersionSn, data);
                                } else {
                                  loginController.setSn(
                                      equipmentData.systemVersionSn,
                                      'superadmin');
                                  Get.offNamed("/loginPage", arguments: {
                                    "sn": equipmentData.systemVersionSn,
                                    "vn": equipmentData.systemProductModel
                                  });
                                }
                              });
                            },
                            child: Text(S.of(context).conDev),
                          ),
                        ),
                      ],
                    ),
                  )
              ]),
        ));
  }
}
