import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/string_util.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_template/config/base_config.dart';
import '../../core/utils/Aes.dart';
// import '../../generated/l10n.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

//_formKey
final GlobalKey _formKey = GlobalKey<FormState>();
final GlobalKey _emailformKey = GlobalKey<FormState>();

class _ForgetPasswordState extends State<ForgetPassword>
    with SingleTickerProviderStateMixin {
  String _phoneVal = '';
  //密码
  String _passwordVal = '';
  bool passwordValShow = true;
  //验证码
  String _codeValue = '';
  bool isCode = false; //获取验证码状态
  int codeNum = 60; //倒计时 60秒

  String _emailPwdVal = '';
  bool emailPwdValShow = true;
  //验证码
  String _emailcodeValue = '';
  bool emailTimerStart = false;
  int emailCodeNum = 60;

  Timer? timer;
  late TabController _tabController;
  int currentTag = 0;

  var dio = Dio();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailPwdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _phonePwdController = TextEditingController();
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Change Password',
            style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
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
                Get.offAllNamed("/user_login");
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          bottom: TabBar(
              isScrollable: false,
              indicatorColor: Colors.blue,
              indicatorWeight: 2,
              indicatorPadding: const EdgeInsets.all(5),
              // indicatorSize:TabBarIndicatorSize.label,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              labelStyle: const TextStyle(fontSize: 18),
              unselectedLabelStyle: const TextStyle(fontSize: 16),
              controller: _tabController,
              onTap: (value) {
                setState(() {
                  debugPrint("当前选择的标签是:$value");
                  currentTag = value;
                });
              },
              tabs: const [
                Tab(
                  child: Text(
                    "Phone",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Tab(
                  child: Text(
                    "Email",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [setUpPhoneView(), setUpEmailView()],
        ));
  }

  void setUpSendMes(String accountStr) async {
    final data = {"account": accountStr};
    //发请求
    var res = await dio.post(
        '${BaseConfig.cloudBaseUrl}/platform/appCustomer/sendSmsOrEmailCode',
        data: data);
    var d = json.decode(res.toString());
    debugPrint('响应------>$d');
    d['code'] == 200
        ? ToastUtils.toast('SMS sent successfully')
        : ToastUtils.toast(d['message']);
  }

  Widget setUpPhoneView() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 20),
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
                    // Center(
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //         margin: EdgeInsets.only(bottom: 70.w),
                    //         child: Image.asset(
                    //           'assets/images/logo.png',
                    //         ),
                    //       ),
                    //       Text(
                    //         'Change Password',
                    //         style: TextStyle(fontSize: 60.sp),
                    //       ),
                    //       Text(
                    //         S.of(context).cpeManagementPlatform,
                    //         style: TextStyle(
                    //             fontSize: 30.sp, color: Colors.black38),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(padding: EdgeInsets.only(top: 50.w)),

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
                            child: IntlPhoneField(
                              focusNode: blankNode,
                              controller: _phoneController,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: 32.sp,
                                  color: const Color(0xff051220)),
                              decoration: InputDecoration(
                                // icon: const Icon(Icons.perm_identity),
                                // 表单提示信息
                                hintText: "Please enter account number",
                                hintStyle: TextStyle(
                                    fontSize: 32.sp,
                                    color: const Color(0xff737A83)),
                                // 取消自带的下边框
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      _phoneController.clear();
                                    }),
                              ),
                              languageCode: "en",
                              validator: (value) {
                                RegExp reg = RegExp(
                                    r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                                if (!reg.hasMatch(value!.completeNumber)) {
                                  return 'Account is incorrect';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (phone) {
                                _phoneVal = phone.completeNumber;
                              },
                              // inputFormatters: [
                              //   LengthLimitingTextInputFormatter(30),
                              // ]
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 40.w)),

                    /// 验证码
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
                              controller: _phonePwdController,
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
                                    _phonePwdController.clear();
                                  },
                                ),
                              ),
                            )),
                        // 获取验证码
                        Expanded(
                            flex: 2,
                            child: SizedBox(
                              child: TextButton(
                                  onPressed: (() async {
                                    // RegExp reg = RegExp(
                                    //     r'^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$');
                                    if (_phoneVal.isEmpty &&
                                        _phoneVal.length <= 10) {
                                      ToastUtils.toast(
                                          'Mobile phone number format is wrong');
                                    } else {
                                      if (codeNum == 60) {
                                        //倒计时60s
                                        setState(() {
                                          isCode = true;
                                        });

                                        timer = Timer.periodic(
                                            const Duration(seconds: 1), (time) {
                                          setState(() {
                                            codeNum--;
                                          });
                                          if (codeNum <= 1) {
                                            timer?.cancel();
                                            setState(() {
                                              codeNum = 60;
                                              isCode = false;
                                            });
                                          }
                                        });
                                      }
                                      setUpSendMes(_phoneController.text);
                                    }
                                  }),
                                  child: Text(
                                    isCode ? '$codeNum Second' : 'Verify Code',
                                    softWrap: true,
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
                              onChanged: (String value) => _passwordVal = value,
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
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
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
                          if ((_formKey.currentState as FormState).validate()) {
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
                              fontSize: 32.sp, color: const Color(0xffffffff)),
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
    );
  }

  Widget setUpEmailView() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 20),
        child: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _emailformKey,
            child: Column(children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 52.w, right: 52.w),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 100.w)),
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
                                controller: _emailController,
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                    fontSize: 32.sp,
                                    color: const Color(0xff051220)),
                                decoration: InputDecoration(
                                  icon: const Icon(Icons.perm_identity),
                                  // 表单提示信息
                                  hintText: "Please enter account number",
                                  hintStyle: TextStyle(
                                      fontSize: 32.sp,
                                      color: const Color(0xff737A83)),
                                  // 取消自带的下边框
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () {
                                        _emailController.clear();
                                      }),
                                ),
                                validator: (value) {
                                  if (!StringUtil.isEmail(value!)) {
                                    return 'Account is incorrect';
                                  } else {
                                    return null;
                                  }
                                },
                                // onChanged: (String value) => _phoneVal = value,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30),
                                ]),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 40.w)),

                    /// 验证码
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
                              controller: _emailPwdController,
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
                                  _emailcodeValue = value;
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
                                offstage:
                                    _emailcodeValue.isEmpty ? true : false,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    _emailPwdController.clear();
                                  },
                                ),
                              ),
                            )),
                        // 获取验证码
                        Expanded(
                            flex: 2,
                            child: SizedBox(
                              child: TextButton(
                                  onPressed: (() async {
                                    if (!StringUtil.isEmail(
                                        _emailController.text)) {
                                      ToastUtils.toast(
                                          'Mobile phone number format is wrong');
                                    } else {
                                      
                                      if (emailCodeNum == 60) {
                                        //倒计时60s
                                        setState(() {
                                          emailTimerStart = true;
                                        });

                                        timer = Timer.periodic(
                                            const Duration(seconds: 1), (time) {
                                          setState(() {
                                            emailCodeNum--;
                                          });
                                          if (emailCodeNum <= 1) {
                                            timer?.cancel();
                                            setState(() {
                                              emailCodeNum = 60;
                                              emailTimerStart = false;
                                            });
                                          }
                                        });
                                      }
                                      setUpSendMes(_emailController.text);
                                    }
                                  }),
                                  child: Text(
                                    isCode
                                        ? '$emailCodeNum Second'
                                        : 'Verify Code',
                                    softWrap: true,
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
                              obscureText: emailPwdValShow,
                              style: TextStyle(
                                  fontSize: 32.sp,
                                  color: const Color(0xff051220)),
                              decoration: InputDecoration(
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        emailPwdValShow = !emailPwdValShow;
                                      });
                                    },
                                    icon: Icon(!emailPwdValShow
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
                              onChanged: (String value) => _emailPwdVal = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }else if (value.trim().length < 6) {
                                  return 'Password cannot be less than 6 characters';
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
                          shape:
                              MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 30, 104, 233)),
                        ),
                        // onPressed: (){
                        //   Get.offAllNamed("/change_password");
                        // },

                        onPressed: () async {
                          Map<String, dynamic> data = {
                            "account": _emailController.text,
                            "newPassword": AESUtil.generateAES(_emailPwdVal),
                            "code": _emailcodeValue
                          };
                          //表单校验
                          if ((_emailformKey.currentState as FormState)
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
                              fontSize: 32.sp, color: const Color(0xffffffff)),
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer?.cancel();
    }
  }
}
