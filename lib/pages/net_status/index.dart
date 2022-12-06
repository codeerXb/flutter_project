import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_template/pages/net_status/arc_progress_bar.dart';

/// 消息页面
class NetStatus extends StatefulWidget {
  const NetStatus({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NetStatusState();
}

class _NetStatusState extends State<NetStatus> {
  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    press(String key) {
      setState(() => key == 'up' ? ++_progress : --_progress);
    }

    return Scaffold(
      appBar: customAppbar(title: '设备名字'),
      body: Container(
        padding: EdgeInsets.only(top: 20.h, left: 10.w, right: 10.w),
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Stack(
          children: [
            ArcProgresssBar(progress: _progress),
            Positioned(
              top: 0.1.sh,
              left: 0.43.sw,
              child: Text('已使用$_progress'),
            ),
            Positioned(
              top: 0.1.sh,
              left: 0.1.sw,
              child:
                  TextButton(onPressed: press('up'), child: const Text('增加')),
            ),
            Positioned(
                top: 0.2.sh,
                left: 0.1.sw,
                child: TextButton(
                    onPressed: press('down'), child: const Text('减少')))
          ],
        ),
      ),
    );
  }
}
