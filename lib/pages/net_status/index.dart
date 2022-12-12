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
  double _progress = 95.5;
  int get progress {
    return _progress.truncate();
  }

  @override
  Widget build(BuildContext context) {
    //舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
    void pressUp() {
      setState(() => ++_progress);
    }

    void pressDown() {
      setState((() => --_progress));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TL-WDR5620'),
        backgroundColor: const Color.fromARGB(255, 2, 0, 12),
        actions: [
          TextButton(
            onPressed: () => {},
            child: Row(children: const [
              Text(
                '中文',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              FaIcon(
                FontAwesomeIcons.globe,
                color: Colors.white,
              )
            ]),
          )
        ],
      ),
      body: Container(
        // alignment: Alignment.center,
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              color: const Color.fromARGB(255, 2, 0, 12),
              padding: const EdgeInsets.only(
                  left: 18, right: 18, top: 0, bottom: 30),
              width: 1.sw,
              height: 120,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                        height: 40.sp,
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 0, bottom: 0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.sp)),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: const Text(
                          '正常上网',
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
            Dashboard(
              progress2: _progress,
              progress: progress,
              pressUp: pressUp,
              pressDown: pressDown,
            ),
          ],
        ),
      ),
    );
  }
}
