import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/Aes.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_template/config/base_config.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../generated/l10n.dart';

/// 用户注册
class UserRegister extends StatefulWidget {
  const UserRegister({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserRegisterState();
}

final GlobalKey _PhoneKey = GlobalKey<FormState>();
final GlobalKey _EmailKey = GlobalKey<FormState>();

class _UserRegisterState extends State<UserRegister>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LoginController loginController = Get.put(LoginController());
  //手机号
  String _phoneVal = '';
  String _emailPwdValue = "";
  //密码
  String _passwordVal = '';
  bool passwordValShow = true;
  //再次输入密码
  String _againPassVal = '';
  bool againPassShow = true;

  bool emailPwdShow = true;
  //再次输入密码
  String _emailAgainVal = '';
  bool emailAgainShow = true;
  //验证码
  String _codeValue = '';
  bool iscode = false; //获取验证码状态
  int codeNum = 60; //倒计时 60秒
  bool emailCodeStart = false;
  int emailCodeNum = 60;
  Timer? timer;

  bool? ischecked = false;
  bool? isCheckAgree = false;

  bool? ischeckedPhone = false;
  bool? isCheckAgreePhone = false;

  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
// 手机号
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
// 邮箱
  final TextEditingController _emailCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  var dio = Dio(BaseOptions(
    connectTimeout: 2000,
  ));

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).register,
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
          children: [createPhoneView(), createEmailView()],
        ));
  }

  Widget createEmailView() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 20),
        child: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _EmailKey,
            child: Column(children: [
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
              //         S.of(context).cpeManagementPlatform,
              //         style: TextStyle(
              //             fontSize: 30.sp, color: Colors.black38),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(padding: EdgeInsets.only(top: 50.w)),

              //邮箱
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0XFF302F4F), width: 0.0)),
                    ),
                    child: SizedBox(
                      width: 1.sw - 104.w,
                      child: TextFormField(
                        focusNode: blankNode,
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontSize: 32.sp, color: const Color(0xff051220)),
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
                                _emailController.clear();
                              },
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return S.of(context).phoneError;
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          debugPrint("获取到的账号是$value");
                        },

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0XFF302F4F), width: 0.0)),
                    ),
                    child: SizedBox(
                      width: 1.sw - 104.w,
                      child: TextFormField(
                        obscureText: emailPwdShow,
                        keyboardType: TextInputType.text,
                        maxLength: 60,
                        style: TextStyle(
                            fontSize: 32.sp, color: const Color(0xff051220)),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  emailPwdShow = !emailPwdShow;
                                });
                              },
                              icon: Icon(!emailPwdShow
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          // 表单提示信息
                          hintText: S.of(context).passwordLabel,
                          hintStyle: TextStyle(
                              fontSize: 32.sp, color: const Color(0xff737A83)),
                          // 取消自带的下边框
                          border: InputBorder.none,
                        ),
                        onChanged: (String value) => _emailPwdValue = value,
                        validator: (value) {
                          return value!.trim().length >= 6 ? null : "密码不能少于6位";
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20.w)),

              //再次输入密码
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0XFF302F4F), width: 0.0)),
                    ),
                    child: SizedBox(
                      width: 1.sw - 104.w,
                      child: TextFormField(
                        //隐藏文本
                        obscureText: emailAgainShow,
                        style: TextStyle(
                            fontSize: 32.sp, color: const Color(0xff051220)),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  emailAgainShow = !emailAgainShow;
                                });
                              },
                              icon: Icon(!emailAgainShow
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          // 表单提示信息
                          hintText: S.of(context).passwordAgain,
                          hintStyle: TextStyle(
                              fontSize: 32.sp, color: const Color(0xff737A83)),
                          // 取消自带的下边框
                          border: InputBorder.none,
                        ),
                        onChanged: (String value) => _emailAgainVal = value,
                        validator: (value) {
                          if (_emailPwdValue != _emailAgainVal) {
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400.w,
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Color(0XFF302F4F), width: 0.0)),
                    ),
                    child: SizedBox(
                      child: TextFormField(
                        controller: _emailCodeController,
                        style: TextStyle(
                            fontSize: 32.sp, color: const Color(0xff051220)),
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
                                _emailCodeController.clear();
                              },
                            )),
                        validator: (value) {
                          if (value.toString().length != 4) {
                            return S.of(context).verficationCodeError;
                          }
                          return null;
                        },
                        onChanged: (String value) {
                          debugPrint("邮箱登录的验证码是:$value");
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                        ],
                      ),
                    ),
                  ),
                  // 获取验证码
                  TextButton(
                      onPressed: (() {
                        debugPrint("注册邮箱:${_emailController.text}");
                        if (emailCodeStart) return;
                        if (_emailController.text.isEmpty) {
                          ToastUtils.toast(S.of(context).phoneError);
                        } else {
                          final data = {"account": _emailController.text};
                          //发请求
                          dio
                              .post(
                                  '${BaseConfig.cloudBaseUrl}/platform/appCustomer/sendSmsOrEmailCode',
                                  data: data)
                              .then((res) {
                                debugPrint("请求验证码接口:${data.toString()}");
                            var d = json.decode(res.toString());
                            debugPrint('响应------>$d');
                            if (d['code'] == 200) {
                              ToastUtils.toast(S.of(context).success);
                              if (emailCodeNum == 60) {
                                //倒计时60s
                                setState(() {
                                  emailCodeStart = true;
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
                                      emailCodeStart = false;
                                    });
                                  }
                                });
                              }
                            } else {
                              if (d['code'] == 9991) {
                                ToastUtils.toast(S.current.accountIncorrect);
                              }
                            }
                          }).catchError((err) {
                            debugPrint('响应------>$err');
                            //相应超超时
                            if (err['code'] == DioErrorType.connectTimeout) {
                              debugPrint('timeout');
                              ToastUtils.error(S.current.contimeout);
                            }
                          });
                        }
                      }),
                      child: Text(
                        emailCodeStart
                            ? '$emailCodeNum${S.current.second}'
                            : S.of(context).getVerficationCode,
                        style: TextStyle(color: Colors.blue, fontSize: 30.w),
                      )),
                ],
              ),

              const SizedBox(
                height: 20,
              ),

              ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  activeColor: Colors.blue,
                  side:const BorderSide(color: Color.fromARGB(255, 120, 119, 119)),
                  value: ischecked,
                  title: RichText(
                      text: TextSpan(
                          text: "Read and agree",
                          style:const TextStyle(color:  Color.fromARGB(255, 120, 119, 119), fontSize: 12.0),
                          children: [
                        TextSpan(
                            text: "《Service terms》",
                            style:const
                                TextStyle(color: Color.fromARGB(255, 7, 96, 185), fontSize: 14.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // String url = 'http://www.baidu.com';
                                // if (await canlaunch(url)){
                                //   await launch(url);
                                // }
                              }),
                        const TextSpan(
                          text: "and",
                          style: TextStyle(color: Colors.black, fontSize: 12.0),
                        ),
                        TextSpan(
                            text: "《Privacy policy》",
                            style:const
                                TextStyle(color: Color.fromARGB(255, 7, 96, 185), fontSize: 14.0),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // String url = 'http://www.baidu.com';
                                // if (await canlaunch(url)){
                                //   await launch(url);
                                // }
                              })
                      ])),
                  // subtitle: Text('${_items[index]}'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (isChecked) {
                    setState(() {
                      ischecked = isChecked;
                    });
                  })
                ),
              ListTileTheme(
                horizontalTitleGap: 0,
                child: CheckboxListTile(
                  activeColor: Colors.blue,
                  side: const BorderSide(color: Color.fromARGB(255, 120, 119, 119)),
                  value: isCheckAgree,
                  title:const Text("I agree to revice text message",
                      style: TextStyle(color: Color.fromARGB(255, 120, 119, 119), fontSize: 12.0)),
                  // subtitle: Text('${_items[index]}'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (isChecked) {
                    setState(() {
                      isCheckAgree = isChecked;
                    });
                  })
                ),

              const Padding(
                      padding: EdgeInsets.only(left: 25,right: 25),
                      child: Text("Message and data rates may apply. Enter your phone number to subscribe to recurring Account updates to your phone from MOTOEYE. Msg freq may vary Reply HELP for help. Retry STOP to cancel.",style: TextStyle(color:  const Color.fromARGB(255, 120, 119, 119), fontSize: 12.0),softWrap: true,),
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
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 30, 104, 233)),
                  ),
                  onPressed: () {
                    final data = {
                      "account": _emailController.text,
                      "password": AESUtil.generateAES(_emailPwdValue),
                      "code": _emailCodeController.text
                    };
                    debugPrint(
                        "注册邮箱:${_emailController.text} -- ${AESUtil.generateAES(_emailPwdValue)} -- ${_emailCodeController.text}");
                    if (!ischecked! || !isCheckAgree!) {
                      ToastUtils.toast("Please select to agree to the agreement");
                      return ;
                    }
                    //表单校验
                    if ((_EmailKey.currentState as FormState).validate()) {
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
                        if (err['code'] == DioErrorType.connectTimeout) {
                          debugPrint('timeout');
                          ToastUtils.error(S.current.contimeout);
                        }
                      });
                    }
                  },
                  child: Text(
                    S.of(context).register,
                    style: TextStyle(
                        fontSize: 32.sp, color: const Color(0xffffffff)),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget createPhoneView() {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 20),
        child: GestureDetector(
          onTap: () => closeKeyboard(context),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: _PhoneKey,
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
                //         S.of(context).cpeManagementPlatform,
                //         style: TextStyle(
                //             fontSize: 30.sp, color: Colors.black38),
                //       ),
                //     ],
                //   ),
                // ),
                // Padding(padding: EdgeInsets.only(top: 50.w)),

                //手机号
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          keyboardType: TextInputType.phone,
                          languageCode: "en",
                          style: TextStyle(
                              fontSize: 32.sp, color: const Color(0xff051220)),
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
                            if (value!.completeNumber.isEmpty) {
                              return S.of(context).phoneError;
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            debugPrint("获取到的账号是${value.completeNumber}");
                            _phoneVal = value.completeNumber;
                          },
                          onCountryChanged: (value) {
                            debugPrint('Country changed to: -- ${value.name}');
                          },
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 32.sp, color: const Color(0xff051220)),
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
                          onChanged: (String value) => _passwordVal = value,
                          validator: (value) {
                            return value!.trim().length >= 6
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 32.sp, color: const Color(0xff051220)),
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
                          onChanged: (String value) => _againPassVal = value,
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              fontSize: 32.sp, color: const Color(0xff051220)),
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
                          onChanged: (String value) => _codeValue = value,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                          ],
                        ),
                      ),
                    ),
                    // 获取验证码
                    TextButton(
                        onPressed: (() {
                          debugPrint("注册手机号:$_phoneVal");
                          debugPrint(
                              "注册接口:${BaseConfig.cloudBaseUrl}/platform/appCustomer/sendSmsOrEmailCode?account=$_phoneVal");
                          if (iscode) return;
                          if (_phoneVal == '') {
                            ToastUtils.toast(S.of(context).phoneError);
                          } else {
                            final data = {"account": _phoneVal};
                            //发请求
                            dio
                                .post(
                                    '${BaseConfig.cloudBaseUrl}/platform/appCustomer/sendSmsOrEmailCode',
                                    data: data)
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
                                      const Duration(seconds: 1), (time) {
                                    setState(() {
                                      codeNum--;
                                    });
                                    if (codeNum <= 1) {
                                      timer?.cancel();
                                      setState(() {
                                        codeNum = 60;
                                        iscode = false;
                                      });
                                    }
                                  });
                                }
                              } else {
                                if (d['code'] == 9991) {
                                  ToastUtils.toast(S.current.accountIncorrect);
                                }
                              }
                            }).catchError((err) {
                              debugPrint('响应------>$err');
                              //相应超超时
                              if (err['code'] == DioErrorType.connectTimeout) {
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
                          style: TextStyle(color: Colors.blue, fontSize: 30.w),
                        )),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: CheckboxListTile(
                    activeColor: Colors.blue,
                    side:const BorderSide(color: Color.fromARGB(255, 120, 119, 119)),
                    value: ischeckedPhone,
                    title: RichText(
                        text: TextSpan(
                            text: "Read and agree",
                            style:
                                const TextStyle(color: Color.fromARGB(255, 120, 119, 119), fontSize: 12.0),
                            children: [
                          TextSpan(
                              text: "《Service terms》",
                              style:
                                  const TextStyle(color: Color.fromARGB(255, 7, 96, 185), fontSize: 14.0),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // String url = 'http://www.baidu.com';
                                  // if (await canlaunch(url)){
                                  //   await launch(url);
                                  // }
                                }),
                          const TextSpan(
                            text: "and",
                            style:
                                TextStyle(color: Colors.black, fontSize: 12.0),
                          ),
                          TextSpan(
                              text: "《Privacy policy》",
                              style:
                                  const TextStyle(color: Color.fromARGB(255, 7, 96, 185), fontSize: 14.0),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // String url = 'http://www.baidu.com';
                                  // if (await canlaunch(url)){
                                  //   await launch(url);
                                  // }
                                })
                        ])),
                    // subtitle: Text('${_items[index]}'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) {
                      setState(() {
                        ischeckedPhone = isChecked;
                      });
                    })
                  ),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: CheckboxListTile(
                    activeColor: Colors.blue,
                    side:const BorderSide(color: Color.fromARGB(255, 120, 119, 119)),
                    value: isCheckAgreePhone,
                    title:const Text("I agree to revice text message",
                        style: TextStyle(color: Color.fromARGB(255, 120, 119, 119), fontSize: 12.0)),
                    // subtitle: Text('${_items[index]}'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) {
                      setState(() {
                        isCheckAgreePhone = isChecked;
                      });
                    })
                ),

                    const Padding(
                      padding: EdgeInsets.only(left: 25,right: 25),
                      child: Text("Message and data rates may apply. Enter your phone number to subscribe to recurring Account updates to your phone from MOTOEYE. Msg freq may vary Reply HELP for help. Retry STOP to cancel.",style: TextStyle(color:  const Color.fromARGB(255, 120, 119, 119), fontSize: 12.0),softWrap: true,),
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
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 30, 104, 233)),
                    ),
                    onPressed: () {
                      final data = {
                        "account": _phoneVal,
                        "password": AESUtil.generateAES(_passwordVal),
                        "code": _codeValue
                      };
                      debugPrint(
                          "手机号注册:$_phoneVal -- ${AESUtil.generateAES(_passwordVal)} -- $_codeValue");
                      //表单校验
                      if ((_PhoneKey.currentState as FormState).validate()) {
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
                          if (err['code'] == DioErrorType.connectTimeout) {
                            debugPrint('timeout');
                            ToastUtils.error(S.current.contimeout);
                          }
                        });
                      }
                    },
                    child: Text(
                      S.of(context).register,
                      style: TextStyle(
                          fontSize: 32.sp, color: const Color(0xffffffff)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
}
