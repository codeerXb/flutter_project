import 'dart:convert';

import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:flutter_template/pages/topo/model/access_datas.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';

class ParentalUpdate extends StatefulWidget {
  const ParentalUpdate({super.key});

  @override
  State<ParentalUpdate> createState() => _ParentalUpdateState();
}

class _ParentalUpdateState extends State<ParentalUpdate> {
  OnlineDeviceTable data = OnlineDeviceTable(mac: '');
  FwParentControlTable dataList = FwParentControlTable();
// 提交
  AccessDatas restart = AccessDatas();

  String accTitle = S.current.parentalControl;
  bool isCheck = false;

//工作日
  List arr = [];
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

// 开始时间
  String startTim = '';
  String startTimeH = '';
  String startTimeM = '';
  String startTimDate = '';

// 结束时间
  String stopTim = '';
  String stopTimeH = '';
  String stopTimeM = '';
  String stopTimDate = '';

  // 传给showpicker组件
  // 开始时间
  Time _timeStart = Time(hour: 0, minute: 0);
  void onTimeStartChanged(Time newTime) {
    setState(() {
      _timeStart = newTime;
    });
  }

  // 结束时间
  Time _timeEnd = Time(hour: 0, minute: 0);
  void onTimeEndChanged(Time newTime) {
    setState(() {
      _timeEnd = newTime;
    });
  }

  // 家长控制列表
  AccessListDatas accessList = AccessListDatas();
  List accesslistD = [];
  List<Widget> temList = [];

// 名称  设备
  String id = '';
  String name = '';
  String equipmentName = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments['data'];
      dataList = Get.arguments['dataList'];
    });
    id = dataList.id.toString();
    arrList = dataList.weekdays.toString().split(',');
    for (var i in arrList) {
      arrListEng.add(i
          .toString()
          .replaceAll('周日', 'Sun')
          .replaceAll('周一', 'Mon')
          .replaceAll('周二', 'Tue')
          .replaceAll('周三', 'Wed')
          .replaceAll('周四', 'Thu')
          .replaceAll('周五', 'Fri')
          .replaceAll('周六', 'Sat'));
    }
    startTimDate = dataList.timeStart.toString();
    startTimeH = startTimDate.split(':')[0];
    startTimeM = startTimDate.split(':')[1];
    stopTimDate = dataList.timeStop.toString();
    stopTimeH = stopTimDate.split(':')[0];
    stopTimeM = stopTimDate.split(':')[1];
    name = dataList.name.toString();
    equipmentName = dataList.host.toString();
    setState(() {
      _timeStart =
          Time(hour: int.parse(startTimeH), minute: int.parse(startTimeM));
      _timeEnd = Time(hour: int.parse(stopTimeH), minute: int.parse(stopTimeM));
    });
  }

// 家长控制 修改
  void getAccessData() {
    Map<String, dynamic> data = {
      'method': 'tab_set',
      'param':
          '{"table":"FwParentControlTable","value":[{"id":$id,"Name":"$name","Weekdays":"${arrListEng.join(',')}","TimeStart":"$startTimeH:$startTimeM","TimeStop":"$stopTimeH:$stopTimeM","Host":"$equipmentName","Target":"DROP"}]}'
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          restart = AccessDatas.fromJson(d);
          if (restart.success == true) {
            ToastUtils.toast(S.current.modification + S.current.success);
            Get.back();
          } else {
            ToastUtils.toast(S.current.modification + S.current.error);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: S.current.parentalControl),
      body: SingleChildScrollView(
          child: Container(
        height: 1400.w,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 1),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30.w, right: 30.w, top: 100.w),
          child: Column(
            children: <Widget>[
              InfoBox(
                boxCotainer: Column(
                  children: [
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.current.name,
                      righText: name,
                    )),
                    BottomLine(
                        rowtem: RowContainer(
                      leftText: S.current.equipment,
                      righText: equipmentName,
                    )),
                    GestureDetector(
                      onTap: () {
                        // Sun,Mon,Tue,Wed,Thu,Fri,Sat
                        // 勾选框的状态
                        if (arrList.contains(S.current.Sun)) {
                          checkboxList[0]['value'] = true;
                        }
                        if (arrList.contains(S.current.mon)) {
                          checkboxList[1]['value'] = true;
                        }
                        if (arrList.contains(S.current.Tue)) {
                          checkboxList[2]['value'] = true;
                        }
                        if (arrList.contains(S.current.Wed)) {
                          checkboxList[3]['value'] = true;
                        }
                        if (arrList.contains(S.current.Thu)) {
                          checkboxList[4]['value'] = true;
                        }
                        if (arrList.contains(S.current.fri)) {
                          checkboxList[5]['value'] = true;
                        }
                        if (arrList.contains(S.current.Sat)) {
                          checkboxList[6]['value'] = true;
                        }
                        showBottomSheet();
                      },
                      child: BottomLine(
                        rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.current.workday,
                                  style: TextStyle(fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(arrList.join(),
                                      style: TextStyle(fontSize: 28.sp)),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
                                    size: 28.w,
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
                            value: _timeStart,
                            onChange: onTimeStartChanged,
                            minuteInterval: TimePickerInterval.FIVE,
                            // Optional onChange to receive value as DateTime
                            onChangeDateTime: (DateTime dateTime) {
                              startTim = dateTime.toString();
                              startTimeH = startTim.split(' ')[1].split(':')[0];
                              startTimeM = startTim.split(' ')[1].split(':')[1];
                            },
                          ),
                        );
                      },
                      child: BottomLine(
                        rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).DateReboot,
                                  style: TextStyle(fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(
                                      (startTimeH == '' && startTimeM == ''
                                          ? startTimDate
                                          : ('$startTimeH:$startTimeM')),
                                      style: TextStyle(fontSize: 28.sp)),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
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
                            value: _timeEnd,
                            onChange: onTimeEndChanged,
                            minuteInterval: TimePickerInterval.FIVE,
                            // Optional onChange to receive value as DateTime
                            onChangeDateTime: (DateTime dateTime) {
                              stopTim = dateTime.toString();
                              stopTimeH = stopTim.split(' ')[1].split(':')[0];
                              stopTimeM = stopTim.split(' ')[1].split(':')[1];
                            },
                          ),
                        );
                      },
                      child: BottomLine(
                        rowtem: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(S.of(context).TimeReboot,
                                  style: TextStyle(fontSize: 28.sp)),
                              Row(
                                children: [
                                  Text(
                                      (stopTimeH == '' && stopTimeM == ''
                                          ? stopTimDate
                                          : ('$stopTimeH:$stopTimeM')),
                                      style: TextStyle(fontSize: 28.sp)),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color:
                                        const Color.fromRGBO(144, 147, 153, 1),
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
              Padding(padding: EdgeInsets.only(top: 55.w)),
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
      )),
    );
  }

  // 工作日弹窗
  String result = '';
  List<Map<String, dynamic>> checkboxList = [
    {'text': S.current.Sun, 'value': false, 'index': 0},
    {'text': S.current.mon, 'value': false, 'index': 1},
    {'text': S.current.Tue, 'value': false, 'index': 2},
    {'text': S.current.Wed, 'value': false, 'index': 3},
    {'text': S.current.Thu, 'value': false, 'index': 4},
    {'text': S.current.fri, 'value': false, 'index': 5},
    {'text': S.current.Sat, 'value': false, 'index': 6},
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
                      arrListEng.add('Sun');
                    }
                    if (arr[1] == '1') {
                      arrList.add('周一,');
                      arrListEng.add('Mon');
                    }
                    if (arr[2] == '1') {
                      arrList.add('周二,');
                      arrListEng.add('Tue');
                    }
                    if (arr[3] == '1') {
                      arrList.add('周三,');
                      arrListEng.add('Wed');
                    }
                    if (arr[4] == '1') {
                      arrList.add('周四,');
                      arrListEng.add('Thu');
                    }
                    if (arr[5] == '1') {
                      arrList.add('周五,');
                      arrListEng.add('Fri');
                    }
                    if (arr[6] == '1') {
                      arrList.add(S.current.Sat);
                      arrListEng.add('Sat');
                    }
                  }
                  printInfo(info: arrList.toString());
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
}
