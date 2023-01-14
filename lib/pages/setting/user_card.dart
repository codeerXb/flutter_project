import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserCard extends StatefulWidget {
  final name;
  const UserCard({super.key, this.name});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, //设置卡片阴影的深度
      shape: const RoundedRectangleBorder(
        //设置卡片圆角
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.all(15), //设置卡片外边距
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
            title: const Text(
              '15936942568',
              style: TextStyle(color: Color.fromARGB(255, 54, 152, 244)),
            ),
            subtitle: Text(
              '当前设备 ${widget.name}',
              style: TextStyle(fontSize: 22.sp, color: Colors.black),
            ),
            trailing: TextButton(
              onPressed: () {
                Get.toNamed("/use_login");
              },
              child: const Text(
                '退出登录',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
