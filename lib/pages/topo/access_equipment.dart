import 'dart:convert';

import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/http/http.dart';
import '../../core/utils/toast.dart';
import '../../generated/l10n.dart';
import 'model/access_datas.dart';

class AccessEquipment extends StatefulWidget {
  const AccessEquipment({super.key});

  @override
  State<AccessEquipment> createState() => _AccessEquipmentState();
}

class _AccessEquipmentState extends State<AccessEquipment> {
  OnlineDeviceTable data = OnlineDeviceTable(mAC: '');
  String uNKTitle = '设备信息';

// 提交
  AccessDatas restart = AccessDatas();

  String accTitle = '家长控制';
  bool isCheck = false;

//工作日
  List arr = [];
  String b = '';
  String c = '';
  String d = '';
  String e = '';
  String f = '';
  String g = '';
  String h = '';
  List arrList = [];
  List arrListEng = [];
  String tranfer = '';
  String dateFormat(List<Map<String, dynamic>> date) {
    String res = '';
    for (var i = 0; i < date.length; i++) {
      res = '$res${date[i]['value'] ? '1' : '0'}';
      if (i < date.length - 1) {
        res = '$res,';
      }
    }
    return res;
  }

// 添加
  bool isClick = false;

// 开始时间
  String startTim = '';
  String startTimeH = '';
  String startTimeM = '';

// 结束时间
  String stopTim = '';
  String stopTimeH = '';
  String stopTimeM = '';

  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);
  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

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
    hostN = data.hostName.toString();
    mac = data.mAC.toString();

    print(Get.arguments);
    getAccessList();
  }

// 家长控制 提交
  void getAccessData() {
    Map<String, dynamic> data = {
      'method': 'tab_add',
      'param':
          '{"table":"FwParentControlTable","value":{"Name":"$hostN","Weekdays":"${arrListEng.join()}","TimeStart":"$startTimeH:$startTimeM","TimeStop":"$startTimeH:$startTimeM","Host":"$mac","Target":"DROP"}}',
    };
    printInfo(info: '---data----$data');
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          restart = AccessDatas.fromJson(d);
          if (restart.success == true) {
            ToastUtils.toast('提交成功');
          } else {
            ToastUtils.toast('提交失败');
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
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
        // tranfer = accessList.systemScheduleRebootDays.toString();
        // if (tranfer != '') {
        //   // 展示获取回来的重启日期
        //   arr = tranfer.split(';').map((String text) => (text)).toList();
        //   if (arr[0] == '1') {
        //     arrList.add('周日');
        //   }
        //   if (arr[1] == '1') {
        //     arrList.add('周一');
        //   }
        //   if (arr[2] == '1') {
        //     arrList.add('周二');
        //   }
        //   if (arr[3] == '1') {
        //     arrList.add('周三');
        //   }
        //   if (arr[4] == '1') {
        //     arrList.add('周四');
        //   }
        //   if (arr[5] == '1') {
        //     arrList.add('周五');
        //   }
        //   if (arr[6] == '1') {
        //     arrList.add('周六');
        // }
        // }
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
    // String formatDuration(Duration duration) {
    //   String hours = duration.inHours.toString().padLeft(0, '2');
    //   String minutes =
    //       duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    //   String seconds =
    //       duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    //   return "$hours:$minutes:$seconds";
    // }

    return Scaffold(
      appBar: customAppbar(context: context, title: data.hostName.toString()),
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
                Row(children: [
                  TitleWidger(title: uNKTitle),
                ]),
                InfoBox(
                  boxCotainer: Column(
                    children: [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: 'MAC地址',
                        righText: data.mAC.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).IPAddress,
                        righText: data.iP.toString(),
                      )),
                      BottomLine(
                        rowtem: RowContainer(
                          leftText: '租约时间',
                          righText: DateFormat("dd天HH小时mm分钟").format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  int.parse('${data.leaseTime}000'))),
                        ),
                      ),
                      BottomLine(
                        rowtem: RowContainer(
                          leftText: '类型',
                          righText: data.type.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.sp),
                ),
                // 家长控制
                Row(children: [
                  TitleWidger(title: accTitle),
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
                Offstage(
                  offstage: !isCheck,
                  child: InfoBox(
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
                ),
                // 控制 + 按钮
                Offstage(
                  offstage: !isCheck,
                  child: Row(
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
                          addClick();
                        },
                        child: Text("+", style: TextStyle(fontSize: 60.sp)),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  // 工作日弹窗
  String result = '';
  List<Map<String, dynamic>> checkboxList = [
    {'text': '周日', 'value': false, 'index': 0},
    {'text': '周一', 'value': false, 'index': 1},
    {'text': '周二', 'value': false, 'index': 2},
    {'text': '周三', 'value': false, 'index': 3},
    {'text': '周四', 'value': false, 'index': 4},
    {'text': '周五', 'value': false, 'index': 5},
    {'text': '周六', 'value': false, 'index': 6},
  ];
  //显示底部弹框的功能
  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        builder: (BuildContext context) {
          //构建弹框中的内容
          return buildBottomSheetWidget(context);
        },
        context: context);
  }

  Widget buildBottomSheetWidget(BuildContext context) {
    //弹框中内容  310 的调试
    return SizedBox(
      height: 600.w,
      child: Column(
        children: [
          buildItem(result, onTap: () {}),

          Padding(padding: EdgeInsets.only(top: 60.sp)),
          //   //取消按钮
          //   //添加个点击事件
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
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
                child: const Text("取消",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(checkboxList);
                setState(() {
                  tranfer = dateFormat(checkboxList);
                  // 选中后更新工作日
                  // Sun,Mon,Tue,Wed,Thu,Fri,Sat
                  arrList = [];
                  arrListEng = [];
                  if (arrList != []) {
                    arr = tranfer
                        .split(',')
                        .map((String text) => (text))
                        .toList();
                    if (arr[0] == '1') {
                      arrList.add('周日,');
                      arrListEng.add('Sun,');
                    }
                    if (arr[1] == '1') {
                      arrList.add('周一,');
                      arrListEng.add('Mon,');
                    }
                    if (arr[2] == '1') {
                      arrList.add('周二,');
                      arrListEng.add('Tue,');
                    }
                    if (arr[3] == '1') {
                      arrList.add('周三,');
                      arrListEng.add('Wed,');
                    }
                    if (arr[4] == '1') {
                      arrList.add('周四,');
                      arrListEng.add('Thu,');
                    }
                    if (arr[5] == '1') {
                      arrList.add('周五,');
                      arrListEng.add('Fri,');
                    }
                    if (arr[6] == '1') {
                      arrList.add('周六');
                      arrListEng.add('Sat');
                    }
                    printInfo(info: '----${arrListEng.join()}');
                  }
                });
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
                child: const Text("确定",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            )
          ])
        ],
      ),
    );
  }

  Widget buildItem(String title, {onTap}) {
    //添加点击事件
    return StatefulBuilder(
        builder: (context, void Function(void Function()) setState) {
      return InkWell(
          //点击回调
          onTap: () {
            //关闭弹框
            Navigator.of(context).pop();
            //外部回调
            if (onTap != null) {
              onTap();
            }
          },
          child: SizedBox(
              height: 460.w,
              child: Column(
                children: checkboxList
                    .map((item) => Flexible(
                          child: CheckboxListTile(
                            title: Text('${item['text']}'),
                            value: item['value'],
                            activeColor: Colors.blueAccent,
                            isThreeLine: false,
                            dense: false,
                            selected: false,
                            controlAffinity: ListTileControlAffinity.trailing,
                            onChanged: (data) {
                              setState(() {
                                checkboxList[item['index']]['value'] = data;
                              });
                            },
                          ),
                        ))
                    .toList(),
              )));
    });
  }

// 点击 + 弹窗
  addClick() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: 660.w,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.w),
                    topRight: Radius.circular(30.w))),
            child: Padding(
              padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 10.w),
              child: Column(
                children: <Widget>[
                  InfoBox(
                    boxCotainer: Column(
                      children: [
                        BottomLine(
                            rowtem: RowContainer(
                          leftText: '名称',
                          righText: data.hostName.toString(),
                        )),
                        BottomLine(
                            rowtem: RowContainer(
                          leftText: '设备',
                          righText: data.mAC.toString(),
                        )),
                        GestureDetector(
                          onTap: () {
                            // Sun,Mon,Tue,Wed,Thu,Fri,Sat
                            // 勾选框的状态
                            if (arrList.contains('周日')) {
                              checkboxList[0]['value'] = true;
                            }
                            if (arrList.contains('周一')) {
                              checkboxList[1]['value'] = true;
                            }
                            if (arrList.contains('周二')) {
                              checkboxList[2]['value'] = true;
                            }
                            if (arrList.contains('周三')) {
                              checkboxList[3]['value'] = true;
                            }
                            if (arrList.contains('周四')) {
                              checkboxList[4]['value'] = true;
                            }
                            if (arrList.contains('周五')) {
                              checkboxList[5]['value'] = true;
                            }
                            if (arrList.contains('周六')) {
                              checkboxList[6]['value'] = true;
                            }
                            showBottomSheet();
                          },
                          child: BottomLine(
                            rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('工作日',
                                      style: TextStyle(fontSize: 30.sp)),
                                  Row(
                                    children: [
                                      Text(arrList.join(),
                                          style: TextStyle(fontSize: 30.sp)),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: const Color.fromRGBO(
                                            144, 147, 153, 1),
                                        size: 30.w,
                                      )
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: onTimeChanged,
                                minuteInterval: MinuteInterval.FIVE,
                                // Optional onChange to receive value as DateTime
                                onChangeDateTime: (DateTime dateTime) {
                                  startTim = dateTime.toString();
                                  startTimeH =
                                      startTim.split(' ')[1].split(':')[0];
                                  startTimeM =
                                      startTim.split(' ')[1].split(':')[1];
                                },
                              ),
                            );
                          },
                          child: BottomLine(
                            rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).DateReboot,
                                      style: TextStyle(fontSize: 30.sp)),
                                  Row(
                                    children: [
                                      Text(('$startTimeH:$startTimeM'),
                                          style: TextStyle(fontSize: 30.sp)),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: const Color.fromRGBO(
                                            144, 147, 153, 1),
                                        size: 30.w,
                                      )
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              showPicker(
                                context: context,
                                value: _time,
                                onChange: onTimeChanged,
                                minuteInterval: MinuteInterval.FIVE,
                                // Optional onChange to receive value as DateTime
                                onChangeDateTime: (DateTime dateTime) {
                                  stopTim = dateTime.toString();
                                  stopTimeH =
                                      stopTim.split(' ')[1].split(':')[0];
                                  stopTimeM =
                                      stopTim.split(' ')[1].split(':')[1];
                                },
                              ),
                            );
                          },
                          child: BottomLine(
                            rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).TimeReboot,
                                      style: TextStyle(fontSize: 30.sp)),
                                  Row(
                                    children: [
                                      Text(('$stopTimeH:$stopTimeM'),
                                          style: TextStyle(fontSize: 30.sp)),
                                      Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: const Color.fromRGBO(
                                            144, 147, 153, 1),
                                        size: 30.w,
                                      )
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                      ],
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
                            S.current.cancel,
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          getAccessData();
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
                            S.of(context).confirm,
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
}
