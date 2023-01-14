import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';

/// 登录页面
class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    // 点击空白  关闭键盘 时传的一个对象
    FocusNode blankNode = FocusNode();

    /// 点击空白  关闭输入键盘
    void closeKeyboard(BuildContext context) {
      FocusScope.of(context).requestFocus(blankNode);
    }

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
                Get.offNamed("/get_equipment");
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
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 52.w, right: 52.w),
              child: Form(
                child: Column(
                  children: [
                    //跳过
                    upDowm(),
                    Padding(padding: EdgeInsets.only(top: 100.w)),

                    //logo&文字
                    logo(),
                    Padding(padding: EdgeInsets.only(top: 50.w)),

                    //手机号
                    buildPhoneField(),
                    Padding(padding: EdgeInsets.only(top: 20.w)),

                    /// 密码
                    buildPasswordTextField(),
                    Padding(padding: EdgeInsets.only(top: 20.w)),

                    /// 注册&忘记密码
                    registerAndForget(),
                    Padding(padding: EdgeInsets.only(top: 200.w)),

                    /// 登录
                    buildLoginButton(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

//跳过
Row upDowm() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(
          onPressed: () {
            Get.offAllNamed("/get_equipment");
          },
          child: const Text('跳过')),
    ],
  );
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
          'CPE管理平台',
          style: TextStyle(fontSize: 50.sp),
        ),
        Text(
          '路由器数据管理平台',
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
                // obscureText: _isObscure,
                // onSaved: (String? value) => _password = value!,
                // onChanged: (String value) => _password = value,
                onTap: () {
                  // setState(() {
                  //   _accountBorderColor = Colors.white;
                  //   _passwordBorderColor = const Color(0xff2692F0);
                  // });
                },
                // inputFormatters: [  LengthLimitingTextInputFormatter(50), ]
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

// 密码
Column buildPasswordTextField() {
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
                // initialValue: _password,
                style:
                    TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
                decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  // 表单提示信息
                  hintText: "请输入登录密码",
                  hintStyle: TextStyle(
                      fontSize: 32.sp, color: const Color(0xff737A83)),
                  // 取消自带的下边框
                  border: InputBorder.none,
                ),
                // obscureText: _isObscure,
                // onSaved: (String? value) => _password = value!,
                // onChanged: (String value) => _password = value,
                onTap: () {
                  // setState(() {
                  //   _accountBorderColor = Colors.white;
                  //   _passwordBorderColor = const Color(0xff2692F0);
                  // });
                },
                // inputFormatters: [  LengthLimitingTextInputFormatter(50), ]
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
            Get.toNamed("/use_register");
          }),
          child: const Text(
            '注册',
            style: TextStyle(color: Colors.black38),
          )),
      // 忘记密码
      TextButton(
          onPressed: (() {}),
          child: const Text('忘记密码', style: TextStyle(color: Colors.black38)))
    ],
  );
}

//登录按钮
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
        if (true) {
          Get.offAllNamed("/get_equipment");
        }
      },
      child: Text(
        '登录',
        style: TextStyle(fontSize: 32.sp, color: const Color(0xffffffff)),
      ),
    ),
  );
}
