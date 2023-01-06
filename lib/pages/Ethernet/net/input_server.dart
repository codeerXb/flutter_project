import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';

/// 检测服务器
class InputServer extends StatefulWidget {
  const InputServer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputServerState();
}

class _InputServerState extends State<InputServer> {
  dynamic data = '';

  @override
  void initState() {
    super.initState();
    data = Get.arguments;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(context: context, title: '检测服务器'),
        body: Container(
          padding: EdgeInsets.all(20.0.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoBox(
                    boxCotainer: Column(
                  children: [
                    BottomLine(
                      rowtem: TextFormField(
                        initialValue: data,
                        style: TextStyle(
                            fontSize: 32.sp, color: const Color(0xff051220)),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontSize: 32.sp, color: const Color(0xff737A83)),
                          // 取消自带的下边框
                          border: InputBorder.none,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
