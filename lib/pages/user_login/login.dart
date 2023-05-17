import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../config/base_config.dart';
import '../../core/utils/Aes.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import '../toolbar/toolbar_controller.dart';

/// 用户登录
class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserLoginState();
}

//_formKey
final GlobalKey _formKey = GlobalKey<FormState>();

class _UserLoginState extends State<UserLogin> {
  final LoginController loginController = Get.put(LoginController());
  bool passwordValShow = true;
  var dio = Dio(BaseOptions(
    connectTimeout: 2000,
  ));

  @override
  void initState() {
    super.initState();
    phone.text = '19121757940';
    password.text = '123456';
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  final ToolbarController toolbarController = Get.put(ToolbarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
          borderBottom: false,
          // actions: [
          //   TextButton(
          //       onPressed: () {
          //         Get.offAllNamed("/get_equipment");
          //         sharedDeleteData('user_phone');
          //         sharedDeleteData('user_token');
          //         debugPrint('清除用户信息');
          //       },
          //       child: Text(
          //         S.of(context).skip,
          //         style: TextStyle(fontSize: 32.w, fontWeight: FontWeight.w600),
          //       )),
          // ],
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => closeKeyboard(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 52.w, right: 52.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 100.w)),
                    //logo&文字
                    Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 70.w),
                            child: Image.asset(
                              'assets/images/logo.png',
                            ),
                          ),
                          Text(
                            S.of(context).userLogin,
                            style: TextStyle(fontSize: 60.sp),
                          ),
                          Text(
                            S.of(context).cpeManagementPlatform,
                            style: TextStyle(
                                fontSize: 30.sp, color: Colors.black38),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50.w)),

                    //手机号
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0XFF302F4F), width: 0.0)),
                              ),
                              child: SizedBox(
                                width: 1.sw - 104.w,
                                child: TextFormField(
                                  controller: phone,
                                  keyboardType: TextInputType.number,
                                  // initialValue: _password,
                                  style: TextStyle(
                                      fontSize: 32.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.perm_identity),
                                    // 表单提示信息
                                    hintText: S.of(context).phoneLabel,
                                    hintStyle: TextStyle(
                                        fontSize: 32.sp,
                                        color: const Color(0xff737A83)),
                                    // 取消自带的下边框
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    RegExp reg = RegExp(
                                        r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                                    if (!reg.hasMatch(value!)) {
                                      return S.of(context).phoneError;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.w)),

                    /// 密码
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0XFF302F4F), width: 0.0)),
                              ),
                              child: SizedBox(
                                width: 1.sw - 104.w,
                                child: TextFormField(
                                  obscureText: passwordValShow,
                                  controller: password,
                                  style: TextStyle(
                                      fontSize: 32.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordValShow = !passwordValShow;
                                          });
                                        },
                                        icon: Icon(!passwordValShow
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    // 表单提示信息
                                    hintText: S.of(context).passwordLabel,
                                    hintStyle: TextStyle(
                                        fontSize: 32.sp,
                                        color: const Color(0xff737A83)),
                                    // 取消自带的下边框
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return S.of(context).passwordLabel;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.w)),

                    /// 注册&忘记密码
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //注册
                        TextButton(
                            onPressed: (() {
                              Get.offAllNamed("/user_register");
                            }),
                            child: Text(
                              S.of(context).register,
                              style: const TextStyle(color: Colors.black45),
                            )),
                        // 忘记密码
                        TextButton(
                            onPressed: (() {
                              // Get.offAllNamed("/forget_password");
                            }),
                            child: const Text('',
                                style: TextStyle(color: Colors.black45)))
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 200.w)),

                    /// 登录
                    SizedBox(
                      width: 1.sw - 104.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.only(top: 28.w, bottom: 28.w),
                          ),
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 30, 104, 233)),
                        ),
                        onPressed: () {
                          if ((_formKey.currentState as FormState).validate()) {
                            Map<String, dynamic> data = {
                              "account": phone.text,
                              "password": AESUtil.generateAES(password.text),
                            };
                            // 根据输入的用户名密码登录云平台
                            dio
                                .post(
                                    '${BaseConfig.cloudBaseUrl}/platform/appCustomer/login',
                                    data: data)
                                .then((res) {
                              var d = json.decode(res.toString());
                              if (d['code'] != 200) {
                                ToastUtils.error("$d{['message']}");
                                debugPrint("$d");
                                return;
                              } else {
                                // 是否存储了设备sn
                                sharedGetData('deviceSn', String).then((sn) {
                                  if (sn != null) {
                                    debugPrint('设备sn号$sn');
                                    Get.offNamed("/home");
                                    toolbarController.setPageIndex(0);
                                  } else {
                                    Get.offNamed("/get_equipment");
                                  }
                                });
                                //存储用户信息
                                sharedAddAndUpdate(
                                    "user_token", String, (d['data']['token']));
                                sharedAddAndUpdate("user_phone", String,
                                    (d['data']['account']));
                              }
                            }).catchError((err) {
                              debugPrint('响应------>$err');
                              // 响应超时
                              if ((err is DioError &&
                                      err.type ==
                                          DioErrorType.connectTimeout) ||
                                  err['code'] == DioErrorType.connectTimeout) {
                                debugPrint('timeout');
                                ToastUtils.error(S.current.contimeout);
                              } else {
                                ToastUtils.error(S.current.loginFailed);
                              }
                            });
                          } else {
                            return;
                          }
                        },
                        child: Text(
                          S.of(context).userLogin,
                          style: TextStyle(
                              fontSize: 32.sp, color: const Color(0xffffffff)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

final TextEditingController phone = TextEditingController();
final TextEditingController password = TextEditingController();
