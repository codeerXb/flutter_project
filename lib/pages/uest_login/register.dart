import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';

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
  //密码
  dynamic _passwordVal = '';
  bool passwordValShow = true;
  //再次输入密码
  dynamic _againPassVal = '';
  bool againPassShow = true;
  @override
  Widget build(BuildContext context) {
    // 点击空白  关闭键盘 时传的一个对象
    FocusNode blankNode = FocusNode();

    /// 点击空白  关闭输入键盘
    void closeKeyboard(BuildContext context) {
      FocusScope.of(context).requestFocus(blankNode);
    }

    return Scaffold(
        // appBar: customAppbar(borderBottom: false),
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
                Get.toNamed("/use_login");
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
                                  hintText: "请输入登录密码",
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
                                  hintText: "请再次输入登录密码",
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
                                    return '二次密码不一致';
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
                      code(),

                      Padding(padding: EdgeInsets.only(top: 200.w)),

                      /// 注册按钮
                      buildLoginButton(),
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
          '注册',
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
                RegExp reg = RegExp(r'^\d{11}$');
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

//验证码
Row code() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        width: 400.w,
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Color(0XFF302F4F), width: 0.0)),
        ),
        child: SizedBox(
          child: TextFormField(
            style: TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
            decoration: InputDecoration(
              // 表单提示信息
              hintText: "请输入验证码",
              hintStyle:
                  TextStyle(fontSize: 32.sp, color: const Color(0xff737A83)),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return '请输入验证码';
              }
              return null;
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
            ],
          ),
        ),
      ),
      TextButton(
          onPressed: (() {
            // 获取验证码
            getCode();
          }),
          child: Text(
            '获取验证码',
            style: TextStyle(color: Colors.blue, fontSize: 30.w),
          )),
    ],
  );
}

// 获取验证码
getCode() async {
  var res = await XHttp.post(
      'http://172.16.20.231:8079/fota/fota/appCustomer/sendSmsOrEmailCode?account=$_phoneVal');

  ToastUtils.toast(res.message);
}

//注册按钮
SizedBox buildLoginButton() {
  return SizedBox(
    width: 1.sw - 104.w,
    child: ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.only(top: 28.w, bottom: 28.w),
        ),
        shape: MaterialStateProperty.all(const StadiumBorder()),
        backgroundColor:
            MaterialStateProperty.all(const Color.fromARGB(255, 30, 104, 233)),
      ),
      onPressed: () {
        //表单校验
        if ((_formKey.currentState as FormState).validate()) {
          ToastUtils.toast('注册成功');
          Get.toNamed("/use_login");
        }
      },
      child: Text(
        '注册',
        style: TextStyle(fontSize: 32.sp, color: const Color(0xffffffff)),
      ),
    ),
  );
}
