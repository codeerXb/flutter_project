import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_template/config/base_config.dart';
import '../../core/utils/Aes.dart';
import '../../generated/l10n.dart';

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
  bool isCode = false; //获取验证码状态
  int codeNum = 60; //倒计时 60秒
  var timer;

  final TextEditingController _textController = TextEditingController();
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
                Get.offAllNamed("/user_login");
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
                              'Change Password',
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
                      buildPhoneField(),
                      Padding(padding: EdgeInsets.only(top: 40.w)),

                      /// 验证码
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 450.w,
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Color(0XFF302F4F), width: 0.0)),
                            ),
                            child: SizedBox(
                              child: TextFormField(
                                controller: _textController,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 32.sp,
                                    color: const Color(0xff051220)),
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.phone_android),
                                  // 表单提示信息
                                  hintText: "please enter verification code",
                                  hintStyle: TextStyle(
                                      fontSize: 32.sp,
                                      color: const Color(0xff737A83)),
                                  border: InputBorder.none,
                                  // suffixIcon: IconButton(
                                  //   icon: const Icon(Icons.cancel),
                                  //   onPressed: (){
                                  //     _textController.clear();
                                  //   },
                                  // )
                                ),
                                validator: (value) {
                                  if (value.toString().length != 4) {
                                    return 'Please enter correct verify code';
                                  }
                                  return null;
                                },
                                onChanged: (String value) {
                                  setState(() {
                                    _codeValue = value;
                                  });
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(4),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Offstage(
                                  offstage: _codeValue.isEmpty ? true : false,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _textController.clear();
                                    },
                                  ),
                                ),
                              )),
                          // 获取验证码
                          Expanded(
                              flex: 2,
                              child: Container(
                                color: Colors.white,
                                child: TextButton(
                                    onPressed: (() async {
                                      RegExp reg = RegExp(
                                          r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                                      if (!reg.hasMatch(_phoneVal!)) {
                                        ToastUtils.toast(
                                            'Mobile phone number format is wrong');
                                      } else {
                                        //发请求
                                        var res = await dio.post(
                                            '${BaseConfig.cloudBaseUrl}/platform/appCustomer/sendSmsOrEmailCode?account=$_phoneVal');
                                        var d = json.decode(res.toString());
                                        debugPrint('响应------>$d');
                                        d['code'] == 200
                                            ? ToastUtils.toast(
                                                'SMS sent successfully')
                                            : ToastUtils.toast(d['message']);
                                        if (codeNum == 60) {
                                          //倒计时60s
                                          setState(() {
                                            isCode = true;
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
                                                isCode = false;
                                              });
                                            }
                                          });
                                        }
                                      }
                                    }),
                                    child: Text(
                                      isCode
                                          ? '$codeNum Second'
                                          : 'Verify Code',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 30.w),
                                    )),
                              )),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 40.w)),

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
                                textAlign: TextAlign.left,
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
                                  hintText: "Please enter a new password",
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
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 40.w)),

                      /// 更新密码
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
                          // onPressed: (){
                          //   Get.offAllNamed("/change_password");
                          // },

                          onPressed: () async {
                            Map<String, dynamic> data = {
                              "account": _phoneVal,
                              "newPassword": AESUtil.generateAES(_passwordVal),
                              "code": _codeValue
                            };
                            //表单校验
                            if ((_formKey.currentState as FormState)
                                .validate()) {
                              var res = await dio.post(
                                  '${BaseConfig.cloudBaseUrl}/platform/appCustomer/forgetPwdToUpdatePwd',
                                  data: data);
                              var d = json.decode(res.toString());
                              debugPrint('响应------>$d');
                              ToastUtils.toast(d['message']);
                              if (d['code'] != 200) {
                                return;
                              } else {
                                Get.offAllNamed("/user_login");
                              }
                            }
                          },
                          child: Text(
                            'Change Password',
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

//手机号
var dio = Dio();
dynamic _phoneVal = '';
final TextEditingController _textPhoneController = TextEditingController();
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
              controller: _textPhoneController,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
              decoration: InputDecoration(
                icon: const Icon(Icons.perm_identity),
                // 表单提示信息
                hintText: "Please enter phone number",
                hintStyle:
                    TextStyle(fontSize: 32.sp, color: const Color(0xff737A83)),
                // 取消自带的下边框
                border: InputBorder.none,
                suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      _textPhoneController.clear();
                    }),
              ),
              validator: (value) {
                RegExp reg = RegExp(
                    r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                if (!reg.hasMatch(value!)) {
                  return 'Mobile phone number is wrong';
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
// Bool UpdateButtonStatus(codeValue) {
//   if (_phoneVal.length > 0 && codeValue.length > 0) {
//
//   }
//   return true;
// }

