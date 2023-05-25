import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:flutter_template/pages/login/model/exception_login.dart';
import 'package:get/get.dart';

import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';

/// 登录页面
class WanLogin extends StatefulWidget {
  const WanLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WanLoginState();
}

class _WanLoginState extends State<WanLogin> {
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey _formKey = GlobalKey<FormState>();
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
  String _account = 'superadmin';
  String _password = 'admin';
  dynamic sn = Get.arguments['sn'];
  final bool _isObscure = true;
  final Color _eyeColor = Colors.grey;
  Color _accountBorderColor = Colors.white;
  Color _passwordBorderColor = Colors.white;
  EquipmentData equipmentData = EquipmentData();

  bool _isLoading = false;

  void appLogin() {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> data = {
      'username': _account.trim(),
      'password': _password.trim(),
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
            sharedAddAndUpdate("token", String, localLoginRes['token']);
            sharedAddAndUpdate("session", String, localLoginRes['sessionid']);
            Get.back();
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
      padding: EdgeInsets.only(top: 55.w),
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
                  width: 1.sw - 104.w,
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
        child: _isLoading
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                ),
              )
            : Text(
                S.of(context).login,
                style:
                    TextStyle(fontSize: 32.sp, color: const Color(0xffffffff)),
              ),
      ),
    );
  }

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
                Get.back();
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
        body: InkWell(
          onTap: () => closeKeyboard(context),
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding:
                        EdgeInsets.only(left: 52.w, top: 100.w, right: 52.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          /// logo
                          Container(
                            margin: EdgeInsets.only(bottom: 70.w),
                            // width: 136.w,
                            // height: 136.w,
                            child: Image.asset(
                              'assets/images/logo.png',
                              // fit: BoxFit.fill,
                            ),
                          ),
                          // Padding(padding: EdgeInsets.only(top: 70.w)),
                          Text(
                            S.current.Administratorlogin,
                            style: TextStyle(fontSize: 48.sp),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.w)),
                          Text(
                            // '${S.of(context).currentDeive} ${loginController.userEquipment['deviceSn']}',
                            '${S.of(context).currentDeive} $sn',
                            style: TextStyle(
                                fontSize: 28.sp,
                                color: const Color(0xFF373543)),
                          ),

                          /// 账号
                          buildAccountTextField(),
                          // Padding(padding: EdgeInsets.only(top: 112.w)),

                          /// 密码
                          buildPasswordTextField(),
                          Padding(padding: EdgeInsets.only(top: 102.w)),

                          /// 登录
                          buildLoginButton(),
                          Padding(padding: EdgeInsets.only(top: 20.w)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
