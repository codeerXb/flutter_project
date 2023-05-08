import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/get_equipment/water_ripple_painter.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:get/get.dart';

class AddEquipment extends StatefulWidget {
  const AddEquipment({super.key});

  @override
  State<AddEquipment> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddEquipment> {
  final LoginController loginController = Get.put(LoginController());
  final ToolbarController toolbarController = Get.put(ToolbarController());
  bool isExistCloudDevice = false;
  List appList = [];
  EquipmentData equipmentData = EquipmentData();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        getEquipmentData([]);
      }
      return;
    });
    loginController.setLoading(true);
  }

  void getEquipmentData(List<dynamic> list) {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","systemVersionHw","systemVersionRunning","systemVersionUboot","systemVersionSn","networkLanSettingsMac","networkLanSettingIp","networkLanSettingMask","systemRunningTime"]'
    };

    XHttp.get('/pub/pub_data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        // if (equipmentData.systemVersionSn == null ||
        //     equipmentData.systemVersionSn !=
        //         EquipmentData.fromJson(d).systemVersionSn) {
        setState(() {
          equipmentData = EquipmentData.fromJson(d);
        });
        if (list.isNotEmpty) {
          for (var app in list) {
            String deviceSnKey = 'deviceSn';
            String systemVersionSnValue =
                equipmentData.systemVersionSn.toString();
            var deviceSnValue = app[deviceSnKey];
            printInfo(
                info:
                    'isExistCloudDevice===$isExistCloudDevice$deviceSnValue$systemVersionSnValue');
            if (deviceSnValue == systemVersionSnValue) {
              setState(() {
                isExistCloudDevice = true;
              });
              return;
            } else {
              continue;
            }
          }
        }
        // }
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
        appBar: customAppbar(
          context: context,
          title: S.of(context).DiscoveryEqu,
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
                            if (mounted) getEquipmentData([]);
                          },
                          child: Text(S.of(context).rescan),
                        ),
                    ],
                  ),
                ),
                if (!isExistCloudDevice &&
                    equipmentData.systemProductModel != null)
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
                              loginController.setState('cloud');
                              printInfo(
                                  info:
                                      'state--${loginController.login.state}');
                              Get.offNamed("/loginPage", arguments: {
                                "sn": equipmentData.systemVersionSn,
                                "vn": equipmentData.systemProductModel
                              });
                              // }
                              // });s
                            },
                            child: Text(S.of(context).band),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (appList.isNotEmpty)
                  SizedBox(
                    height: 400.w,
                    child: ListView.builder(
                      itemCount: appList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
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
                                    fit: BoxFit.fitWidth,
                                    height: 60,
                                    width: 40),
                                title: Text(appList[index]['type'].toString()),
                                subtitle: Text(
                                  'SN ${appList[index]['deviceSn'].toString()}',
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                trailing: TextButton(
                                  onPressed: () {
                                    //底部导航回到第一页
                                    toolbarController.setPageIndex(0);
                                    loginController.setUserEquipment('deviceSn',
                                        appList[index]['deviceSn'].toString());
                                    sharedAddAndUpdate("deviceSn", String,
                                        appList[index]['deviceSn'].toString());
                                    loginController.setState('cloud');
                                    printInfo(
                                        info:
                                            'state--${loginController.login.state}');
                                    Get.offNamed("/home", arguments: {
                                      "sn":
                                          appList[index]['deviceSn'].toString(),
                                      "vn": appList[index]['type'].toString()
                                    });
                                  },
                                  child: Text(S.of(context).conDev),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
              ]),
        ));
  }
}
