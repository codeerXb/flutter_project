import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../config/base_config.dart';
import '../../core/utils/Aes.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';

/// 用户登录
class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final LoginController loginController = Get.put(LoginController());
  bool passwordValShow = true;
  var dio = Dio();

  @override
  void initState() {
    super.initState();
    phone.text = '19121757940';
    password.text = '123';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
          borderBottom: false,
          actions: [
            TextButton(
                onPressed: () {
                  Get.offAllNamed("/get_equipment");
                },
                child: Text(
                  '跳过',
                  style: TextStyle(fontSize: 32.w, fontWeight: FontWeight.w600),
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => closeKeyboard(context),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 52.w, right: 52.w),
              child: Form(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 100.w)),

                    //logo&文字
                    logo(),
                    Padding(padding: EdgeInsets.only(top: 50.w)),

                    //手机号
                    buildPhoneField(),
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
                                    textAlign: TextAlign.right,
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
                                    hintText: "请输入登录密码",
                                    hintStyle: TextStyle(
                                        fontSize: 32.sp,
                                        color: const Color(0xff737A83)),
                                    // 取消自带的下边框
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 20.w)),

                    /// 注册&忘记密码
                    registerAndForget(),
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
                        onPressed: () async {
                          Map<String, dynamic> data = {
                            "account": phone.text,
                            "password": AESUtil.generateAES(password.text),
                          };
                          var res = await dio.post(
                              '${BaseConfig.cloudBaseUrl}/fota/fota/appCustomer/login',
                              data: data);
                          var d = json.decode(res.toString());
                          debugPrint('响应------>$d');
                          if (d['code'] != 200) {
                            ToastUtils.toast(d['message']);
                            return;
                          } else {
                            ToastUtils.toast('登录成功');
                            Get.offAllNamed("/get_equipment");
                            //存储用户信息
                            sharedAddAndUpdate(
                                "user_token", String, (d['data']['token']));
                            sharedAddAndUpdate(
                                "user_phone", String, (d['data']['account']));
                          }
                        },
                        child: Text(
                          '登录',
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
          '登录',
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
Column buildPhoneField() {
  return Column(
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
              width: 1.sw - 104.w,
              child: TextFormField(
                controller: phone,
                keyboardType: TextInputType.number,
                // initialValue: _password,
                style:
                    TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
                decoration: InputDecoration(
                  icon: const Icon(Icons.perm_identity),
                  // 表单提示信息
                  hintText: "请输入手机号",
                  hintStyle: TextStyle(
                      fontSize: 32.sp, color: const Color(0xff737A83)),
                  // 取消自带的下边框
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// 注册&忘记密码
Row registerAndForget() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      //注册
      TextButton(
          onPressed: (() {
            Get.offAllNamed("/use_register");
          }),
          child: Text(
            '注册',
            style: const TextStyle(color: Colors.black45),
          )),
      // 忘记密码
      TextButton(
          onPressed: (() {
            // Get.offAllNamed("/forget_password");
          }),
          child: const Text('', style: TextStyle(color: Colors.black45)))
    ],
  );
}
