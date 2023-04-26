import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';

class UserCard extends StatefulWidget {
  final name;
  const UserCard({super.key, this.name});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final LoginController loginController = Get.put(LoginController());

  //手机号
  String _userPhone = 'null';
  String sn = 'null';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedGetData('user_phone', String).then(((res) {
      printInfo(info: '用户手机号：$res');
      setState(() {
        _userPhone = res.toString();
      });
    }));
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, //设置卡片阴影的深度
      shape: const RoundedRectangleBorder(
        //设置卡片圆角
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: EdgeInsets.all(26.w), //设置卡片外边距
      child: Column(
        children: [
          ListTile(
              contentPadding: EdgeInsets.only(
                  top: 20.w, bottom: 20.w, left: 40.w, right: 40.w),
              //图片
              leading: ClipOval(
                  child: Image.asset('assets/images/people.png',
                      fit: BoxFit.fitWidth, height: 50, width: 50)),
              //中间文字
              title: Text(
                  _userPhone != 'null' ? _userPhone : S.of(context).noLogin,
                  style: _userPhone != 'null'
                      ? const TextStyle(
                          color: Color.fromARGB(255, 54, 152, 244))
                      : TextStyle(fontSize: 40.sp, color: Colors.black38)),
              //title下方显示的内容
              // 登录后可实现远程控制
              subtitle: Text(
                  _userPhone != 'null'
                      ? '${S.of(context).currentDeive} $sn'
                      : S.of(context).Remote,
                  style: TextStyle(fontSize: 27.sp, color: Colors.black38)),
              //标题后显示的widget
              trailing: CommonWidget.buttonWidget(
                title: _userPhone != 'null'
                    ? S.of(context).logOut
                    : S.of(context).login,
                callBack: () {
                  if (_userPhone != 'null') {
                    loginController.setState('cloud');
                    printInfo(info: 'state--${loginController.login.state}');
                  }
                  Get.offNamed("/user_login");
                  sharedDeleteData('user_phone');
                  sharedDeleteData('user_token');
                  debugPrint('清除用户信息');
                },
                background: _userPhone != 'null'
                    ? const Color.fromARGB(255, 255, 0, 0)
                    : const Color.fromRGBO(41, 121, 255, 1),
              )),
        ],
      ),
    );
  }
}
