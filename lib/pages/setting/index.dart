import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/http_app.dart';
// import 'package:flutter_template/core/utils/logger.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/model/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:flutter_template/pages/login/model/exception_login.dart';
import 'package:flutter_template/pages/setting/user_card.dart';
import 'package:flutter_template/pages/toolbar/toolbar_controller.dart';
import 'package:get/get.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/string_util.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';

/// 我的页面
class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final ToolbarController toolbarController = Get.put(ToolbarController());
  // 获取sn
  String sn = '';

  String routeOnly = "";

  /// 用户信息
  UserModel userModel = UserModel();
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey _formKey = GlobalKey<FormState>();
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
  String _account = 'superadmin';
  String _password = 'admin';
  final bool _isObscure = true;
  EquipmentData equipmentData = EquipmentData();
  bool _isLoading = false;

  Color _accountBorderColor = Colors.white;
  Color _passwordBorderColor = Colors.white;
  //验证云平台登录
  String _User = '';
  String userAccount = "";
  String localUrl = "";
  @override
  void initState() {
    sharedGetData("user_phone", String).then((data) {
      debugPrint("当前获取的用户信息:${data.toString()}");
      if (StringUtil.isNotEmpty(data)) {
        userAccount = data as String;
      }
    });
    sharedGetData("baseLocalUrl", String).then((value) {
      debugPrint("baseLocalUrl:${value.toString()}");
      if (StringUtil.isNotEmpty(value)) {
        localUrl = value as String;
      }
    });

    sharedGetData("loginInfo", List).then((data) {
      if (StringUtil.isNotEmpty(data)) {
        List<String> loginInfo = data as List<String>;
        setState(() {
          userModel = UserModel(deptId: '', deptName: '', phone: '', email: '');
          userModel.nickName = loginInfo[2];
          userModel.avatar = loginInfo[3];
        });
      }
    });
    sharedGetData('user_token', String).then(((res) {
      setState(() {
        _User = res.toString();
      });
    }));
    sharedGetData('deviceSn', String).then(((res) {
      debugPrint("个人中心的deviceSn $res");
      setState(() {
        sn = res.toString();
      });
    }));

    sharedGetData("systemRouterOnly", String).then(((res) {
      debugPrint("获取的systemRouterOnly $res");
      if (res != null) {
        setState(() {
          routeOnly = res.toString();
        });
      }
    }));
    super.initState();
  }

  void appLogin() {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> data = {
      'username': "superadmin",
      'password': "admin",
    };
    XHttp.get('/action/appLogin', data).then(
      (res) {
        debugPrint('------登录------');
        debugPrint(res);
        // 以 { 或者 [ 开头的
        RegExp exp = RegExp(r'^[{[]');
        if (res != null && exp.hasMatch(res)) {
          var localLoginRes = json.decode(res.toString());
          printInfo(info: '登录返回$localLoginRes');
          if (localLoginRes['code'] == 200) {
            loginController.setToken(localLoginRes['token']);
            loginController.setSession(localLoginRes['sessionid']);
            String userInfo = jsonEncode({
              "user": "superadmin",
              "pwd": base64Encode(
                utf8.encode("admin"),
              )
            });
            sharedAddAndUpdate(
              sn.toString(),
              String,
              userInfo,
            );
            sharedAddAndUpdate("token", String, localLoginRes['token']);
            sharedAddAndUpdate("session", String, localLoginRes['sessionid']);
            Get.toNamed('/wan_settings');
          }
        }
      },
    ).catchError(
      (err) {
        if (err.type == DioErrorType.connectTimeout) {
          debugPrint('timeout');
          ToastUtils.error(S.current.contimeout);
        }
        if (err.response != null) {
          var resjson = json.decode(err.response.toString());
          var errRes = ExceptionLogin.fromJson(resjson);

          if (errRes.success == false) {
            if (errRes.code == 201) {
              Get.snackbar(
                'Warnning',
                '${S.current.passError}${5 - int.parse(errRes.webLoginFailedTimes.toString())}',
              );
              // ToastUtils.toast(
              //     '${S.current.passError}${5 - int.parse(errRes.webLoginFailedTimes.toString())}');
            } else if (errRes.code == 202) {
              Get.snackbar('Warnning',
                  '${S.current.locked}${errRes.webLoginRetryTimeout}${S.current.unlock}');
              // ToastUtils.error(
              //     '${S.current.locked}${errRes.webLoginRetryTimeout}${S.current.unlock}');
            }
          }
          debugPrint('登录失败：${errRes.code}');
        }
      },
    ).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
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
        'username': "superadmin",
        'password': "admin",
        'rememberMe': 'true',
        'ismoble': 'ismoble'
      };
      List<String> loginInfo;
      loginInfo = [
        data['username'],
        data['password'],
        '管理员',
        'http://c.hiphotos.baidu.com/image/pic/item/9c16fdfaaf51f3de1e296fa390eef01f3b29795a.jpg'
      ];
      sharedAddAndUpdate("loginInfo", List, loginInfo); //把登录信息保存到本地
    }
  }

  ///账号
  Container buildAccountTextField() {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 34.h),
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Color(0XFF302F4F), width: 0.0)),
            ),
            child: TextFormField(
                initialValue: _account,
                style:
                    TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
                decoration: InputDecoration(
                  icon: const Icon(Icons.perm_identity),
                  // 表单提示信息
                  hintText: S.current.passwordLabel,
                  hintStyle: TextStyle(
                      fontSize: 32.sp, color: const Color(0xff737A83)),
                  // 取消自带的下边框
                  border: InputBorder.none,
                ),
                onSaved: (String? value) => _account = value!,
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
          // Text(
          //   "密码",
          //   style: TextStyle(fontSize: 32.sp, color: const Color(0xff737A83)),
          // ),
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Color(0XFF302F4F), width: 0.0)),
                ),
                child: SizedBox(
                  width: 1.sw - 258.w,
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

  /// 登录&取消按钮
  Row buildLoginButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 200.w,
          child: ElevatedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.only(top: 28.w, bottom: 28.w),
              ),
              shape: MaterialStateProperty.all(const StadiumBorder()),
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 72, 72, 72)),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // 关闭弹窗
            },
            child: Text(S.current.cancel),
          ),
        ),
        SizedBox(
          width: 200.w,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading)
                  const SizedBox(
                    width: 28,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                Text(
                  S.of(context).login,
                  style: TextStyle(
                      fontSize: 32.sp, color: const Color(0xffffffff)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          title: S.of(context).advancedSet,
          backgroundColor: const Color.fromRGBO(91, 149, 255, 0.9),
          titleColor: Colors.white,
          borderBottom: false),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// 头部
            UserCard(name: sn),

            Expanded(
                // flex: 1,
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 扫一扫
                  // scanCode(),

                  /// 联系客服
                  // contactCustomer(),

                  /// 图表统计
                  // chartCal(),

                  /// 文件上传与下载
                  // fileUplodAndDownload(),
                  // const Divider(),

                  // 网络测试
                  // test(),
                  // 添加设备
                  // addEquipments(),

                  //解绑
                  unbindingDevice(),
                  //订阅服务
                  // subService(),

                  /// Wi-Fi设置
                  const TitleWidger(title: 'Wi-Fi'),

                  /// WLAN设置
                  wlanSet(),

                  /// 访客网络
                  visitorNet(),

                  /// 地区设置
                  majorSet(),

                  /// WPS设置
                  wpsSet(),

                  /// WiFi访问控制
                  // accessControl(),
                  // const Divider(),
                  TitleWidger(title: S.of(context).deviceInfo),

                  /// 设备信息
                  commonProblem(),

                  // const Divider(),
                  //系统设置
                  TitleWidger(title: S.of(context).SystemSettings),

                  /// 维护设置
                  maintainSettings(),

                  /// 登录管理
                  // accountSecurity(),
                  // const Divider(),

                  ///以太网设置
                  // netSet(),
                  // const Divider(),

                  TitleWidger(title: S.of(context).netSet),

                  /// 以太网状态
                  feedback(),

                  /// WAN设置
                  wanSettings(),

                  /// DNS设置
                  dnsSettings(),

                  /// Radio设置
                  // radioSettings(),

                  /// LAN设置
                  lanSettings(),
                  // const Divider(),
                  /// Wi-Fi覆盖图(暂时去掉)
                  // wifiMapping(),

                  /// 系统设置
                  systemSettings(),

                  /// router版本升级
                  routerVersionUpgrade(),

                  /// 关于我们
                  aboutUs(),

                  /// 清除缓存
                  clearCache(),

                  ///注销账号
                  deleteUserAccount()
                  // const Divider(),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

// // 网络测试
//   Widget test() {
//     return CommonWidget.simpleWidgetWithMine(
//         title: "网络测试",
//         icon: const Icon(Icons.add_circle_outline,
//             color: Color.fromARGB(255, 61, 103, 243)),
//         callBack: () {
//           Get.toNamed("/get_test");
//         });
//   }

  // 添加设备
  Widget addEquipments() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).addDevice,
        icon: const Icon(Icons.add_circle_outline,
            color: Color.fromARGB(255, 61, 103, 243)),
        callBack: () {
          Get.toNamed("/add_equipment");
        });
  }

  //解绑
  _openAvatarBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: 260.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w))),
            child: Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.w),
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.w),
                              topRight: Radius.circular(30.w))),
                      height: 80.w,
                      alignment: Alignment.center,
                      child: Text(
                        S.of(context).hint,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 60.w,
                      alignment: Alignment.topLeft,
                      child: Text(
                        "${S.of(context).unblockdevice} $sn?",
                        style:
                            TextStyle(color: Colors.black45, fontSize: 22.sp),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.w)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // 取消解绑
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          width: 0.5.sw - 30.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.w),
                                  bottomLeft: Radius.circular(30.w))),
                          // height: 80.w,
                          alignment: Alignment.center,
                          child: Text(
                            S.current.cancel,
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      // 确定解绑
                      InkWell(
                        onTap: () {
                          var param = {"account": userAccount, "deviceSn": sn};
                          App.post('/platform/appCustomer/unBoundCpe',
                                  data: param)
                              .then((res) {
                            var d = json.decode(res.toString());
                            debugPrint('响应------>$d');
                            if (d['code'] == 200) {
                              ToastUtils.toast(d['message']);
                              sharedDeleteData("deviceSn");
                              sharedDeleteData("systemVersionSn");
                              Get.offAllNamed("/get_equipment");
                              toolbarController.setPageIndex(0);
                              return;
                            } else {
                              ToastUtils.error(S.current.unbindError);
                            }
                          }).catchError((err) {
                            printError(
                                info:
                                    '${S.current.contimeout}${err.toString()}');
                            ToastUtils.error(S.current.contimeout);
                          });
                        },
                        child: Container(
                          height: 60.w,
                          width: 0.5.sw - 30.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.w),
                                  bottomRight: Radius.circular(30.w))),
                          alignment: Alignment.center,
                          child: Text(
                            S.of(context).confirm,
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// 头部
  Widget topWidget() {
    return Container(
      height: 230.w,
      decoration: const BoxDecoration(color: Color.fromRGBO(91, 149, 255, 0.9)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 头像 + 名字
          InkWell(
            onTap: () {
              Get.toNamed("/user_detail", arguments: userModel);
            },
            child: Container(
              height: 100.w,
              padding: EdgeInsets.only(left: 20.w),
              child: ListTile(
                contentPadding: EdgeInsets.only(left: -25.w, right: -25.w),
                leading: CommonWidget.imageWidget(
                    imageUrl: userModel.avatar, hasDefault: true),
                title: Text(
                  userModel.nickName ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 30.w),
                ),
              ),
            ),
          ),
          SizedBox(
              height: 130.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                            text: '9,999',
                            style:
                                TextStyle(color: Colors.white, fontSize: 35.w),
                            children: [
                              TextSpan(
                                text: ' 元',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22.w),
                              ),
                            ]),
                      ),
                      const Text(
                        '余额',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.currency_yen_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        '充值',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        '余额明细',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }

  /// 扫一扫
  Widget scanCode() {
    return CommonWidget.simpleWidgetWithMine(
        title: '扫一扫',
        icon: const Icon(Icons.crop_free_outlined,
            color: Color.fromRGBO(88, 202, 147, 1)),
        callBack: () {
          Get.toNamed("/scan_code")?.then((value) => {
                ToastUtils.toast("扫描的信息：$value"),
              });
        });
  }

  /// 设备信息
  Widget commonProblem() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).deviceInfo,
        icon: const Image(image: AssetImage('assets/images/equ_info.png')),
        callBack: () {
          Get.toNamed("/common_problem");
        });
  }

  /// 解绑设备
  Widget unbindingDevice() {
    return CommonWidget.simpleWidgetWithMine(
        title: _User == 'null' ? S.of(context).band : S.of(context).UntyingEqui,
        icon: Image(
          image: _User == 'null'
              ? const AssetImage('assets/images/band.png')
              : const AssetImage('assets/images/line.png'),
          width: 28,
          height: 28,
        ),
        callBack: () {
          _User == 'null' ? print(1) : _openAvatarBottomSheet();
        });
  }

  /// 订阅服务
  // Widget subService() {
  //   return CommonWidget.simpleWidgetWithMine(
  //       title: S.of(context).subService,
  //       icon: const Icon(
  //         Icons.monetization_on,
  //         color: Colors.blue,
  //       ),
  //       callBack: () {
  //         Get.toNamed("/sub_service");
  //       });
  // }

  /// 以太网状态
  Widget feedback() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).EthernetStatus,
        icon: const Image(image: AssetImage('assets/images/net_type.png')),
        callBack: () {
          if (routeOnly == "1") {
            Get.toNamed("/feed_back");
          } else {
            Get.toNamed("/wanStatusPage");
          }
        });
  }

  /// 维护设置
  Widget maintainSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).maintainSettings,
        icon: const Image(image: AssetImage('assets/images/maintain_set.png')),
        callBack: () {
          Get.toNamed("/maintain_settings");
        });
  }

  /// 登录管理
  Widget accountSecurity() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).accountSecurity,
        icon: const Image(image: AssetImage('assets/images/login_admin.png')),
        callBack: () {
          /// 子页面带返回值的
          Get.toNamed("/account_security")
              ?.then((value) => {debugPrint("新密码：$value")});
        });
  }

  /// 清除缓存
  Widget clearCache() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).clearCache,
        icon: const Image(image: AssetImage('assets/images/clear_cache.png')),
        callBack: () {
          Get.toNamed("/clear_cache");
        });
  }

  Widget deleteUserAccount() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).delAccount,
        icon: const Image(
          image: AssetImage('assets/images/Log out.png'),
          width: 25,
          height: 25,
        ),
        callBack: () {
          Get.toNamed("/delAccountPage",
              arguments: {"userAccount": userAccount});
        });
  }

  /// 关于我们
  Widget aboutUs() {
    return CommonWidget.simpleWidgetWithMine(
        title: 'About Us',
        icon: const Icon(Icons.person_outline_outlined,
            color: Color.fromRGBO(39, 66, 220, 1)),
        callBack: () {
          Get.toNamed("/about_us");
        });
  }

  /// 联系客服
  Widget contactCustomer() {
    return CommonWidget.simpleWidgetWithMine(
        title: '联系客服',
        icon: const Icon(Icons.connect_without_contact_outlined,
            color: Color.fromRGBO(0, 200, 255, 1)),
        callBack: () {
          Get.toNamed("/contact_customer");
        });
  }

  /// 系统设置
  Widget systemSettings() {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      child: CommonWidget.simpleWidgetWithMine(
          title: S.of(context).SystemSettings,
          icon: const Image(image: AssetImage('assets/images/sys_set.png')),
          callBack: () {
            Get.toNamed("/system_settings");
          }),
    );
  }

  Widget routerVersionUpgrade() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).RouterUpgrade,
        icon: const Image(
          image: AssetImage('assets/images/router_upgrade.png'),
          width: 25,
          height: 25,
        ),
        callBack: () {
          Get.toNamed("/routerUpgradePage");
        });
  }

  /// 图表
  Widget chartCal() {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      child: CommonWidget.simpleWidgetWithMine(
          title: '图表统计',
          icon: const Icon(Icons.table_chart_outlined,
              color: Color.fromRGBO(79, 203, 116, 1)),
          callBack: () {
            Get.toNamed("/chart_demo");
          }),
    );
  }

  /// 文件上传下载测试
  Widget fileUplodAndDownload() {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      child: CommonWidget.simpleWidgetWithMine(
          title: '文件上传与下载',
          icon: const Icon(Icons.cloud_sync_outlined,
              color: Color.fromRGBO(242, 100, 124, 1)),
          callBack: () {
            Get.toNamed("/file_upload_download");
          }),
    );
  }

  /// WAN设置
  /// 点击回调
  clickWanSettings() async {
    // 本地请求参数，请求获取sn
    // Map<String, dynamic> data = {
    //   'method': 'obj_get',
    //   'param': '["systemVersionSn"]',
    // };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Stack(
        children: [
          // Opacity(
          //   opacity: 0.3,
          //   child: ModalBarrier(dismissible: false, color: Colors.black),
          // ),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
    try {
      // var res = await XHttp.get('/pub/pub_data.html', data);
      // var jsonRes = json.decode(res.toString());
      // 得到jsonRes.systemVersionSn,比对本地存储的sn
      sharedGetData('deviceSn', String).then((value) {
        debugPrint("缓存中的设备是:${value.toString()}");
        if (value != null) {
          Dio dio = Dio();
          String url =
              "$localUrl/action/appLogin?username=engineer&password=OPaviNb3o5qDKD1YPzp2X64Qsw0G3PMQLxOkLdp%2FWERkAphqhKCC00ZmZxOFOLBFN81FR7JprXF8lTkGpKdECl4IWbBiklCoAz1HsRUZYY%2BrbBFKGZO04NaawnWzqNEiHemaC0til1Hg6gkpc6DZVupOi8bGkEyCbpNQJN%2BU9zw=";
          try {
            dio.get(url).then((response) {
              var loginResJson = jsonDecode(response.toString());
              if (loginResJson['code'] == 200) {
                // 存储token和session
                loginController.setSession(loginResJson['sessionid']);
                sharedAddAndUpdate(
                    "session", String, loginResJson['sessionid']);
                loginController.setToken(loginResJson['token']);
                sharedAddAndUpdate("token", String, loginResJson['token']);
              }
            }, onError: (e) {
              ToastUtils.showDialogPopup(
                context,
                S.current.warningSnNotSame,
                title: S.current.hint,
                leftBtnText: "",
                rightBtnText: S.current.confirm,
              );
            });
          } on DioError catch (e) {
            ToastUtils.toast(e.toString());
          }

          // 获取本地存取的设备用户名密码
          // sharedGetData(sn, String).then((value) async {
          //   debugPrint("缓存中的设备2是:${value.toString()}");
          //   if (value != null) {
          //     var userInfo = jsonDecode(value.toString());
          //     var user = userInfo["user"];
          //     var pwd = utf8.decode(base64Decode(userInfo["pwd"]));

          //     var loginRes = await XHttp.get('/action/appLogin', {
          //       'username': "engineer",
          //       'password': "OPaviNb3o5qDKD1YPzp2X64Qsw0G3PMQLxOkLdp%2FWERkAphqhKCC00ZmZxOFOLBFN81FR7JprXF8lTkGpKdECl4IWbBiklCoAz1HsRUZYY%2BrbBFKGZO04NaawnWzqNEiHemaC0til1Hg6gkpc6DZVupOi8bGkEyCbpNQJN%2BU9zw=",
          //     });
          //     var loginResJson = jsonDecode(loginRes.toString());
          //     if (loginResJson['code'] == 200) {
          //       // 存储token和session
          //       loginController.setSession(loginResJson['sessionid']);
          //       sharedAddAndUpdate(
          //           "session", String, loginResJson['sessionid']);
          //       loginController.setToken(loginResJson['token']);
          //       sharedAddAndUpdate("token", String, loginResJson['token']);
          //       // 跳转到wan-setting界面
          //       Get.toNamed('/wan_settings');
          //     }

          //   } else {
          //     showLoginDialog();
          //   }
          // }).catchError((err) {
          //   // 弹窗登录框
          //   showLoginDialog();
          // });
        } else {
          // sn不相同的情况
          // 提示“请连接设备WiFi后再操作”
          ToastUtils.showDialogPopup(
            context,
            S.current.warningSnNotSame,
            title: S.current.hint,
            leftBtnText: "",
            rightBtnText: S.current.confirm,
          );
        }
      }).catchError((err) {
        debugPrint(err.toString());
        // 如果没有sn，就是异常状况，需要让用户重新连接设备
        Get.snackbar(S.current.deviceException, S.current.reconnectDevice);
        Get.offNamed('/get_equipment');
      });
    } catch (e) {
      // 失败提示remote access refused
      ToastUtils.error(S.current.accessRefused);
      debugPrint(e.toString());
    } finally {
      Navigator.of(context).pop(); // 关闭弹窗
    }
  }

  Future<dynamic> showLoginDialog() {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: InkWell(
          onTap: () => closeKeyboard(context),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  left: 52.w, top: 40.w, right: 52.w, bottom: 40.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      S.current.Administratorlogin,
                      style: TextStyle(
                          fontSize: 48.sp,
                          color: const Color.fromARGB(255, 30, 104, 233)),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.w)),
                    Text(
                      '${S.of(context).currentDeive} $sn',
                      style: TextStyle(
                          fontSize: 24.sp, color: const Color(0xFF373543)),
                    ),

                    /// 账号
                    buildAccountTextField(),

                    /// 密码
                    buildPasswordTextField(),
                    Padding(padding: EdgeInsets.only(top: 102.w)),

                    /// 登录 & 取消
                    buildLoginButton(),
                    Padding(padding: EdgeInsets.only(top: 20.w)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget wanSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).wanSettings,
        icon: const Image(image: AssetImage('assets/images/wan.png')),
        callBack: () {
          // clickWanSettings();
          Get.toNamed("/wan_settings");
        });
  }

  /// DNS设置
  Widget dnsSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).dnsSettings,
        icon: const Image(image: AssetImage('assets/images/DNS.png')),
        callBack: () {
          Get.toNamed("/dns_settings");
        });
  }

  /// Radio设置
  Widget radioSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).radioSettings,
        icon: const Image(image: AssetImage('assets/images/radio.png')),
        callBack: () {
          Get.toNamed("/radio_settings");
        });
  }

  /// LAN设置
  Widget lanSettings() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).lanSettings,
        icon: const Image(image: AssetImage('assets/images/lan.png')),
        callBack: () {
          Get.toNamed("/lan_settings");
        });
  }

  /// Wi-Fi Mapping
  Widget wifiMapping() {
    return Container(
      padding: EdgeInsets.only(top: 20.w),
      child: CommonWidget.simpleWidgetWithMine(
          title: S.of(context).wifiMapping,
          icon: Image(
              width: 58.w,
              height: 58.w,
              image: const AssetImage('assets/images/signal_cover.png')),
          callBack: () {
            Get.toNamed("/test_edit");
          }),
    );
  }

  /// 以太网设置
  Widget netSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).EthernetSettings,
        icon: const Image(image: AssetImage('assets/images/net_set.png')),
        callBack: () {
          Get.toNamed("/net_set");
        });
  }

  /// WLAN设置
  Widget wlanSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).wlanSet,
        icon: const Image(image: AssetImage('assets/images/wlan.png')),
        callBack: () {
          Get.toNamed("/wlan_set");
        });
  }

  /// 访客网络
  Widget visitorNet() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).visitorNet,
        icon: const Image(image: AssetImage('assets/images/visitor_net.png')),
        callBack: () {
          Get.toNamed("/visitor_one");
        });
  }

  /// 地区设置
  Widget majorSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).majorSet,
        icon: const Image(image: AssetImage('assets/images/major_set.png')),
        callBack: () {
          Get.toNamed("/major_set");
        });
  }

  /// WPS设置
  Widget wpsSet() {
    return CommonWidget.simpleWidgetWithMine(
        title: S.of(context).wpsSet,
        icon: const Image(image: AssetImage('assets/images/WPS.png')),
        callBack: () {
          Get.toNamed("/wps_set");
        });
  }

  /// 访问控制
  Widget accessControl() {
    return CommonWidget.simpleWidgetWithMine(
        title: "AccessControl",
        icon: const Image(image: AssetImage('assets/images/WPS.png')),
        callBack: () {
          Get.toNamed("/access_control");
        });
  }

  /// 用户登录
  Widget useLogin() {
    return CommonWidget.simpleWidgetWithMine(
        title: '用户登录',
        icon: const Image(image: AssetImage('assets/images/WPS.png')),
        callBack: () {
          Get.toNamed("/user_login");
        });
  }

  /// 用户注册
  Widget useRegister() {
    return CommonWidget.simpleWidgetWithMine(
        title: '用户注册',
        icon: const Image(image: AssetImage('assets/images/WPS.png')),
        callBack: () {
          Get.toNamed("/user_register");
        });
  }
}
