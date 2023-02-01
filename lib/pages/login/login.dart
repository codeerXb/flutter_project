import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:flutter_template/pages/login/model/equipment_data.dart';
import 'package:flutter_template/pages/login/model/exception_login.dart';
import 'package:get/get.dart';

import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_widget.dart';
import '../../core/widget/custom_app_bar.dart';

/// 登录页面
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController loginController = Get.put(LoginController());
  final GlobalKey _formKey = GlobalKey<FormState>();
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
  String _account = 'superadmin';
  String _password = 'admin';
  dynamic sn = Get.arguments['sn'];
  dynamic vn = Get.arguments['vn'];
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  Color _accountBorderColor = Colors.white;
  Color _passwordBorderColor = Colors.white;
  EquipmentData equipmentData = EquipmentData();

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
        loginController.setToken(d['token']);
        loginController.setSession(d['sessionid']);
        sharedAddAndUpdate(
            sn.toString(), String, base64Encode(utf8.encode(_password)));
        sharedAddAndUpdate("token", String, d['token']);
        sharedAddAndUpdate("session", String, d['sessionid']);
        Get.offNamed("/home", arguments: {'vn': vn});
      }
    }).catchError((err) {
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
                '密码错误,剩余尝试次数：${5 - int.parse(errRes.webLoginFailedTimes.toString())}');
          } else if (errRes.code == 202) {
            ToastUtils.error('已锁定，${errRes.webLoginRetryTimeout}s后解锁');
          }
        }
        debugPrint('登录失败：${errRes.code}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
        // appBar: PreferredSize(

        //   preferredSize: const Size.fromHeight(0),
        //   child: customAppbar(
        //     borderBottom: false,
        //     // backgroundColor: Colors.transparent,
        //   ),
        // ),
        body: InkWell(
          onTap: () => closeKeyboard(context),
          child: Container(
            height: 1.sh,
            color: Colors.white,
            padding: EdgeInsets.only(left: 52.w, top: 100.w, right: 52.w),
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
                    '管理员登录',
                    style: TextStyle(fontSize: 48.sp),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10.w)),
                  Text(
                    '当前设备 $vn',
                    style: TextStyle(
                        fontSize: 28.sp, color: const Color(0xFF373543)),
                  ),

                  /// 账号
                  // buildAccountTextField(),
                  Padding(padding: EdgeInsets.only(top: 112.w)),

                  /// 密码
                  buildPasswordTextField(),
                  Padding(padding: EdgeInsets.only(top: 192.w)),

                  /// 登录
                  buildLoginButton(),
                  Padding(padding: EdgeInsets.only(top: 20.w)),
                ],
              ),
            ),
          ),
        ));
  }

  ///账号
  Container buildAccountTextField() {
    return Container(
      padding: EdgeInsets.only(top: 55.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("账号",
              style:
                  TextStyle(fontSize: 32.sp, color: const Color(0xff737A83))),
          Container(
            height: 90.w,
            padding: EdgeInsets.only(left: 40.w),
            margin: EdgeInsets.only(top: 24.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: const Color(0xffEEEFF2),
                border: Border.all(color: _accountBorderColor, width: 1.w)),
            child: TextFormField(
                initialValue: _account,
                style:
                    TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
                decoration: InputDecoration(
                  // 表单提示信息
                  hintText: "请输入账号",
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
                        hintText: "请输入密码",
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
              // const Expanded(child: Text("")),
              // IconButton(
              //     iconSize: 30.w,
              //     icon: Icon(
              //       Icons.remove_red_eye,
              //       color: _eyeColor,
              //     ),
              //     onPressed: () {
              //       setState(() {
              //         _eyeColor = _isObscure ? Colors.blue : Colors.grey;
              //         _isObscure = !_isObscure;
              //       });
              //     })
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
          if ((_formKey.currentState as FormState).validate()) {
            onSubmit(context);
            appLogin();
          }
        },
        child: Text(
          '登录',
          style: TextStyle(fontSize: 32.sp, color: const Color(0xffffffff)),
        ),
      ),
      // CommonWidget.buttonWidget(
      //     title: '登录',
      //     padding: EdgeInsets.only(left: 0, top: 32.w, bottom: 30.w, right: 0),
      //     callBack: () {
      //       if ((_formKey.currentState as FormState).validate()) {
      //         onSubmit(context);
      //       }
      //     }),
    );
  }

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  ///执行提交方法
  void onSubmit(BuildContext context) {
    closeKeyboard(context);
    if (_account.trim().isEmpty) {
      ToastUtils.toast("账号不能为空");
    } else if (_password.trim().isEmpty) {
      ToastUtils.toast("密码不能为空");
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
        Get.offNamed("/home", arguments: {'vn': vn});
      } else {
        ToastUtils.toast('用户名或密码错误');
      }
    }
  }
}
