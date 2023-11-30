import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/get_equipment/water_ripple_painter.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:geocode/geocode.dart';
import 'package:dio/dio.dart';
class Equipment extends StatefulWidget {
  const Equipment({super.key});

  @override
  State<Equipment> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Equipment> {
  final LoginController loginController = Get.put(LoginController());
  final ToolbarController toolbarController = Get.put(ToolbarController());
  bool isExistCloudDevice = false;
  List appList = [];
  EquipmentData equipmentData = EquipmentData();
  Timer? timer;
  String configStatus = " ";
  // 位置信息
  LocationData? currentLocation;
  String? longitudeString;
  String? latitudeString;
  @override
  void initState() {
    super.initState();
    getLocationInformation();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        getqueryingBoundDevices();
      }
      return;
    });
    loginController.setLoading(true);
  }

  //  查询绑定设备 App
  void getqueryingBoundDevices() {
    App.get('/platform/appCustomer/queryCustomerCpe').then((res) {
      if (res == null || res.toString().isEmpty) {
        throw Exception('Response is empty.');
      }
      var d = json.decode(json.encode(res));
      if (d['code'] != 200) {
        // 9999：用户令牌不能为空
        // 9998：平台登录标识不能为空
        // 9996：用户令牌过期或非法
        // 9997：平台登录标识非法
        if (d['code'] == 9999 ||
            d['code'] == 9998 ||
            d['code'] == 9997 ||
            d['code'] == 9996) {
          ToastUtils.error(S.of(context).tokenExpired);
          sharedDeleteData('user_token');
          Get.offAllNamed('/user_login');
        } else {
          ToastUtils.error(S.of(context).failed);
        }
        return;
      } else {
        setState(() {
          appList = d['data'];
        });
        getEquipmentData(d['data']);
      }
    }).catchError((onError) {
      debugPrint(onError.toString());
    });
  }

  void getEquipmentData(List<dynamic> list) {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemProductModel","systemVersionHw","systemVersionRunning","systemVersionUboot","systemVersionSn","networkLanSettingsMac","networkLanSettingIp","networkLanSettingMask","systemRunningTime","systemRouterOnly","lteMainStatusGet","ethernetLinkStatus"]'
    };

    XHttp.get('/pub/pub_data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        // if (equipmentData.systemVersionSn == null ||
        //     equipmentData.systemVersionSn !=
        //         EquipmentData.fromJson(d).systemVersionSn) {
        // setState(() {

        // });
        equipmentData = EquipmentData.fromJson(d);
        sharedAddAndUpdate("systemRouterOnly", String, equipmentData.systemRouterOnly!);
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
        // setState(() {
        //   equipmentData = EquipmentData(
        //       systemProductModel: null,
        //       systemVersionRunning: '',
        //       systemVersionSn: '');
        // });
        debugPrint(e.toString());
      }
    }).catchError((onError) {
      // if (mounted) {
      //   setState(() {
      //     equipmentData = EquipmentData(
      //         systemProductModel: null,
      //         systemVersionRunning: '',
      //         systemVersionSn: '');
      //   });
      // }
      debugPrint(onError.toString());
    });
  }

  Future<LocationData?> _getLocation() async {
    Location location = Location();
    LocationData _locationData;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  Future<String> _getAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return "ssss";
    GeoCode geoCode = GeoCode();
    Address address =
        await geoCode.reverseGeocoding(latitude: lat, longitude: lang);
    return "${address.streetAddress}, ${address.city}, ${address.countryName}, ${address.postal}";
  }

  void getLocationInformation() {
    // 获取设备位置信息(经纬度)
    _getLocation().then((value) {
      LocationData? location = value;
      _getAddress(location?.latitude, location?.longitude).then((value) {
        setState(() {
          currentLocation = location;
          latitudeString = currentLocation?.latitude.toString();
          longitudeString = currentLocation?.longitude.toString();
          debugPrint("当前的经纬度是$latitudeString $longitudeString");
        });
      });
    });
  }

  void bundDevice(String sn, String vn) {
    Map<String, dynamic> bindParma = {
      "deviceSn": sn,
      "lon": longitudeString,
      "lat": latitudeString
    };
    debugPrint("用户绑定设备的信息----${bindParma.toString()}");
    App.post('/platform/appCustomer/bindingCpe', data: bindParma).then((res) {
      var bindDevRes = json.decode(res.toString());

      debugPrint('云平台绑定响应------>$bindDevRes');
      if (bindDevRes['code'] != 200) {
        // 绑定失败提示
        if (bindDevRes['code'] == 9983) {
          ToastUtils.error(S.current.deviceBinded);
        } else if (bindDevRes['code'] == 9984) {
          ToastUtils.error(S.current.deviceUnprovide);
        } else {
          ToastUtils.error(S.current.unkownFail);
        }
        return;
      } else {
        ToastUtils.toast(bindDevRes['message']);
        loginController.setUserEquipment('deviceSn', sn);
        sharedAddAndUpdate("deviceSn", String, sn);
        // timer = Timer.periodic(const Duration(minutes: 5), (timer) {
        //   debugPrint('登录当前时间${DateTime.now()}');
        //   // 再次请求登录
        //   login(_password.trim());
        // });
        Get.offNamed("/home", arguments: {"sn": sn, "vn": vn});
      }
    }).catchError((err) {
      timer?.cancel();
      timer = null;
      debugPrint('云平台绑定错误响应------>$err');
      // 响应超时
      if (err['code'] == DioErrorType.connectTimeout) {
        debugPrint('timeout');
        ToastUtils.error(S.current.contimeout);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 组件销毁时判断Timer是否仍然处于激活状态，是则取消
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            S.of(context).DiscoveryEqu,
            style: const TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: 80,
                child: GestureDetector(
                  onTap: () {
                    Get.offNamed("/user_login");
                    sharedDeleteData('user_phone');
                    sharedDeleteData('user_token');
                    sharedDeleteData('deviceSn');
                    debugPrint('清除用户信息');
                  },
                  child: Column(children: [
                    const Icon(Icons.power_settings_new, color: Colors.red),
                    Text(S.current.logOut,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 11)),
                  ]),
                ),
              ),
            ),
          ],
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
                            // int num = 0;
                            // timer = Timer.periodic(
                            //     const Duration(milliseconds: 1000), (time) {
                            //   if (num > 5) {
                            //     timer?.cancel();
                            //   }
                            //   num += 2;
                            //   // 确保页面存在时，调用异步方法
                            //   printInfo(info: '111先走这里嘛');
                            if (mounted) getqueryingBoundDevices();
                            // });
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
                              if(equipmentData.systemRouterOnly == "0") {
                                if(equipmentData.lteMainStatusGet ==
                                  "connected"){
                                    bundDevice(equipmentData.systemVersionSn!, equipmentData.systemProductModel!);
                                }else {
                                  // 引导连网页
                                  ToastUtils.error("Network not connected");
                                  Get.toNamed("/unNetworkpage");
                                }
                              }else {
                                Get.offNamed("/NetMode", arguments: {
                                    "sn": equipmentData.systemVersionSn,
                                    "vn": equipmentData.systemProductModel,
                                    "rou": equipmentData.systemRouterOnly
                                  });
                              }
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
