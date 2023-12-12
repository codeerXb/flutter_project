import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/Aes.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_template/config/base_config.dart';

import '../../generated/l10n.dart';

/// 用户注册
class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserRegisterState();
}

//_formKey
final GlobalKey _formKey = GlobalKey<FormState>();

class _UserRegisterState extends State<UserRegister> {
  final LoginController loginController = Get.put(LoginController());
  //手机号
  dynamic _phoneVal = '';

  //密码
  String _passwordVal = '';
  bool passwordValShow = true;
  //再次输入密码
  String _againPassVal = '';
  bool againPassShow = true;
  //验证码
  String _codeValue = '';
  bool iscode = false; //获取验证码状态
  int codeNum = 60; //倒计时 60秒

  final TextEditingController _textController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  var dio = Dio(BaseOptions(
    connectTimeout: 2000,
  ));
  @override
  void initState() {
    super.initState();
  }

  var timer;
  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  }

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
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
                Get.offAllNamed("/user_login");
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: Container(
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () => closeKeyboard(context),
              behavior: HitTestBehavior.opaque,
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 52.w, right: 52.w),
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 50.w)),

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
                                S.of(context).register,
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
                                  controller: _phoneController,
                                  keyboardType: TextInputType.text,
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
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.cancel),
                                        onPressed: () {
                                          _phoneController.clear();
                                        },
                                      )),
                                  validator: (value) {
                                    if (value == '') {
                                      return S.of(context).phoneError;
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (String value) =>
                                      _phoneVal = value,
                                  // inputFormatters: [
                                  //   LengthLimitingTextInputFormatter(11),
                                  // ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.w)),

                        /// 密码
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
                                  maxLength: 60,
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
                                  onChanged: (String value) =>
                                      _passwordVal = value,
                                  validator: (value) {
                                    return value!.trim().length > 6
                                        ? null
                                        : "密码不能少于6位";
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.w)),

                        //再次输入密码
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
                                  //隐藏文本
                                  obscureText: againPassShow,
                                  style: TextStyle(
                                      fontSize: 32.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                    icon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            againPassShow = !againPassShow;
                                          });
                                        },
                                        icon: Icon(!againPassShow
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    // 表单提示信息
                                    hintText: S.of(context).passwordAgain,
                                    hintStyle: TextStyle(
                                        fontSize: 32.sp,
                                        color: const Color(0xff737A83)),
                                    // 取消自带的下边框
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (String value) =>
                                      _againPassVal = value,
                                  validator: (value) {
                                    if (_passwordVal != _againPassVal) {
                                      return S.of(context).passwordAgainError;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 20.w)),

                        // 验证码
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 400.w,
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0XFF302F4F), width: 0.0)),
                              ),
                              child: SizedBox(
                                child: TextFormField(
                                  controller: _textController,
                                  style: TextStyle(
                                      fontSize: 32.sp,
                                      color: const Color(0xff051220)),
                                  decoration: InputDecoration(
                                      // 表单提示信息
                                      hintText: S.of(context).verficationCode,
                                      hintStyle: TextStyle(
                                          fontSize: 32.sp,
                                          color: const Color(0xff737A83)),
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.cancel),
                                        onPressed: () {
                                          _textController.clear();
                                        },
                                      )),
                                  validator: (value) {
                                    if (value.toString().length != 4) {
                                      return S.of(context).verficationCodeError;
                                    }
                                    return null;
                                  },
                                  onChanged: (String value) =>
                                      _codeValue = value,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                ),
                              ),
                            ),
                            // 获取验证码
                            TextButton(
                                onPressed: (() {
                                  // RegExp reg = RegExp(
                                  //     r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                                  debugPrint("注册邮箱:$_phoneVal");
                                  
                                  debugPrint("注册接口:${BaseConfig.cloudBaseUrl}/platform/appCustomer/sendSmsOrEmailCode?account=$_phoneVal");
                                  if (iscode) return;
                                  if (_phoneVal == '') {
                                    ToastUtils.toast(S.of(context).phoneError);
                                  } else {
                                    //发请求
                                    dio
                                        .post(
                                            '${BaseConfig.cloudBaseUrl}/platform/appCustomer/sendSmsOrEmailCode?account=$_phoneVal')
                                        .then((res) {
                                      var d = json.decode(res.toString());
                                      debugPrint('响应------>$d');
                                      if (d['code'] == 200) {
                                        ToastUtils.toast(S.of(context).success);
                                        if (codeNum == 60) {
                                          //倒计时60s
                                          setState(() {
                                            iscode = true;
                                          });

                                          timer = Timer.periodic(
                                              const Duration(seconds: 1),
                                              (time) {
                                            setState(() {
                                              codeNum--;
                                            });
                                            if (codeNum <= 1) {
                                              timer.cancel();
                                              setState(() {
                                                codeNum = 60;
                                                iscode = false;
                                              });
                                            }
                                          });
                                        }
                                      } else {
                                        if (d['code'] == 9991) {
                                          ToastUtils.toast(
                                              S.current.accountIncorrect);
                                        }
                                      }
                                    }).catchError((err) {
                                      debugPrint('响应------>$err');
                                      //相应超超时
                                      if (err['code'] ==
                                          DioErrorType.connectTimeout) {
                                        debugPrint('timeout');
                                        ToastUtils.error(S.current.contimeout);
                                      }
                                    });
                                  }
                                }),
                                child: Text(
                                  iscode
                                      ? '$codeNum${S.current.second}'
                                      : S.of(context).getVerficationCode,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 30.w),
                                )),
                          ],
                        ),

                        Padding(padding: EdgeInsets.only(top: 200.w)),

                        /// 注册按钮
                        SizedBox(
                          width: 1.sw - 104.w,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.only(top: 28.w, bottom: 28.w),
                              ),
                              shape: MaterialStateProperty.all(
                                  const StadiumBorder()),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 30, 104, 233)),
                            ),
                            onPressed: () {
                              final data = {
                                "account": _phoneVal,
                                "password": AESUtil.generateAES(_passwordVal),
                                "code": _codeValue
                              };
                              debugPrint("注册邮箱:$_phoneVal -- ${AESUtil.generateAES(_passwordVal)} -- $_codeValue");
                              //表单校验
                              if ((_formKey.currentState as FormState)
                                  .validate()) {
                                dio
                                    .post(
                                        '${BaseConfig.cloudBaseUrl}/platform/appCustomer/register',
                                        data: data)
                                    .then((res) {
                                  var d = json.decode(res.toString());
                                  debugPrint('响应------>$d');
                                  ToastUtils.toast(d['message']);
                                  if (d['code'] != 200) {
                                    return;
                                  } else {
                                    Get.offAllNamed("/user_login");
                                  }
                                }).catchError((err) {
                                  debugPrint('响应------>$err');

                                  //相应超超时
                                  if (err['code'] ==
                                      DioErrorType.connectTimeout) {
                                    debugPrint('timeout');
                                    ToastUtils.error(S.current.contimeout);
                                  }
                                });
                              }
                            },
                            child: Text(
                              S.of(context).register,
                              style: TextStyle(
                                  fontSize: 32.sp,
                                  color: const Color(0xffffffff)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ));
  }
}
