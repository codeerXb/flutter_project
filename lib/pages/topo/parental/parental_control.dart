import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/core/widget/left_slide_actions.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/topo/model/access_datas.dart';

class ParentalControl extends StatefulWidget {
  const ParentalControl({super.key});

  @override
  State<ParentalControl> createState() => _ParentalControlState();
}

class _ParentalControlState extends State<ParentalControl> {
  OnlineDeviceTable data = OnlineDeviceTable(mac: '');
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
    getAccessList();
    getAccess();
  }

// 家长控制开启
  void getAccessOpen() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"securityParentControlEnable":"$checkVal"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          restart = AccessDatas.fromJson(d);
          if (restart.success == true) {
            ToastUtils.toast(S.current.save + S.current.success);
          } else {
            ToastUtils.toast(S.current.save + S.current.error);
          }
        });
      } on FormatException catch (e) {

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
      //获取家长列表 失败'
      ToastUtils.toast(S.current.getParebtalError);
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
        setState(() {
          accessList = AccessListDatas.fromJson(d);
          arr = accessList.fwParentControlTable!.map((text) => (text)).toList();
          for (var i in arr) {
            i.weekdays = i.weekdays
                .toString()
                .replaceAll('Sun', S.current.Sun)
                .replaceAll('Mon', S.current.mon)
                .replaceAll('Tue', S.current.Tue)
                .replaceAll('Wed', S.current.Wed)
                .replaceAll('Thu', S.current.Thu)
                .replaceAll('Fri', S.current.fri)
                .replaceAll('Sat', S.current.Sat);
          }
        });
      } on FormatException catch (e) {
        setState(() {
          accessList = AccessListDatas(fwParentControlTable: [], max: null);
        });
        print(e);
      }
    }).catchError((onError) {
      //获取家长列表 失败'
      ToastUtils.toast(S.current.getParebtalError);
      debugPrint('获取家长列表 失败：${onError.toString()}');
    });
  }

// 删除
  void getAccessDel() {
    Map<String, dynamic> data = {
      'method': 'tab_del',
      'param': '{"table":"FwParentControlTable","id":$del}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          restart = AccessDatas.fromJson(d);
          if (restart.success == true) {
            ToastUtils.toast(S.current.delete + S.current.success);
            getAccessList();
          } else {
            ToastUtils.toast(S.current.delete + S.current.error);
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
      appBar: customAppbar(context: context, title: S.current.parentalControl),
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
            boxCotainer: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidger(title: S.current.parentalControl),
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
                      actionsWidth: 120,
                      actions: [_buildChangeBtn(index), _buildDeleteBtn(index)],
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
        height: 130.w,
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
                '${accessList.fwParentControlTable![index].timeStart!}${S.current.to}${accessList.fwParentControlTable![index].timeStop!}${S.current.access}',
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

  Widget _buildDeleteBtn(final int index) {
    return GestureDetector(
      onTap: () {
        _openAvatarBottomSheet();
        setState(() {
          del = accessList.fwParentControlTable![index].id!;
        });
      },
      child: Container(
        width: 60,
        color: const Color(0xFFF20101),
        alignment: Alignment.center,
        child: Text(
          S.current.delete,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }

  _openAvatarBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: 260.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w))),
            child: Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.w),
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.w),
                              topRight: Radius.circular(30.w))),
                      height: 80.w,
                      alignment: Alignment.center,
                      child: const Text(
                        '提示',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      height: 60.w,
                      alignment: Alignment.topLeft,
                      child: Text(
                        '删除后将无法看到该条记录,请谨慎操作',
                        style:
                            TextStyle(color: Colors.black45, fontSize: 22.sp),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.w)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          width: 0.5.sw - 30.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.w),
                                  bottomLeft: Radius.circular(30.w))),
                          alignment: Alignment.center,
                          child: Text(
                            '取消',
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          getAccessDel();
                        },
                        child: Container(
                          height: 60.w,
                          width: 0.5.sw - 30.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.w),
                                  bottomRight: Radius.circular(30.w))),
                          alignment: Alignment.center,
                          child: Text(
                            '确定',
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildChangeBtn(final int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/parental_update", arguments: {
          'data': data,
          'dataList': accessList.fwParentControlTable![index]
        })?.then((value) => getAccessList());
        setState(() {});
      },
      child: Container(
        width: 60,
        color: Colors.green,
        alignment: Alignment.center,
        child: Text(
          S.current.modification,
          style: const TextStyle(
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
