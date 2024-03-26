import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/http/http_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../config/base_config.dart';
import '../../core/utils/Aes.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import '../toolbar/toolbar_controller.dart';
import '../../core/utils/string_util.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../topo/model/Inquire_bean.dart';

/// 用户登录
class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserLoginState();
}

final GlobalKey _phoneKey = GlobalKey<FormState>();
final GlobalKey _mailKey = GlobalKey<FormState>();

class _UserLoginState extends State<UserLogin>
    with SingleTickerProviderStateMixin {
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController emailPwd = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  late TabController _tabController;
  int currentTag = 0;
  bool passwordValShow = true;
  bool passwordEmialShow = true;
  bool _isLoading = false;
  String _phoneValue = "";

  var dio = Dio(BaseOptions(
    connectTimeout: 2000,
  ));

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    sharedGetData("user_phone", String).then((data) {
      debugPrint("当前获取的用户信息:${data.toString()}");
      if (StringUtil.isNotEmpty(data)) {
        String loginInfo = data as String;
        setState(() {
          email.text = loginInfo;
        });
      }
    });
    phone.text = '';
    password.text = '';
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
        appBar: AppBar(
          title: Text(
            S.of(context).userLogin,
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
          leading: const Text(""),
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
          children: [createPhoneContent(), createEmailContent()],
        ));
  }

  Widget createPhoneContent() {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => closeKeyboard(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 52.w, right: 52.w),
          child: Form(
            key: _phoneKey,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 100.w)),
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
                //         S.of(context).userLogin,
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
                                    color: Color(0XFF302F4F), width: 1)),
                          ),
                          child: SizedBox(
                            width: 1.sw - 104.w,
                            child: IntlPhoneField(
                              focusNode: blankNode,
                              controller: phone,
                              keyboardType: TextInputType.phone,
                              // initialValue: _password,
                              style: TextStyle(
                                  fontSize: 32.sp,
                                  color: const Color(0xff051220)),
                              decoration: InputDecoration(
                                // icon: const Icon(Icons.perm_identity),
                                // 表单提示信息
                                hintText: "Please enter phone number",
                                hintStyle: TextStyle(
                                    fontSize: 32.sp,
                                    color: const Color(0xff737A83)),
                                // 取消自带的下边框
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    phone.clear();
                                  },
                                ),
                              ),
                              languageCode: "en",
                              onChanged: (value) {
                                _phoneValue = value.completeNumber;
                                debugPrint(value.completeNumber);
                              },
                              onCountryChanged: (country) {
                                debugPrint(
                                    'Country changed to: ${country.name}');
                              },
                              validator: (value) {
                                debugPrint("输入的手机号是:${value!.completeNumber}");
                                bool isphone = StringUtil.isPhoneNumber(
                                    value.completeNumber);

                                debugPrint("输入的手机号是:$isphone");

                                if ((!StringUtil.isPhoneNumber(
                                        value.completeNumber)) ||
                                    value.completeNumber.isEmpty) {
                                  return S.of(context).phoneError;
                                } else {
                                  return null;
                                }
                                // return value!.trim().isNotEmpty
                                //     ? null
                                //     : S.of(context).phoneError;
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
                                    color: Color(0XFF302F4F), width: 1)),
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
                                return value!.trim().length > 5
                                    ? null
                                    : S.of(context).passwordLabel;
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
                          Get.offAllNamed("/forget_password");
                        }),
                        child: const Text('forget the password',
                            style:
                                TextStyle(color: Colors.black45, fontSize: 14)))
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 200.w)),

                /// 登录
                SizedBox(
                    width: 1.sw - 104.w,
                    child: Builder(builder: (context) {
                      return ElevatedButton(
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
                          if (Form.of(context).validate()) {
                            // 请求登录
                            loginData();
                          } else {
                            return;
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
                                S.of(context).userLogin,
                                style: TextStyle(
                                    fontSize: 32.sp,
                                    color: const Color(0xffffffff)),
                              ),
                      );
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createEmailContent() {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () => closeKeyboard(context),
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 52.w, right: 52.w),
          child: Form(
            key: _mailKey,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 100.w)),
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
                //         S.of(context).userLogin,
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
                                    color: Color(0XFF302F4F), width: 1)),
                          ),
                          child: SizedBox(
                            width: 1.sw - 104.w,
                            child: TextFormField(
                              controller: email,
                              keyboardType: TextInputType.text,
                              // initialValue: _password,
                              style: TextStyle(
                                  fontSize: 32.sp,
                                  color: const Color(0xff051220)),
                              decoration: InputDecoration(
                                icon: const Icon(Icons.perm_identity),
                                // 表单提示信息
                                hintText: "Please input your email",
                                hintStyle: TextStyle(
                                    fontSize: 32.sp,
                                    color: const Color(0xff737A83)),
                                // 取消自带的下边框
                                border: InputBorder.none,
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    email.clear();
                                  },
                                ),
                              ),
                              validator: (value) {
                                debugPrint("输入的邮箱是:$value");
                                bool isemail = StringUtil.isEmail(value!);
                                debugPrint("输入的邮箱是:---$isemail");

                                if ((!StringUtil.isEmail(value)) ||
                                    value.isEmpty) {
                                  return S.of(context).phoneError;
                                } else {
                                  return null;
                                }
                                // return value!.trim().isNotEmpty
                                //     ? null
                                //     : S.of(context).phoneError;
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
                                    color: Color(0XFF302F4F), width: 1)),
                          ),
                          child: SizedBox(
                            width: 1.sw - 104.w,
                            child: TextFormField(
                              obscureText: passwordEmialShow,
                              controller: emailPwd,
                              style: TextStyle(
                                  fontSize: 32.sp,
                                  color: const Color(0xff051220)),
                              decoration: InputDecoration(
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passwordEmialShow = !passwordEmialShow;
                                      });
                                    },
                                    icon: Icon(!passwordEmialShow
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
                                return value!.trim().length > 5
                                    ? null
                                    : S.of(context).passwordLabel;
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
                          Get.offAllNamed("/forget_password");
                        }),
                        child: const Text('forget the password',
                            style:
                                TextStyle(color: Colors.black45, fontSize: 14)))
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 200.w)),

                /// 登录
                SizedBox(
                    width: 1.sw - 104.w,
                    child: Builder(builder: (context) {
                      return ElevatedButton(
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
                          if (Form.of(context).validate()) {
                            // 请求登录
                            loginData();
                          } else {
                            return;
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
                                S.of(context).userLogin,
                                style: TextStyle(
                                    fontSize: 32.sp,
                                    color: const Color(0xffffffff)),
                              ),
                      );
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loginData() {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> data = {
      "account": currentTag == 0 ? _phoneValue : email.text,
      "password": currentTag == 0
          ? AESUtil.generateAES(password.text)
          : AESUtil.generateAES(emailPwd.text),
    };
    debugPrint("用户登录的信息----${data.toString()}");
    // 根据输入的用户名密码登录云平台
    dio
        .post('${BaseConfig.cloudBaseUrl}/platform/appCustomer/login',
            data: data)
        .then((res) {
      var d = json.decode(res.toString());
      if (d['code'] != 200) {
        if (d['code'] == 9995) {
          ToastUtils.error(S.current.accountOrPwdError);
        }
        debugPrint("$d");
        return null;
      } else {
        debugPrint('用户$data,登录信息${d.toString()}');
        //存储用户信息
        sharedAddAndUpdate("user_token", String, (d['data']['token']));
        sharedAddAndUpdate("user_phone", String, (d['data']['account']));
        sharedAddAndUpdate(
            "loginUserInfo", String, jsonEncode(d['data'])); //把云平台登录信息保存到本地
        sharedAddAndUpdate(
        "userAvatar", String, jsonEncode(d['data']["avatar"]));
        int loginId = d['data']['id'];
        return loginId;
      }
    }).then((value) {
      debugPrint('请求云平台登录id：$value');
      if (value != null) {
        requestInquireRouterDevice(value);
      }else {
        return;
      }
    }).catchError((err) {
      debugPrint('请求云平台登录接口报错：$err');
      // 响应超时
      if ((err is DioError && err.type == DioErrorType.connectTimeout)) {
        debugPrint('timeout');
        ToastUtils.error(S.current.contimeout);
      } else {
        ToastUtils.error(S.current.loginFailed);
      }
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void requestInquireRouterDevice(int id) {
    App.get('/platform/appCustomer/get?id=$id').then((res) {
      final inquireModel = InquireInfoBean.fromJson(res);
      if (inquireModel.code == 200 && inquireModel.data!.customerCpeVOList != null) {
        var inquireSn = inquireModel.data!.customerCpeVOList![0].deviceSn;
        debugPrint("获取的查询到的设备号:$inquireSn");
        if (inquireSn!.isNotEmpty) {
          sharedAddAndUpdate("deviceSn", String, inquireSn);
          Get.offNamed("/home");
          toolbarController.setPageIndex(0);
        } else {
          Get.offNamed("/get_equipment");
        }
      } 
    }).catchError((error) {
      ToastUtils.error(error.toString());
    });
  }
}
