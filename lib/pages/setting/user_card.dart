import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/shared_preferences_util.dart';
import 'package:get/get.dart';

class UserCard extends StatefulWidget {
  final name;
  const UserCard({super.key, this.name});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  //手机号
  String _userPhone = 'null';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sharedGetData('user_phone', String).then(((res) {
      setState(() {
        _userPhone = res.toString();
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
      margin:  EdgeInsets.all(26.w), //设置卡片外边距
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(
                top: 20.w, bottom: 20.w, left: 40.w, right: 40.w),
            leading: ClipOval(
              child: Image.network(
                  "https://img0.baidu.com/it/u=2488974456,3750793943&fm=253&fmt=auto&app=138&f=JPEG?w=442&h=500",
                  fit: BoxFit.fitWidth,
                  height: 50,
                  width: 50),
            ),
            title: Text(_userPhone != 'null' ? _userPhone : '未登录',
                style: _userPhone != 'null'
                    ? const TextStyle(color: Color.fromARGB(255, 54, 152, 244))
                    : TextStyle(fontSize: 60.sp, color: Colors.grey)),
            subtitle: Text(_userPhone != 'null' ? '当前设备 ${widget.name}' : '',
                style: _userPhone != 'null'
                    ? TextStyle(fontSize: 22.sp, color: Colors.black)
                    : const TextStyle(fontSize: 0)),
            trailing: TextButton(
              onPressed: () {
                Get.offNamed("/use_login");
                if (_userPhone != 'null') {
                  sharedDeleteData('user_phone');
                  debugPrint('清楚用户信息');
                }
              },
              child: Text(_userPhone != 'null' ? '退出登录' : '登录',
                  style: _userPhone != 'null'
                      ? const TextStyle(color: Colors.red)
                      : TextStyle(fontSize: 40.sp, color: Colors.blue)),
            ),
          ),
        ],
      ),
    );
  }
}
