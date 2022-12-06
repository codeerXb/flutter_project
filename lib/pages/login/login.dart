import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  final GlobalKey _formKey = GlobalKey<FormState>();
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();
  String _account = 'admin';
  String _password = 'admin123';
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;
  Color _accountBorderColor = Colors.white;
  Color _passwordBorderColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customAppbar(borderBottom: false),
      body: InkWell(
        onTap: () => closeKeyboard(context),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 70.w, right: 70.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  /// logo
                  Container(
                    margin: EdgeInsets.only(bottom: 40.w),
                    width: 500.w,
                    height: 400.w,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  /// 账号
                  buildAccountTextField(),
                  /// 密码
                  buildPasswordTextField(),
                  /// 登录
                  buildLoginButton(),
                  /// 协议
                  Container(
                    margin: EdgeInsets.only(top: 30.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          '点击登录，即表示以阅读并同意',
                          style: TextStyle(
                              fontSize: 12, color: Color.fromRGBO(153, 153, 153, 1)),
                        ),
                        InkWell(
                            child: const Text(
                              '《会员服务条款》',
                              style: TextStyle(color: Color.fromRGBO(85, 122, 157, 1), fontSize: 12),
                            ),
                            onTap: () =>
                                Get.toNamed("/user_agreement")
                        )
                      ],
                    ),
                  )
                ],
              ),),
          ),
        ),
      )
    );
  }

  ///账号
  Container buildAccountTextField() {
    return Container(
      padding: EdgeInsets.only(top: 55.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("账号",style: TextStyle(fontSize: 32.sp, color: const Color(0xff737A83))),
          Container(
            height: 90.w,
            padding: EdgeInsets.only(left: 40.w),
            margin: EdgeInsets.only(top: 24.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.w),
                color: const Color(0xffEEEFF2),
                border: Border.all(color: _accountBorderColor,width: 1.w)
            ),
            child: TextFormField(
                initialValue: _account,
                style: TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
                decoration: InputDecoration(
                  // 表单提示信息
                  hintText: "请输入账号",
                  hintStyle: TextStyle(fontSize: 32.sp, color: const Color(0xff737A83)),
                  // 取消自带的下边框
                  border: InputBorder.none,
                ),
                onSaved: (String? value) => {
                  _account = value! ,
                },
                onChanged: (String value) => _account = value,
                onTap: (){
                  setState(() {
                    _passwordBorderColor = Colors.white;
                    _accountBorderColor = const Color(0xff2692F0);
                  });
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ]
            ),
          ),
        ],
      ),
    );
  }

  ///密码
  Container buildPasswordTextField() {
    return Container(
      padding: EdgeInsets.only(top: 34.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("密码",style: TextStyle(fontSize: 32.sp, color: const Color(0xff737A83)),),
          Container(
              height: 90.w,
              padding: EdgeInsets.only(left: 40.w),
              margin: EdgeInsets.only(top: 24.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: const Color(0xffEEEFF2),
                  border: Border.all(color: _passwordBorderColor,width: 1.w)
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 450.w,
                    child: TextFormField(
                        initialValue: _password,
                        style: TextStyle(fontSize: 32.sp, color: const Color(0xff051220)),
                        decoration: InputDecoration(
                          // 表单提示信息
                          hintText: "请输入密码",
                          hintStyle: TextStyle(fontSize: 32.sp, color: const Color(0xff737A83)),
                          // 取消自带的下边框
                          border: InputBorder.none,
                        ),
                        obscureText: _isObscure,
                        onSaved: (String? value) => _password = value!,
                        onChanged: (String value) => _password = value,
                        onTap: (){
                          setState(() {
                            _accountBorderColor = Colors.white;
                            _passwordBorderColor = const Color(0xff2692F0);
                          });
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),
                        ]
                    ),
                  ),
                  const Expanded(child: Text("")),
                  IconButton(
                      iconSize: 30.w,
                      icon: Icon(Icons.remove_red_eye,color: _eyeColor,),
                      onPressed: () {
                        setState(() {
                          _eyeColor = _isObscure ? Colors.blue : Colors.grey;
                          _isObscure = !_isObscure;
                        });
                      }
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  ///登录按钮
  SizedBox buildLoginButton() {
    return SizedBox(
      width: 630.w,
      child: CommonWidget.buttonWidget(title: '登录', padding: const EdgeInsets.only(left: 0, right: 0), callBack: (){
        if ((_formKey.currentState as FormState).validate()) {
          onSubmit(context);
        }
      }),
    );
  }

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  ///执行提交方法
  void onSubmit(BuildContext context){
    closeKeyboard(context);
    if(_account.trim().isEmpty){
      ToastUtils.toast("账号不能为空");
    } else if(_password.trim().isEmpty) {
      ToastUtils.toast("密码不能为空");
    } else {
      Map<String, dynamic> data = {'username': _account.trim(),'password': base64Encode(utf8.encode(_password.trim().trim())), 'rememberMe': 'true','ismoble': 'ismoble'};
      List<String> loginInfo;
      if(data['username'] == 'admin' && data['password'] == base64Encode(utf8.encode('admin123'))){
        loginInfo = [data['username'], data['password'], '管理员', 'http://c.hiphotos.baidu.com/image/pic/item/9c16fdfaaf51f3de1e296fa390eef01f3b29795a.jpg'];
        sharedAddAndUpdate("loginInfo",List, loginInfo); //把登录信息保存到本地
        Get.offNamed("/home");
      } else {
        ToastUtils.toast('用户名或密码错误');
      }
    }
  }
}
