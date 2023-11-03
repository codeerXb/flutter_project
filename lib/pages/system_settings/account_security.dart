import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../core/http/http.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/custom_app_bar.dart';
import '../../generated/l10n.dart';
import 'model/account_data.dart';

/// 修改密码修改密码
class AccountSecurity extends StatefulWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  bool oldPasswordObscure = true;
  String oldPassword = '';
  Color oldPasswordEyeColor = Colors.grey;

  final TextEditingController newPasswordController = TextEditingController();
  bool newPasswordObscure = true;
  String newPassword = '';
  Color newPasswordEyeColor = Colors.grey;

  final TextEditingController renewPasswordController = TextEditingController();
  bool renewPasswordObscure = true;
  String renewPassword = '';
  Color renewPasswordEyeColor = Colors.grey;

  AccountSettingData accountSetData = AccountSettingData();
  AccountSettingData accountData = AccountSettingData();

// 点击空白  关闭键盘 时传的一个对象
  FocusNode blankNode = FocusNode();

  /// 点击空白  关闭输入键盘
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

//旧密码
  bool oldPasswordShow = true;
  // 新密码
  bool newPasswordShow = true;
  // 确认密码
  bool againPasswordShow = true;

  String sn = '';
  String typeName = '';
  String typePas = '';

  final LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();

    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
      });
    }));

    oldPasswordController.addListener(() {
      debugPrint('监听旧密码：${oldPasswordController.text}');
      debugPrint('1测试${oldPasswordController.text}');
    });

    newPasswordController.addListener(() {
      debugPrint('监听新密码：${newPasswordController.text}');
      debugPrint('2测试${newPasswordController.text}');
    });

    renewPasswordController.addListener(() {
      debugPrint('监听确认密码：${renewPasswordController.text}');
      debugPrint('3测试${renewPasswordController.text}');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

// 设置 云端
  setTRWanData() async {
    var parameterNames = [
      [
        "InternetGatewayDevice.WEB_GUI.System.Account.ChangePassword.Admin",
        renewPasswordController.text,
        'xsd:string'
      ],
    ];
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {
        if (jsonObj["code"] == 200) {
          ToastUtils.toast(S.current.success);
          Get.back();
        } else {
          ToastUtils.toast(S.current.error);
        }
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  //验证旧密码
  void getAccountSetting() async {
    Map<String, dynamic> data = {
      'method': 'user_pwd',
      'param':
          '{"username":"superadmin","password":"${oldPasswordController.text}","newpassword":"${renewPasswordController.text}"}',
    };

    await XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          accountSetData = AccountSettingData.fromJson(d);
          if (accountSetData.success == true) {
            getAccountSec();
          } else {
            ToastUtils.toast(accountSetData.msg.toString());
          }
        });
      } on FormatException {
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  void getAccountSec() async {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"webGuiRestart":"1"}',
    };
    await XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        accountSetData = AccountSettingData.fromJson(d);
        if (accountSetData.success == true) {
          ToastUtils.toast(S.current.success);
        } else {
          ToastUtils.toast(accountSetData.msg.toString());
        }
      } on FormatException catch (e) {
        print(e);
      }
    }).catchError((onError) {
      debugPrint('失败333：${onError.toString()}');
      ToastUtils.toast('${S.current.error}333');
    });
  }

  late bool _isLoading = false;
  // 提交
  Future<void> _saveData() async {
    setState(() {
      _isLoading = true;
    });
    closeKeyboard(context);
    if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
      // 云端请求赋值
      try {
        await setTRWanData();
      } catch (e) {
        debugPrint('云端请求出错：${e.toString()}');
      }
    }
    if (loginController.login.state == 'local') {
      // 本地请求赋值
      getAccountSetting();
    }
    setState(() {
      _isLoading = false;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: S.current.accountSecurity,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.all(20.w),
              child: OutlinedButton(
                onPressed: _isLoading ? null : _saveData,
                child: Row(
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    if (!_isLoading)
                      Text(
                        S.current.save,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _isLoading ? Colors.grey : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ]),
      body: InkWell(
        onTap: () => closeKeyboard(context),
        child: SingleChildScrollView(
          child: Container(
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
              height: 1400.w,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // TitleWidger(title: S.of(context).Settings),
                    Padding(padding: EdgeInsets.only(top: 20.w)),
                    /// 上边的提示
                    // topTipsWidget(),

                    InfoBox(
                      boxCotainer: Column(
                        children: [
                          /// 旧密码
                          oldPassWordWidget(),
                          Padding(padding: EdgeInsets.only(top: 10.w)),

                          /// 新密码
                          newPassWordWidget(),
                          Padding(padding: EdgeInsets.only(top: 10.w)),

                          /// 确认密码
                          renewPassWordWidget(),

                          /// 下面的提示
                          // bottomTipsWidget(),
                        ],
                      ),
                    ),

                    /// 提交
                    // Padding(
                    //     padding: EdgeInsets.only(top: 15.w),
                    //     child: Center(
                    //         child: SizedBox(
                    //       height: 70.sp,
                    //       width: 680.sp,
                    //       child: ElevatedButton(
                    //         style: ButtonStyle(
                    //             backgroundColor: MaterialStateProperty.all(
                    //                 const Color.fromARGB(255, 48, 118, 250))),
                    //         onPressed: () {
                    //           if ((_formKey.currentState as FormState)
                    //               .validate()) {
                    //             onSubmit();
                    //           }
                    //         },
                    //         child: Text(
                    //           S.of(context).save,
                    //           style: TextStyle(fontSize: 36.sp),
                    //         ),
                    //       ),
                    //     )))
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
      padding: EdgeInsets.only(left: 40.w, bottom: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            S.current.loginPassword,
            style: TextStyle(fontSize: 22.sp),
          ),
          Text(S.current.improveSecurity, style: TextStyle(fontSize: 22.sp)),
        ],
      ),
    );
  }

  /// 旧密码
  Widget oldPassWordWidget() {
    return BottomLine(
      rowtem: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(S.current.oldPassowld,
              style: TextStyle(
                  color: const Color.fromARGB(255, 5, 0, 0), fontSize: 28.sp)),
          SizedBox(
            height: 80.w,
            width: 300.w,
            child: TextFormField(
              textAlign: TextAlign.right,
              obscureText: oldPasswordShow,
              controller: oldPasswordController,
              style: TextStyle(fontSize: 26.sp, color: const Color(0xff051220)),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        oldPasswordShow = !oldPasswordShow;
                      });
                    },
                    icon: Icon(!oldPasswordShow
                        ? Icons.visibility
                        : Icons.visibility_off)),
                hintText: S.current.ConfirmOldPassowld,
                hintStyle:
                    TextStyle(fontSize: 26.sp, color: const Color(0xff737A83)),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return S.of(context).passwordLabel;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 新密码
  Widget newPassWordWidget() {
    return BottomLine(
      rowtem: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(S.current.newPassowld,
              style: TextStyle(
                  color: const Color.fromARGB(255, 5, 0, 0), fontSize: 28.sp)),
          SizedBox(
            height: 80.w,
            width: 300.w,
            child: TextFormField(
              textAlign: TextAlign.right,
              obscureText: newPasswordShow,
              controller: newPasswordController,
              style: TextStyle(fontSize: 26.sp, color: const Color(0xff051220)),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        newPasswordShow = !newPasswordShow;
                      });
                    },
                    icon: Icon(!newPasswordShow
                        ? Icons.visibility
                        : Icons.visibility_off)),
                hintText: S.current.ConfirmnewPassowld,
                hintStyle:
                    TextStyle(fontSize: 26.sp, color: const Color(0xff737A83)),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return S.of(context).passwordLabel;
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 确认密码
  Widget renewPassWordWidget() {
    return BottomLine(
      rowtem: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(S.current.confrimPassorld,
              style: TextStyle(
                  color: const Color.fromARGB(255, 5, 0, 0), fontSize: 28.sp)),
          SizedBox(
            height: 80.w,
            width: 300.w,
            child: TextFormField(
              textAlign: TextAlign.right,
              obscureText: againPasswordShow,
              controller: renewPasswordController,
              style: TextStyle(fontSize: 26.sp, color: const Color(0xff051220)),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        againPasswordShow = !againPasswordShow;
                      });
                    },
                    icon: Icon(!againPasswordShow
                        ? Icons.visibility
                        : Icons.visibility_off)),
                hintText: S.current.confrimPassorld,
                hintStyle:
                    TextStyle(fontSize: 26.sp, color: const Color(0xff737A83)),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (newPasswordController.text !=
                    renewPasswordController.text) {
                  return S.of(context).passwordAgainError;
                }
                return null;
              },
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
        S.current.PassRule,
        style: TextStyle(fontSize: 22.sp),
      ),
    );
  }

  /// 提交方法
  void onSubmit() {
    // 这里还可能旧密码输入错误
//状态为local 请求本地  状态为cloud  请求云端
    printInfo(info: 'state--${loginController.login.state}');
    if (mounted) {
      if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
        setTRWanData();
      }
      if (loginController.login.state == 'local') {
        getAccountSetting();
      }
    }
  }
}
