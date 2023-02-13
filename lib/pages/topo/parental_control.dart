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
// import 'package:flutter_template/core/widget/left_slide_actions.dart';

class ParentalControl extends StatefulWidget {
  const ParentalControl({super.key});

  @override
  State<ParentalControl> createState() => _ParentalControlState();
}

class _ParentalControlState extends State<ParentalControl> {
  OnlineDeviceTable data = OnlineDeviceTable(mAC: '');
  AccessOpen aOpen = AccessOpen();
// 启用
  AccessDatas restart = AccessDatas();
  bool isCheck = false;
  int checkVal = 0;

  // 家长控制列表
  AccessListDatas accessList =
      AccessListDatas(fwParentControlTable: [], max: null);

  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
    });
    print(Get.arguments);
    getAccessList();
    getAccess();
  }

// 家长控制开启
  void getAccessOpen() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"securityParentControlEnable":"$checkVal"}',
    };
    printInfo(info: '---data----$data');
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          restart = AccessDatas.fromJson(d);
          if (restart.success == true) {
            ToastUtils.toast('提交成功');
            Get.back();
          } else {
            ToastUtils.toast('提交失败');
          }
        });
      } on FormatException catch (e) {
        print(e);
        // ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      // ToastUtils.toast(S.current.error);
    });
  }

// 家长控制  开关获取
  void getAccess() {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["securityParentControlEnable","Name","Host","Weekdays","TimeStart","Target"]'
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          aOpen = AccessOpen.fromJson(d);
          if (aOpen.securityParentControlEnable.toString() == '0') {
            isCheck = false;
            checkVal = 0;
          } else {
            isCheck = true;
            checkVal = 1;
          }
        });
      } on FormatException {
        print('The provided string is not valid JSON');
      }
    }).catchError((onError) {
      ToastUtils.toast('获取家长列表 失败');
      debugPrint('获取家长列表 失败：${onError.toString()}');
    });
  }

// 家长控制列表获取
  void getAccessList() {
    Map<String, dynamic> data = {
      'method': 'tab_dump',
      'param': '["FwParentControlTable"]'
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        debugPrint("\n======= 获取列表 =======");
        var d = json.decode(res.toString());
        print(d);
        setState(() {
          accessList = AccessListDatas.fromJson(d);
        });
      } on FormatException catch (e) {
        setState(() {
          accessList = AccessListDatas(fwParentControlTable: [], max: null);
        });
        print('The provided string is not valid JSON');
        print(e);
      }
    }).catchError((onError) {
      ToastUtils.toast('获取家长列表 失败');
      debugPrint('获取家长列表 失败：${onError.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '家长控制'),
      body: ListView(children: [
        Container(
            padding: const EdgeInsets.all(10.0),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.sp),
                ),
                InfoBox(
                  boxCotainer: Row(children: [
                    const TitleWidger(title: '家长控制'),
                    Padding(
                      padding: EdgeInsets.only(left: 325.sp),
                    ),
                    Switch(
                      value: isCheck,
                      onChanged: (newVal) {
                        setState(() {
                          isCheck = newVal;
                          if (isCheck == true) {
                            checkVal = 1;
                          } else {
                            checkVal = 0;
                          }
                          getAccessOpen();
                        });
                      },
                    ),
                  ]),
                ),
                // 列表
                if (accessList.fwParentControlTable!.isNotEmpty)
                  SizedBox(
                    width: 800.w,
                    height: 1050.w,
                    child: ListView(
                        children: accessList.fwParentControlTable!.map((item) {
                      return InfoBox(
                          boxCotainer: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${item.timeStart!}至${item.timeStop!}禁止访问',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 5, 0, 0),
                                  fontSize: ScreenUtil().setWidth(30.0))),
                          Text(item.weekdays.toString(),
                              style: TextStyle(
                                  color: const Color.fromRGBO(147, 148, 168, 1),
                                  fontSize: ScreenUtil().setWidth(28.0))),
                        ],
                      ));
                    }).toList()),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 25.sp),
                ),
                // + 新增
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
                        Get.toNamed("/parental_pop", arguments: data)
                            ?.then((value) => getAccessList());
                      },
                      child: Text("+", style: TextStyle(fontSize: 60.sp)),
                    )
                  ],
                ),
              ],
            )),
      ]),
    );
  }
}

class InfoBox extends StatelessWidget {
  final Widget boxCotainer;

  const InfoBox({super.key, required this.boxCotainer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0.w),
        margin: EdgeInsets.only(bottom: 20.w, left: 30.w, right: 30.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.w),
        ),
        child: boxCotainer);
  }
}
