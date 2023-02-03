import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_template/config/base_config.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

//_formKey
final GlobalKey _formKey = GlobalKey<FormState>();

class _ForgetPasswordState extends State<ForgetPassword> {
  //密码
  String _passwordVal = '';
  bool passwordValShow = true;

  //验证码
  String _codeValue = '';
  bool iscode = false; //获取验证码状态
  int codeNum = 60; //倒计时 60秒

  var timer;
  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer.cancel();
    }
  } // 点击空白  关闭键盘 时传的一个对象

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
                Get.offAllNamed("/use_login");
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
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
                      logo(),
                      Padding(padding: EdgeInsets.only(top: 50.w)),

                      //手机号
                      buildPhoneField(),
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
                                style: TextStyle(
                                    fontSize: 32.sp,
                                    color: const Color(0xff051220)),
                                decoration: InputDecoration(
                                  // 表单提示信息
                                  hintText: "请输入验证码",
                                  hintStyle: TextStyle(
                                      fontSize: 32.sp,
                                      color: const Color(0xff737A83)),
                                ),
                                validator: (value) {
                                  if (value.toString().length != 4) {
                                    return '输入正确验证码';
                                  }
                                  return null;
                                },
                                onChanged: (String value) => _codeValue = value,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(4),
                                ],
                              ),
                            ),
                          ),
                          // 获取验证码
                          TextButton(
                              onPressed: (() async {
                                RegExp reg = RegExp(
                                    r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                                if (!reg.hasMatch(_phoneVal!)) {
                                  ToastUtils.toast('手机号格式有误');
                                } else {
                                  //发请求
                                  var res = await dio.post(
                                      '${BaseConfig.cloudBaseUrl}/fota/fota/appCustomer/sendSmsOrEmailCode?account=$_phoneVal');
                                  var d = json.decode(res.toString());
                                  debugPrint('响应------>$d');
                                  d['code'] == 200
                                      ? ToastUtils.toast('短信发送成功')
                                      : ToastUtils.toast(d['message']);
                                  if (codeNum == 60) {
                                    //倒计时60s
                                    setState(() {
                                      iscode = true;
                                    });

                                    timer = Timer.periodic(
                                        const Duration(seconds: 1), (time) {
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
                                }
                              }),
                              child: Text(
                                iscode ? '$codeNum秒' : '获取验证码',
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 30.w),
                              )),
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
                                  hintText: "请输入新密码",
                                  hintStyle: TextStyle(
                                      fontSize: 32.sp,
                                      color: const Color(0xff737A83)),
                                  // 取消自带的下边框
                                  border: InputBorder.none,
                                ),
                                onChanged: (String value) =>
                                    _passwordVal = value,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '请输入密码';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 40.w)),

                      ///修改密码
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
                          onPressed: () async {
                            Map<String, dynamic> data = {
                              "account": _phoneVal,
                              "newPassword": _passwordVal,
                              "code": _codeValue
                            };
                            //表单校验
                            if ((_formKey.currentState as FormState)
                                .validate()) {
                              var res = await dio.post(
                                  '${BaseConfig.cloudBaseUrl}/fota/fota/appCustomer/updatePwd',
                                  data: data);
                              print(res);
                              print(data);
                              // var d = json.decode(res.toString());
                              // debugPrint('响应------>$d');
                              // ToastUtils.toast(d['message']);
                              // if (d['code'] != 200) {
                              //   return;
                              // } else {
                              //   Get.offAllNamed("/use_login");
                              // }
                            }
                          },
                          child: Text(
                            '修改密码',
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
        ));
  }
}

//logo&文字
Center logo() {
  return Center(
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 70.w),
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
        Text(
          '忘记密码',
          style: TextStyle(fontSize: 60.sp),
        ),
        Text(
          'CPE管理平台',
          style: TextStyle(fontSize: 30.sp, color: Colors.black38),
        ),
      ],
    ),
  );
}

//手机号
var dio = Dio();
dynamic _phoneVal = '';
Row buildPhoneField() {
  return Row(
    children: [
      Container(
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0XFF302F4F), width: 0.0)),
        ),
        child: SizedBox(
          width: 1.sw - 104.w,
          child: TextFormField(
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
              decoration: InputDecoration(
                icon: const Icon(Icons.perm_identity),
                // 表单提示信息
                hintText: "请输入手机号",
                hintStyle:
                    TextStyle(fontSize: 32.sp, color: const Color(0xff737A83)),
                // 取消自带的下边框
                border: InputBorder.none,
              ),
              validator: (value) {
                RegExp reg = RegExp(
                    r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                if (!reg.hasMatch(value!)) {
                  return '手机号有误';
                } else {
                  return null;
                }
              },
              onChanged: (String value) => _phoneVal = value,
              inputFormatters: [
                LengthLimitingTextInputFormatter(11),
              ]),
        ),
      ),
    ],
  );
}
