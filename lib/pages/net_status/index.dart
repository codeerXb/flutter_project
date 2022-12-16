import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_template/pages/net_status/arc_progress_bar.dart';
import 'package:flutter_template/pages/net_status/dashboard.dart';

/// 消息页面
class NetStatus extends StatefulWidget {
  const NetStatus({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetStatusState();
}

class _NetStatusState extends State<NetStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/images/picture_home_bg.png'),
              fit: BoxFit.fitWidth)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: const [
              Text('TL-WDR5620'),
              FaIcon(FontAwesomeIcons.chevronDown)
            ],
          ),
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            // 头部widget
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  left: 36.sp, right: 36.sp, top: 0, bottom: 30.sp),
              width: 1.sw,
              height: 240.h,
              color: Colors.transparent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                        height: 40.h,
                        padding: EdgeInsets.only(
                            left: 16.sp, right: 16.sp, top: 0, bottom: 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.sp)),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: const Text(
                          '套餐总量：G',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => {},
                          child: const FaIcon(FontAwesomeIcons.globe),
                        ),
                        ElevatedButton(
                            onPressed: () => {},
                            child: const FaIcon(FontAwesomeIcons.wifi)),
                        ElevatedButton(
                            onPressed: () => {},
                            child: const FaIcon(FontAwesomeIcons.simCard)),
                        TextButton(
                            onPressed: () => {},
                            child: Row(children: [
                              Text(
                                '套餐设置',
                                style: TextStyle(
                                    fontSize: 24.sp, color: Colors.white),
                              ),
                              FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: 24.sp,
                                color: Colors.white,
                              )
                            ]))
                      ],
                    )
                  ]),
            ),
            // 仪表盘和数值显示
            const Expanded(flex: 1, child: Dashboard()),
          ],
        ),
      ),
    );
  }
}
