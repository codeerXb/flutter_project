import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/exception_login.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:location/location.dart';
import 'package:geocode/geocode.dart';
import '../../core/utils/string_util.dart';

/// 选择上网方式
class NetMode extends StatefulWidget {
  const NetMode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetModeState();
}

class _NetModeState extends State<NetMode> {
  int currentStep = 0; //序列索引
  int _selectedIndex = 0;
//iptVal
  final TextEditingController ipValue = TextEditingController();
  final TextEditingController sMValue = TextEditingController(); //子网掩码
  final TextEditingController gatewayValue = TextEditingController(); //默认网关
  final TextEditingController dNSValue = TextEditingController(); //首选DNS服务器
  final TextEditingController dNS2Value =
      TextEditingController(); //备用DNS服务器(选填)

  bool checkedMac = false;

  String? wifiGetWayUrl = "";

  void _selectIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  final GlobalKey _formKey = GlobalKey<FormState>();

  String _account = 'superadmin';
  String _password = 'admin';
  dynamic sn = Get.arguments['sn'];
  dynamic vn = Get.arguments['vn'];
  String routeFlag = Get.arguments["rou"];

  final bool _isObscure = true;
  final Color _eyeColor = Colors.grey;
  Color _accountBorderColor = Colors.white;
  Color _passwordBorderColor = Colors.white;
  EquipmentData equipmentData = EquipmentData();

  Timer? timer = Timer.periodic(const Duration(minutes: 0), (timer) {});
  final LoginController loginController = Get.put(LoginController());
  // 位置信息
  LocationData? currentLocation;
  String? longitudeString;
  String? latitudeString;
  String userAccount = "";

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

  void login(pwd) {
    debugPrint('登录密码：$pwd');
    Map<String, dynamic> data = {
      'username': 'superadmin',
      'password': 'admin', //utf8.decode(base64Decode(pwd))
    };
    XHttp.get('/action/appLogin', data).then((res) {
      try {
        debugPrint("+++++++++++++");
        var d = json.decode(res.toString());
        debugPrint('登录成功${d['token']}');
        loginController.setSession(d['sessionid']);
        sharedAddAndUpdate("session", String, d['sessionid']);
        loginController.setToken(d['token']);
        sharedAddAndUpdate("token", String, d['token']);
        // debugPrint(d);
      } on FormatException catch (e) {
        debugPrint('登录错误1$e');
        Get.offNamed("/get_equipment");
      }
    }).catchError((onError) {
      Get.offNamed("/get_equipment");
      debugPrint('登录错误2${onError.toString()}');
    });
  }

  void appLogin() {
    // Map<String, dynamic> data = {
    //   'username': _account.trim(),
    //   'password': _password.trim(),
    // };
    
    Dio dio = Dio();

    String url =
        "$wifiGetWayUrl/action/appLogin?username=engineer&password=OPaviNb3o5qDKD1YPzp2X64Qsw0G3PMQLxOkLdp%2FWERkAphqhKCC00ZmZxOFOLBFN81FR7JprXF8lTkGpKdECl4IWbBiklCoAz1HsRUZYY%2BrbBFKGZO04NaawnWzqNEiHemaC0til1Hg6gkpc6DZVupOi8bGkEyCbpNQJN%2BU9zw=";
    debugPrint('$url=====');
    dio.get(url).then((response) {
      var loginResJson = jsonDecode(response.toString());
      debugPrint('结果返回=====$loginResJson');
      if (loginResJson['code'] == 200) {
        Map<String, dynamic> bindParma = {
            "account": userAccount,
            "deviceSn": sn,
            "lon": longitudeString,
            "lat": latitudeString
          };
          debugPrint("用户绑定设备的信息----${bindParma.toString()}");
          App.post('/platform/appCustomer/bindingCpe', data: bindParma)
              .then((res) {
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
          loginController.setToken(loginResJson['token']);
          loginController.setSession(loginResJson['sessionid']);
          String userInfo = jsonEncode({
            "user": _account,
            "pwd": base64Encode(
              utf8.encode(_password),
            )
          });
          sharedAddAndUpdate(
            sn.toString(),
            String,
            userInfo,
          );
          sharedAddAndUpdate("token", String, loginResJson['token']);
          sharedAddAndUpdate("session", String, loginResJson['sessionid']);
      }else {debugPrint('appLogin出错了=====');}
    }).catchError((err) {
      timer?.cancel();
      timer = null;
      if (err.response != null) {
        var resjson = json.decode(err.response.toString());
        var errRes = ExceptionLogin.fromJson(resjson);
        if (err['code'] == DioErrorType.connectTimeout) {
          debugPrint('timeout');
          ToastUtils.error(S.current.contimeout);
        }

        /// 顶部弹出
        // Get.snackbar("", "",
        //     titleText: Text(
        //       '提示',
        //       textAlign: TextAlign.left,
        //       style: TextStyle(fontSize: 40.sp),
        //     ),
        //     messageText: Text(
        //       errRes.code == 201
        //           ? '密码错误'
        //           : '已锁定，${errRes.webLoginRetryTimeout}s后解锁',
        //       textAlign: TextAlign.left,
        //       style: TextStyle(fontSize: 30.sp),
        //     ),
        //     backgroundColor: const Color(0xfffff000));
        if (errRes.success == false) {
          Get.offNamed('/loginPage');
          if (errRes.code == 201) {
            ToastUtils.toast(
                '${S.current.passError}${5 - int.parse(errRes.webLoginFailedTimes.toString())}');
          } else if (errRes.code == 202) {
            ToastUtils.error(
                '${S.current.locked}${errRes.webLoginRetryTimeout}${S.current.unlock}');
          }
        }
        debugPrint('登录失败：${errRes.code}');
      }
    });

    // XHttp.get('/action/appLogin', data).then((res) {
    //   debugPrint('------登录------');
    //   debugPrint(res);
    //   // 以 { 或者 [ 开头的
    //   RegExp exp = RegExp(r'^[{[]');
    //   if (res != null && exp.hasMatch(res)) {
    //     var localLoginRes = json.decode(res.toString());
    //     printInfo(info: '登录返回$localLoginRes');
    //     if (localLoginRes['code'] == 200) {
          
    //     }
    //   }
    // });
  }

  ///执行提交方法
  void onSubmit(BuildContext context) {
    closeKeyboard(context);
    if (_account.trim().isEmpty) {
      ToastUtils.toast(S.current.accountEmpty);
    } else if (_password.trim().isEmpty) {
      ToastUtils.toast(S.current.passwordEmpty);
    } else {
      Map<String, dynamic> data = {
        'username': _account.trim(),
        'password': base64Encode(utf8.encode(_password.trim().trim())),
        'rememberMe': 'true',
        'ismoble': 'ismoble'
      };
      List<String> loginInfo;
      if (data['username'] == 'superadmin' &&
          data['password'] == base64Encode(utf8.encode('admin123'))) {
        loginInfo = [data['username'], data['password'], '', ''];
        sharedAddAndUpdate("loginInfo", List, loginInfo); //把登录信息保存到本地
      }
    }
  }

  ///账号
  Container buildAccountTextField() {
    return Container(
      padding: EdgeInsets.only(top: 34.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0XFF302F4F), width: 0.0)),
                ),
                child: SizedBox(
                  width: 1.sw - 200.w,
                  child: TextFormField(
                      initialValue: _account,
                      style: TextStyle(
                          fontSize: 32.sp, color: const Color(0xff051220)),
                      decoration: InputDecoration(
                        icon: const Icon(Icons.perm_identity),
                        // 表单提示信息
                        hintText: S.current.accountEnter,
                        hintStyle: TextStyle(
                            fontSize: 32.sp, color: const Color(0xff737A83)),
                        // 取消自带的下边框
                        border: InputBorder.none,
                      ),
                      onSaved: (String? value) => {
                            _account = value!,
                          },
                      onChanged: (String value) => _account = value,
                      onTap: () {
                        setState(() {
                          _passwordBorderColor = Colors.white;
                          _accountBorderColor = const Color(0xff2692F0);
                        });
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///密码
  Container buildPasswordTextField() {
    return Container(
      padding: EdgeInsets.only(top: 34.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0XFF302F4F), width: 0.0)),
                ),
                child: SizedBox(
                  width: 1.sw - 200.w,
                  child: TextFormField(
                      initialValue: _password,
                      style: TextStyle(
                          fontSize: 32.sp, color: const Color(0xff051220)),
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock),
                        // 表单提示信息
                        hintText: S.current.passwordLabel,
                        hintStyle: TextStyle(
                            fontSize: 32.sp, color: const Color(0xff737A83)),
                        // 取消自带的下边框
                        border: InputBorder.none,
                      ),
                      obscureText: _isObscure,
                      onSaved: (String? value) => _password = value!,
                      onChanged: (String value) => _password = value,
                      onTap: () {
                        setState(() {
                          _accountBorderColor = Colors.white;
                          _passwordBorderColor = const Color(0xff2692F0);
                        });
                      },
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///登录按钮
  SizedBox buildLoginButton() {
    return SizedBox(
      width: 1.sw - 104.w,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            EdgeInsets.only(top: 28.w, bottom: 28.w),
          ),
          shape: MaterialStateProperty.all(const StadiumBorder()),
          backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 30, 104, 233)),
        ),
        onPressed: () {
          // onSubmit(context);
          appLogin();
          // if ((_formKey.currentState as FormState).validate()) {
            
          // }
        },
        child: Text(
          S.of(context).login,
          style: TextStyle(fontSize: 32.sp, color: const Color(0xffffffff)),
        ),
      ),
    );
  }

  //以太网状态1连接
  String linkStatus = '';

  bool loading = false;

  //读取以太网状态
  void getNetType() async {
    setState(() {
      loading = true;
    });
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param': '["ethernetLinkStatus"]',
    };
    try {
      var response = await XHttp.get('/pub/pub_data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        linkStatus = d['ethernetLinkStatus'];
        debugPrint("当前返回的状态是$linkStatus");
      });
    } catch (e) {
      debugPrint('获取以太网状态失败：${e.toString()}');
    }
    setState(() {
      loading = false;
    });
  }

  //保存
  void handleSave(params) async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': params,
    };
    XHttp.get('/pub/pub_data.html', data).then((res) {
      try {
        ToastUtils.toast(S.current.success);
      } on FormatException catch (e) {
        debugPrint(e.toString());
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  @override
  void initState() {
    sharedGetData("baseLocalUrl", String).then((value) {
      debugPrint("baseLocalUrl:${value.toString()}");
      if (StringUtil.isNotEmpty(value)) {
        wifiGetWayUrl = value as String;
      }
    });
    sharedGetData("user_phone", String).then((data) {
      debugPrint("当前获取的用户信息:${data.toString()}");
      if ((data.toString()).isNotEmpty) {
        userAccount = data as String;
      }
    });
    getNetType();
    getLocationInformation();
    ipValue.text = '172.16.11.207';
    sMValue.text = '255.255.255.0';
    gatewayValue.text = '172.16.11.253';
    dNSValue.text = '172.16.100.254';
    dNS2Value.text = '114.114.114.114';
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).band,
          style: const TextStyle(fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          //设置状态栏的背景颜色
          statusBarColor: Colors.transparent,
          //状态栏的文字的颜色
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.offNamed("/get_equipment");
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: loading
          ? const Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: WaterLoading(
                  color: Color.fromARGB(255, 65, 167, 251),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => closeKeyboard(context),
              behavior: HitTestBehavior.opaque,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                ),
                height: 2000.h,
                child: Stack(
                  children: [
                    if (linkStatus == '1')
                      Stepper(
                        // type: StepperType.horizontal, //横向
                        currentStep: currentStep, //当前步骤的索引
                        //当用户点击步骤时调用的回调函数
                        onStepTapped: (value) {
                          setState(() {
                            currentStep = value;
                          });
                          debugPrint("绑定代码执行到这里了");
                        },
                        //下一步 回调
                        onStepContinue: () {
                          debugPrint("绑定代码执行到这里了");
                          setState(() {
                            debugPrint("绑定代码执行到这里了1");
                            if (currentStep < 2) {
                              debugPrint("绑定代码执行到这里了2");
                              // 如果第一步选择的自动获取
                              if (_selectedIndex == 0) {
                                //第1步选择自动获取时的下一步
                                debugPrint("绑定执行到这一步了");
                                handleSave(
                                    ' {"ethernetConnectMode":"dhcp","ethernetMtu":"1500","ethernetConnectOnly":"1","ethernetDetectServer":"0"}');
                                currentStep += 2;
                                debugPrint("当前的步骤是:======$currentStep======");
                              } else {
                                currentStep += 1;
                                if (currentStep == 2) {
                                  //选择静态ip 第2步的下一步
                                  handleSave(
                                      '{"ethernetConnectMode":"static","ethernetIp":"${ipValue.text}","ethernetMask":"${sMValue.text}","ethernetDefaultGateway":"${gatewayValue.text}","ethernetPrimaryDns":"${dNSValue.text}","ethernetSecondaryDns":"${dNS2Value.text}","ethernetMtu":"1500","ethernetConnectOnly":"1","ethernetDetectServer":"0"}');
                                }
                              }
                            }
                          });
                        },
                        //上一步 回调
                        onStepCancel: () {
                          setState(() {
                            if (currentStep > 0) {
                              // 如果第一步同上
                              if (_selectedIndex == 0) {
                                currentStep -= 2;
                              } else {
                                currentStep -= 1;
                              }
                            }
                          });
                        },
                        controlsBuilder: (BuildContext context,
                            ControlsDetails controlsDetails) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              if (currentStep != 0) // 第一步时不显示上一步
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(200, 30),
                                      backgroundColor: const Color.fromARGB(
                                          255, 30, 104, 233)),
                                  onPressed: controlsDetails.onStepCancel,
                                  child: Text(S.of(context).Previous),
                                ),
                              if (currentStep != 2) // 最后一步时不显示下一步
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: const Size(200, 30),
                                      backgroundColor: const Color.fromARGB(
                                          255, 30, 104, 233)),
                                  onPressed: controlsDetails.onStepContinue,
                                  child: Text(S.of(context).Next),
                                ),
                            ],
                          );
                        },
                        //步骤列表
                        steps: [
                          // 1 选择上网方式
                          Step(
                            title: Text(S.of(context).interentMode),
                            content: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => _selectIndex(0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(S.of(context).autoip),
                                          subtitle:
                                              Text(S.of(context).IPAcquisition),
                                          trailing: Icon(
                                            Icons.album,
                                            color: _selectedIndex == 0
                                                ? Colors.blue
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => {_selectIndex(1)},
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(S.of(context).staticIP),
                                          subtitle:
                                              Text(S.of(context).ManuallyIP),
                                          trailing: Icon(
                                            Icons.album,
                                            color: _selectedIndex == 1
                                                ? Colors.blue
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isActive: currentStep == 0,
                          ),
                          // 2 网络配置
                          Step(
                            title: Text(
                              S.of(context).NetworkConfig,
                            ),
                            content: InfoBox(
                              boxCotainer: Column(
                                children: [
                                  // ip地址
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(S.of(context).IPAddress,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 5, 0, 0),
                                                  fontSize: 28.sp)),
                                        ],
                                      ),
                                      BottomLine(
                                          rowtem: Row(
                                        children: [
                                          SizedBox(
                                            width: 400.w,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: ipValue,
                                              style: TextStyle(
                                                  fontSize: 26.sp,
                                                  color:
                                                      const Color(0xff051220)),
                                              decoration: InputDecoration(
                                                hintText: S.of(context).enter,
                                                hintStyle: TextStyle(
                                                    fontSize: 26.sp,
                                                    color: const Color(
                                                        0xff737A83)),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                  // 子网掩码
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(S.of(context).SubnetMask,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 5, 0, 0),
                                                  fontSize: 28.sp)),
                                        ],
                                      ),
                                      BottomLine(
                                          rowtem: Row(
                                        children: [
                                          SizedBox(
                                            width: 400.w,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: sMValue,
                                              style: TextStyle(
                                                  fontSize: 26.sp,
                                                  color:
                                                      const Color(0xff051220)),
                                              decoration: InputDecoration(
                                                hintText: S.of(context).enter,
                                                hintStyle: TextStyle(
                                                    fontSize: 26.sp,
                                                    color: const Color(
                                                        0xff737A83)),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                  // 默认网关
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(S.of(context).DefaultGateway,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 5, 0, 0),
                                                  fontSize: 28.sp)),
                                        ],
                                      ),
                                      BottomLine(
                                          rowtem: Row(
                                        children: [
                                          SizedBox(
                                            width: 400.w,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: gatewayValue,
                                              style: TextStyle(
                                                  fontSize: 26.sp,
                                                  color:
                                                      const Color(0xff051220)),
                                              decoration: InputDecoration(
                                                hintText: S.of(context).enter,
                                                hintStyle: TextStyle(
                                                    fontSize: 26.sp,
                                                    color: const Color(
                                                        0xff737A83)),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),

                                  // 首选DNS服务器
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(S.of(context).DNSServer,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 5, 0, 0),
                                                  fontSize: 28.sp)),
                                        ],
                                      ),
                                      BottomLine(
                                          rowtem: Row(
                                        children: [
                                          SizedBox(
                                            width: 400.w,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: dNSValue,
                                              style: TextStyle(
                                                  fontSize: 26.sp,
                                                  color:
                                                      const Color(0xff051220)),
                                              decoration: InputDecoration(
                                                hintText: S.of(context).enter,
                                                hintStyle: TextStyle(
                                                    fontSize: 26.sp,
                                                    color: const Color(
                                                        0xff737A83)),
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                  // 备用DNS服务器(选填)
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(S.of(context).DNS2Server,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 5, 0, 0),
                                                  fontSize: 28.sp)),
                                        ],
                                      ),
                                      BottomLine(
                                        rowtem: Row(
                                          children: [
                                            SizedBox(
                                              width: 400.w,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: dNS2Value,
                                                style: TextStyle(
                                                    fontSize: 26.sp,
                                                    color: const Color(
                                                        0xff051220)),
                                                decoration: InputDecoration(
                                                  hintText: S.of(context).enter,
                                                  hintStyle: TextStyle(
                                                      fontSize: 26.sp,
                                                      color: const Color(
                                                          0xff737A83)),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            isActive: currentStep == 1,
                          ),
                          // 3 设备登录
                          Step(
                            title: Text(S.of(context).Devicelogin),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        S.current.Administratorlogin,
                                        style: TextStyle(fontSize: 48.sp),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 10.w)),
                                      Text(
                                        '${S.of(context).currentDeive} $sn',
                                        style: TextStyle(
                                            fontSize: 28.sp,
                                            color: const Color(0xFF373543)),
                                      ),

                                      /// 账号
                                      // buildAccountTextField(),
                                      // Padding(
                                      //     padding: EdgeInsets.only(top: 20.w)),

                                      // /// 密码
                                      // buildPasswordTextField(),
                                      Padding(
                                          padding: EdgeInsets.only(top: 20.w)),

                                      /// 登录
                                      buildLoginButton(),
                                      Padding(
                                          padding: EdgeInsets.only(top: 20.w)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            isActive: currentStep == 2,
                          ),
                        ],
                      ),
                    if (linkStatus != '1')
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Text(
                                'Make sure the router is connected to power and plug in a network cable to the WAN port'),
                            Image.asset("assets/images/sureWan.png",
                                fit: BoxFit.fitWidth,
                                height: 600.w,
                                width: 600.w),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
    );
  }
}
