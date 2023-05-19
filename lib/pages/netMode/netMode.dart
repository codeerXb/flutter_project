import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/exception_login.dart';
import 'package:get/get.dart';
import '../../generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';

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
  final bool _isObscure = true;
  final Color _eyeColor = Colors.grey;
  Color _accountBorderColor = Colors.white;
  Color _passwordBorderColor = Colors.white;
  EquipmentData equipmentData = EquipmentData();

  Timer? timer = Timer.periodic(const Duration(minutes: 0), (timer) {});
  final LoginController loginController = Get.put(LoginController());

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
    Map<String, dynamic> data = {
      'username': _account.trim(),
      'password': _password.trim(),
    };
    XHttp.get('/action/appLogin', data).then((res) {
      debugPrint('------登录------');
      debugPrint(res);
      // 以 { 或者 [ 开头的
      RegExp exp = RegExp(r'^[{[]');
      if (res != null && exp.hasMatch(res)) {
        var d = json.decode(res.toString());
        printInfo(info: '登录返回$d');
        if (d['code'] == 200) {
          App.post(
                  '${BaseConfig.cloudBaseUrl}/platform/appCustomer/bindingCpe?deviceSn=$sn')
              .then((res) {
            var d = json.decode(res.toString());

            debugPrint('本地登录响应------>$d');
            if (d['code'] != 200) {
              ToastUtils.error(S.current.check);
              return;
            } else {
              ToastUtils.toast(d['message']);
              loginController.setUserEquipment('deviceSn', sn);
              sharedAddAndUpdate("deviceSn", String, sn);
              timer = Timer.periodic(const Duration(minutes: 5), (timer) {
                debugPrint('登录当前时间${DateTime.now()}');
                // 再次请求登录
                login(_password.trim());
              });
              Get.offNamed("/home", arguments: {"sn": sn, "vn": vn});
            }
          }).catchError((err) {
            timer?.cancel();
            timer = null;
            debugPrint('响应------>$err');
            //相应超超时
            if (err['code'] == DioErrorType.connectTimeout) {
              debugPrint('timeout');
              ToastUtils.error(S.current.contimeout);
            }
          });
          loginController.setToken(d['token']);
          loginController.setSession(d['sessionid']);
          sharedAddAndUpdate(
              sn.toString(), String, base64Encode(utf8.encode(_password)));
          sharedAddAndUpdate("token", String, d['token']);
          sharedAddAndUpdate("session", String, d['sessionid']);
        }
      }
    }).catchError((err) {
      timer?.cancel();
      timer = null;
      if (err.response != null) {
        var resjson = json.decode(err.response.toString());
        var errRes = ExceptionLogin.fromJson(resjson);

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
        loginInfo = [
          data['username'],
          data['password'],
          '管理员',
          'http://c.hiphotos.baidu.com/image/pic/item/9c16fdfaaf51f3de1e296fa390eef01f3b29795a.jpg'
        ];
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
          printInfo(info: '登陆了');
          if ((_formKey.currentState as FormState).validate()) {
            onSubmit(context);
            appLogin();
          }
        },
        child: Text(
          S.of(context).login,
          style: TextStyle(fontSize: 32.sp, color: const Color(0xffffffff)),
        ),
      ),
      // CommonWidget.buttonWidget(
      //     title:S.of(context).login,
      //     padding: EdgeInsets.only(left: 0, top: 32.w, bottom: 30.w, right: 0),
      //     callBack: () {
      //       if ((_formKey.currentState as FormState).validate()) {
      //         onSubmit(context);
      //       }
      //     }),
    );
  }

  //以太网状态1连接
  String linkStatus = '1';
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
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        linkStatus = d['ethernetLinkStatus'];
      });
    } catch (e) {
      debugPrint('获取以太网状态失败：$e.toString()');
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
    XHttp.get('/data.html', data).then((res) {
      try {
        ToastUtils.toast(S.current.success);
      } on FormatException catch (e) {
        print(e);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  @override
  void initState() {
    getNetType();
    ipValue.text = '172.16.11.207';
    sMValue.text = '255.255.255.0';
    gatewayValue.text = '172.16.11.253';
    dNSValue.text = '172.16.100.254';
    dNS2Value.text = '114.114.114.114';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          ? const Center(child: CircularProgressIndicator())
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
                        onStepTapped: (value) {},
                        //下一步 回调
                        onStepContinue: () {
                          setState(() {
                            if (currentStep < 2) {
                              // 如果第一步选择的自动获取
                              if (_selectedIndex == 0) {
                                //第1步选择自动获取时的下一步
                                handleSave(
                                    ' {"ethernetConnectMode":"dhcp","ethernetMtu":"1500","ethernetConnectOnly":"1","ethernetDetectServer":"0"}');
                                currentStep += 2;
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
                                      buildAccountTextField(),
                                      Padding(
                                          padding: EdgeInsets.only(top: 20.w)),

                                      /// 密码
                                      buildPasswordTextField(),
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
                    if (linkStatus == '2')
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text('确保路由器连接电源并于WAN口插入网线'),
                            Image.asset("assets/images/sureWan.png",
                              fit: BoxFit.fitWidth, height: 600.w, width: 600.w),
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
