import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';

import '../../core/http/http.dart';
import '../../core/utils/toast.dart';
import 'model/access_datas.dart';

class ParentalControl extends StatefulWidget {
  const ParentalControl({super.key});

  @override
  State<ParentalControl> createState() => _ParentalControlState();
}

class _ParentalControlState extends State<ParentalControl> {
  OnlineDeviceTable data = OnlineDeviceTable(mAC: '');
  String uNKTitle = '设备信息';

  bool isCheck = false;

// 添加
  bool isClick = false;

  // 家长控制列表
  AccessListDatas accessList = AccessListDatas();
  List accesslistD = [];
  List<Widget> temList = [];

// 名称  设备
  String hostN = '';
  String mac = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
    });
    print(Get.arguments);
    getAccessList();
  }

// 家长控制列表获取
  void getAccessList() async {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["FwParentControlTable"]'
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        accessList = AccessListDatas.fromJson(d);
        accesslistD = accessList.fwParentControlTable!;
        print('--------${accessList.fwParentControlTable?[0].timeStart}');
        print('...${accesslistD != '' ? true : false}');
        if (accessList.fwParentControlTable != '') {
          print('走了');
          alist();
          print('===打印===$temList');

          print('是这里');
        }
      });
    } catch (e) {
      debugPrint('获取家长列表 失败：$e.toString()');
      ToastUtils.toast('获取家长列表 失败');
    }
  }

  List<Widget> alist() {
    for (var i = 0; i < accessList.fwParentControlTable!.length; i++) {
      temList.add(ListTile(
          title: Text(
              '78${accessList.fwParentControlTable![i].timeStart}--${accessList.fwParentControlTable![i].timeStop}禁止访问'),
          subtitle:
              Text('132${accessList.fwParentControlTable![i].weekdays}')));
    }
    return temList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '家长控制'),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.sp),
                ),
                // 家长控制
                Row(children: [
                  const TitleWidger(title: '家长控制'),
                  Padding(
                    padding: EdgeInsets.only(left: 400.sp),
                  ),
                  Switch(
                    value: isCheck,
                    onChanged: (newVal) {
                      setState(() {
                        isCheck = newVal;
                        // if (isCheck == true) {
                        //   checkVal = 1;
                        // } else {
                        //   checkVal = 0;
                        // }
                      });
                    },
                  ),
                ]),
                // 控制列表
                // Offstage(
                //   offstage: isCheck,
                //   child: InfoBox(
                //     boxCotainer: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Column(
                //           children: const [
                //             Text('02:00关闭Wi-Fi,06:00开启Wi-Fi',
                //                 style: TextStyle(
                //                   color: Color.fromARGB(255, 5, 0, 0),
                //                 )),
                //             Text('周一，周二，周三，周四，周五，周日',
                //                 style: TextStyle(
                //                   color: Color.fromARGB(255, 95, 94, 94),
                //                 )),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                InfoBox(
                  boxCotainer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: const [
                          Text('',
                              style: TextStyle(
                                color: Color.fromARGB(255, 5, 0, 0),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color(0xffffffff)), //背景颜色
                        foregroundColor: MaterialStateProperty.all(
                            const Color(0xff5E6573)), //字体颜色
                        overlayColor: MaterialStateProperty.all(
                            const Color(0xffffffff)), // 高亮色
                        shadowColor: MaterialStateProperty.all(
                            const Color(0xffffffff)), //阴影颜色
                        elevation: MaterialStateProperty.all(0), //阴影值
                        textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 12)), //字体
                        side: MaterialStateProperty.all(const BorderSide(
                            width: 1, color: Color(0xffCAD0DB))), //边框
                        shape: MaterialStateProperty.all(CircleBorder(
                            side: BorderSide(
                          //设置 界面效果
                          color: Colors.green,
                          width: 280.0.w,
                          style: BorderStyle.none,
                        ))), //圆角弧度
                      ),
                      onPressed: () {
                        Get.toNamed("/parental_pop", arguments: data);
                      },
                      child: Text("+", style: TextStyle(fontSize: 60.sp)),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
