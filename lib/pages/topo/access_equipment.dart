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

class AccessEquipment extends StatefulWidget {
  const AccessEquipment({super.key});

  @override
  State<AccessEquipment> createState() => _AccessEquipmentState();
}

class _AccessEquipmentState extends State<AccessEquipment> {
  OnlineDeviceTable data = OnlineDeviceTable(mAC: '');
  String uNKTitle = '设备信息';

  String accTitle = '家长控制';
  bool isCheck = false;

// 添加
  bool isClick = false;

// 时间
  String tim = '';
  String timeStart = '';
  String timeStop = '';

  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);
  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  String endShowVal = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
    });
    print(Get.arguments);
  }

// 重启定时提交
  void getTrestsetData() {
    Map<String, dynamic> data = {
      'method': 'tab_add',
      'param':
          '{"table":"FwParentControlTable","value":{"Name":"UNKNOWN","Weekdays":"Tue","TimeStart":"$timeStart:00","TimeStop":"$timeStop:00","Host":"B4:4C:3B:9E:46:3D","Target":"DROP"}}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          // restart = MaintainData.fromJson(d);
          // if (restart.success == true) {
          //   ToastUtils.toast('提交成功');
          // } else {
          //   ToastUtils.toast('提交失败');
          // }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast('提交失败');
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast('提交失败');
    });
  }

  @override
  Widget build(BuildContext context) {
    String formatDuration(Duration duration) {
      String hours = duration.inHours.toString().padLeft(0, '2');
      String minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "$hours:$minutes:$seconds";
    }

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
                // 列表
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
                            Text('列表',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 5, 0, 0),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //  + 按钮
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
                          printInfo(info: '点击过了');
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
                        BottomLine(
                            rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('工作日',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 5, 0, 0),
                                )),
                            // SizedBox(width: 50, child: Workday())
                          ],
                        )),
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
                                  tim = dateTime.toString();
                                  timeStop = tim.split(':')[1].split('-')[0];
                                  timeStart = tim
                                      .split(':')[0]
                                      .split('-')[2]
                                      .split(' ')[1];
                                },
                              ),
                            );
                          },
                          child: BottomLine(
                            rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('开始时间',
                                      style: TextStyle(fontSize: 30.sp)),
                                  Row(
                                    children: [
                                      Text(endShowVal,
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
                                  tim = dateTime.toString();
                                  timeStop = tim.split(':')[1].split('-')[0];
                                  timeStart = tim
                                      .split(':')[0]
                                      .split('-')[2]
                                      .split(' ')[1];
                                },
                              ),
                            );
                          },
                          child: BottomLine(
                            rowtem: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('结束时间',
                                      style: TextStyle(fontSize: 30.sp)),
                                  Row(
                                    children: [
                                      Text(endShowVal,
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
                          // height: 80.w,
                          alignment: Alignment.center,
                          child: Text(
                            "取消",
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.offAllNamed("/get_equipment");
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
                          // height: 80.w,
                          alignment: Alignment.center,
                          child: Text(
                            "确认",
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
