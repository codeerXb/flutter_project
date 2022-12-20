import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/widget/common_widget.dart';
import '../../core/widget/custom_app_bar.dart';

/// 修改密码
class AccountSecurity extends StatefulWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  // 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  bool oldPasswordObscure = true;
  String oldPassword = '';
  Color oldPasswordEyeColor = Colors.grey;

  bool newPasswordObscure = true;
  String newPassword = '';
  Color newPasswordEyeColor = Colors.grey;

  bool renewPasswordObscure = true;
  String renewPassword = '';
  Color renewPasswordEyeColor = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '修改密码'),
      body: InkWell(
        onTap: () => closeKeyboard(context),
        child: SingleChildScrollView(
          child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// 上边的提示
                    topTipsWidget(),

                    /// 旧密码
                    oldPassWordWidget(),

                    /// 新密码
                    newPassWordWidget(),

                    /// 确认密码
                    renewPassWordWidget(),

                    /// 下面的提示
                    bottomTipsWidget(),

                    /// 提交
                    CommonWidget.buttonWidget(callBack: () {
                      if ((_formKey.currentState as FormState).validate()) {
                        onSubmit(context);
                      }
                    }),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  /// 上边的提示
  Widget topTipsWidget() {
    return Container(
      padding: EdgeInsets.only(left: 40.w, top: 20.w, bottom: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "请设置登陆密码",
            style: TextStyle(fontSize: 22.sp),
          ),
          Text("定期更新密码提高安全性", style: TextStyle(fontSize: 22.sp)),
        ],
      ),
    );
  }

  /// 旧密码
  Widget oldPassWordWidget() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      height: 120.w,
      padding: EdgeInsets.only(left: 40.w, right: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              "旧密码",
              style: TextStyle(fontSize: 26.sp, color: const Color(0xff737A83)),
            ),
          ),
          SizedBox(
            width: 530.w,
            child: Row(
              children: [
                SizedBox(
                  width: 400.w,
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 26.sp, color: const Color(0xff051220)),
                    decoration: InputDecoration(
                      hintText: "请输入旧密码",
                      hintStyle: TextStyle(
                          fontSize: 26.sp, color: const Color(0xff737A83)),
                      border: InputBorder.none,
                    ),
                    obscureText: oldPasswordObscure,
                    onSaved: (String? value) => oldPassword = value!,
                    onChanged: (String value) => oldPassword = value,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
                const Expanded(child: Text("")),
                IconButton(
                    iconSize: 30.w,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: oldPasswordEyeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        oldPasswordEyeColor =
                            oldPasswordObscure ? Colors.blue : Colors.grey;
                        oldPasswordObscure = !oldPasswordObscure;
                      });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 新密码
  Widget newPassWordWidget() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      height: 120.w,
      padding: EdgeInsets.only(left: 40.w, right: 20.w),
      margin: EdgeInsets.only(top: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              "新密码",
              style: TextStyle(fontSize: 26.sp, color: const Color(0xff737A83)),
            ),
          ),
          SizedBox(
            width: 530.w,
            child: Row(
              children: [
                SizedBox(
                  width: 400.w,
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 26.sp, color: const Color(0xff051220)),
                    decoration: InputDecoration(
                      hintText: "请输入新密码",
                      hintStyle: TextStyle(
                          fontSize: 26.sp, color: const Color(0xff737A83)),
                      border: InputBorder.none,
                    ),
                    obscureText: newPasswordObscure,
                    onSaved: (String? value) => newPassword = value!,
                    onChanged: (String value) => newPassword = value,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
                const Expanded(child: Text("")),
                IconButton(
                    iconSize: 30.w,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: newPasswordEyeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        newPasswordEyeColor =
                            newPasswordObscure ? Colors.blue : Colors.grey;
                        newPasswordObscure = !newPasswordObscure;
                      });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 确认密码
  Widget renewPassWordWidget() {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      height: 120.w,
      padding: EdgeInsets.only(left: 40.w, right: 20.w),
      margin: EdgeInsets.only(top: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              "确认密码",
              style: TextStyle(fontSize: 26.sp, color: const Color(0xff737A83)),
            ),
          ),
          SizedBox(
            width: 530.w,
            child: Row(
              children: [
                SizedBox(
                  width: 400.w,
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: 26.sp, color: const Color(0xff051220)),
                    decoration: InputDecoration(
                      hintText: "请确认新密码",
                      hintStyle: TextStyle(
                          fontSize: 26.sp, color: const Color(0xff737A83)),
                      border: InputBorder.none,
                    ),
                    obscureText: renewPasswordObscure,
                    onSaved: (String? value) => renewPassword = value!,
                    onChanged: (String value) => renewPassword = value,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                  ),
                ),
                const Expanded(child: Text("")),
                IconButton(
                    iconSize: 30.w,
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: renewPasswordEyeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        renewPasswordEyeColor =
                            renewPasswordObscure ? Colors.blue : Colors.grey;
                        renewPasswordObscure = !renewPasswordObscure;
                      });
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 下边的提示
  Widget bottomTipsWidget() {
    return Container(
      padding: EdgeInsets.only(
        left: 40.w,
        top: 20.w,
      ),
      child: Text(
        "密码必须是8~16位的数字、字符组合（不能是纯数字）",
        style: TextStyle(fontSize: 22.sp),
      ),
    );
  }

  /// 提交方法
  void onSubmit(BuildContext context) {
    closeKeyboard(context);
    if (oldPassword.trim().isEmpty) {
      ToastUtils.toast("旧密码不能为空");
    } else if (newPassword.trim().isEmpty) {
      ToastUtils.toast("新密码不能为空");
    } else if (renewPassword.trim().isEmpty) {
      ToastUtils.toast("确认密码不能为空");
    } else if (newPassword != renewPassword) {
      ToastUtils.toast("新密码和确认密码不一致");
    } else {
      // 这里还可能旧密码输入错误
      ToastUtils.success("密码修改成功");
      Get.back(result: {"newPassword": newPassword});
    }
  }

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }
}
