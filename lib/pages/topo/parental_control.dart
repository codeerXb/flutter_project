import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/core/widget/left_slide_actions.dart';
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
  // 启用状态 获取
  AccessOpen aOpen = AccessOpen();
// 启用 提交
  AccessDatas restart = AccessDatas();
  bool isCheck = false;
  int checkVal = 0;

  // 家长控制列表
  AccessListDatas accessList =
      AccessListDatas(fwParentControlTable: [], max: null);
  List arr = [];
  List arrList = [];
  // 列表左滑
  final Map<String, VoidCallback> _mapForHideActions = {};
  int del = 0;
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
            // Get.back();
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
          arr = accessList.fwParentControlTable!.map((text) => (text)).toList();
          for (var i in arr) {
            i.weekdays = i.weekdays
                .toString()
                .replaceAll('Sun', '周日')
                .replaceAll('Mon', '周一')
                .replaceAll('Tue', '周二')
                .replaceAll('Wed', '周三')
                .replaceAll('Thu', '周四')
                .replaceAll('Fri', '周五')
                .replaceAll('Sat', '周六');
          }
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

// 删除
  void getAccessDel() {
    Map<String, dynamic> data = {
      'method': 'tab_del',
      'param': '{"table":"FwParentControlTable","id":$del}',
    };
    printInfo(info: '---data----$data');
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          restart = AccessDatas.fromJson(d);
          if (restart.success == true) {
            ToastUtils.toast('删除 成功');
            getAccessList();
          } else {
            ToastUtils.toast('删除 失败');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '家长控制'),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
            Container(
              padding: const EdgeInsets.all(5.0),
              height: 1050.w,
              child: ListView.separated(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.fromLTRB(12, 20, 12, 30),
                itemCount: accessList.fwParentControlTable!.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) {
                  if (index < accessList.fwParentControlTable!.length) {
                    final String tempStr =
                        accessList.fwParentControlTable!.toString()[index];
                    return LeftSlideActions(
                      key: Key(tempStr),
                      actionsWidth: 120.w,
                      actions: [_buildDeleteBtn(index), _buildChangeBtn(index)],
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      actionsWillShow: () {
                        // 隐藏其他列表项的行为。
                        for (int i = 0;
                            i < accessList.fwParentControlTable!.length;
                            i++) {
                          if (index == i) {
                            continue;
                          }
                          String tempKey =
                              accessList.fwParentControlTable!.toString()[i];
                          VoidCallback? hideActions =
                              _mapForHideActions[tempKey];
                          if (hideActions != null) {
                            hideActions();
                          }
                        }
                      },
                      exportHideActions: (hideActions) {
                        _mapForHideActions[tempStr] = hideActions;
                      },
                      child: _buildListItem(index),
                    );
                  }
                  return const SizedBox.shrink();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10);
                },
                // 添加下面这句 内容未充满的时候也可以滚动。
                physics: const AlwaysScrollableScrollPhysics(),
                // 添加下面这句 是为了GridView的高度自适应, 否则GridView需要包裹在固定宽高的容器中。
                //shrinkWrap: true,
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: 25.sp),
          ),
          // + 按钮
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xffffffff)), //背景颜色
                  foregroundColor:
                      MaterialStateProperty.all(const Color(0xff5E6573)), //字体颜色
                  overlayColor:
                      MaterialStateProperty.all(const Color(0xffffffff)), // 高亮色
                  shadowColor:
                      MaterialStateProperty.all(const Color(0xffffffff)), //阴影颜色
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
        ]),
      )),
    );
  }

  Widget _buildListItem(final int index) {
    return Container(
        height: 150.w,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // 阴影颜色。
              color: Color(0x66EBEBEB),
              // 阴影xy轴偏移量。
              offset: Offset(0.0, 0.0),
              // 阴影模糊程度。
              blurRadius: 6.0,
              // 阴影扩散程度。
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.sp),
            ),
            Text(
                '${accessList.fwParentControlTable![index].timeStart!}至${accessList.fwParentControlTable![index].timeStop!}禁止访问',
                style: TextStyle(
                    color: const Color.fromARGB(255, 5, 0, 0),
                    fontSize: ScreenUtil().setWidth(30.0))),
            Padding(
              padding: EdgeInsets.only(top: 10.sp),
            ),
            Text(accessList.fwParentControlTable![index].weekdays.toString(),
                style: TextStyle(
                    color: const Color.fromRGBO(147, 148, 168, 1),
                    fontSize: ScreenUtil().setWidth(28.0))),
          ],
        ));
  }

  Widget _buildDeleteBtn(int index) {
    return GestureDetector(
      onTap: () {
        // 省略: 弹出是否删除的确认对话框。
        // index = accessList.fwParentControlTable![index].id!;
        // printInfo(info: '1111----$index');

        setState(() {
          del = accessList.fwParentControlTable![index].id!;
          getAccessDel();
        });
      },
      child: Container(
        width: 60,
        color: const Color(0xFFF20101),
        alignment: Alignment.center,
        child: const Text(
          '删除',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildChangeBtn(int index) {
    return GestureDetector(
      onTap: () {
        // 省略: 弹出是否删除的确认对话框。
        // index = accessList.fwParentControlTable![index].id!;
        // printInfo(info: '1111----$index');
        Get.toNamed("/parental_pop", arguments: data)
            ?.then((value) => getAccessList());
        setState(() {
          // del = accessList.fwParentControlTable![index].id!;
          // getAccessDel();
        });
      },
      child: Container(
        width: 60,
        color: Colors.green,
        alignment: Alignment.center,
        child: const Text(
          '修改',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
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
