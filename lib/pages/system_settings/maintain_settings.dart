// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/widget/common_widget.dart';
import 'package:flutter_template/core/widget/water_loading.dart';
import 'package:flutter_template/pages/login/login_controller.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_box.dart';
import '../../generated/l10n.dart';
import 'model/maintain_data.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';
/// 维护设置
class MaintainSettings extends StatefulWidget {
  const MaintainSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MaintainSettingsState();
}

class _MaintainSettingsState extends State<MaintainSettings> {
  // 是否开启重定时
  bool isCheck = false;
  int checkVal = 0;
  // 重启
  MaintainData maintainVal = MaintainData();
  // 定时
  MaintainData restart = MaintainData();
  // 恢复
  MaintainData factoryReset = MaintainData();
  // 重启的时间
  String restartTime = '0';
  // 开始时间
  String startShowVal = '0';
  int startVal = 0;
  // 结束时间
  String endShowVal = '0';
  int endVal = 0;
  String currentDate = "";
  String num = '';
  MaintainTrestsetData acquireData = MaintainTrestsetData();
  final LoginController loginController = Get.put(LoginController());

  DateTime dateTimeSelected = DateTime.now();

  void _openTimePickerSheet(BuildContext context) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        sheetTitle: 'Please set time',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        saveButtonText: 'Save',
      ),
    );

    if (result != null) {
      setState(() {
        dateTimeSelected = result;
        restartTime = "${dateTimeSelected.hour} : ${dateTimeSelected.minute}";
        debugPrint("获取重置时间:$restartTime");
        startShowVal = "${dateTimeSelected.hour}";
        endShowVal = "${dateTimeSelected.minute}";
        sharedAddAndUpdate("restartTime", String, restartTime);
      });
      debugPrint("${dateTimeSelected.hour},${dateTimeSelected.minute}");
    }
  }

  // 转换重启日期
  String tranfer = '0;0;0;0;0;0;0';
  String dateFormat(List<Map<String, dynamic>> date) {
    String res = '';
    for (var i = 0; i < date.length; i++) {
      res = '$res${date[i]['value'] ? '1' : '0'}';
      if (i < date.length - 1) {
        res = '$res;';
      }
    }
    return res;
  }

  //重启日期展示数组
  List arr = [];
  List arrList = [];
  String sn = '';
  // String typeEnable = '';
  // String typeDateToReboot = '';
  // String typeTime = '';

  @override
  void initState() {
    super.initState();
    sharedGetData('deviceSn', String).then(((res) {
      printInfo(info: 'deviceSn$res');
      setState(() {
        sn = res.toString();
        //状态为local 请求本地  状态为cloud  请求云端
        printInfo(info: 'state--${loginController.login.state}');
        if (mounted) {
          if (loginController.login.state == 'cloud' && sn.isNotEmpty) {
            getTRAcquireData();
          }
          if (loginController.login.state == 'local') {
            getTrestsetAcquireData();
          }
        }
      });
    }));
    sharedGetData("restartTime", String).then((value) {
      debugPrint("当前获取的重置时间是:${value.toString()}");
      restartTime = value.toString();
      if (restartTime == "null") {
        restartTime = "0 : 0";
      }
    });
  }

  // 重启 云端
  Future getReBootData() async {
    var parameterNames = {
      "method": "set",
      "nodes": {"systemReboot": "1"}
    };
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      debugPrint('响应------>$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast(S.current.success);
        loginout();
      } else {
        ToastUtils.toast(S.current.error);
      }
    } catch (e) {
      ToastUtils.error(S.current.contimeout);
    }
    // App.post('/platform/tr069/rebootDevice?deviceId=$sn').then((res) {
    //   var d = json.decode(res.toString());
    //   debugPrint('响应------>$d');
    //   if (d['code'] == 200) {
    //     ToastUtils.toast(S.current.success);
    //     loginout();
    //   } else {
    //     ToastUtils.toast(S.current.error);
    //   }
    // }).catchError((err) {
    //   ToastUtils.error(S.current.contimeout);
    // });
  }

  // 重启
  void getmaintaData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"systemReboot":"1"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          maintainVal = MaintainData.fromJson(d);
          if (maintainVal.success == true) {
            ToastUtils.toast(S.current.success);
            loginout();
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  void loginout() {
    // 出了usertoken不清除其他都可以清除
    sharedDeleteData('user_phone');
    sharedDeleteData('deviceSn');
    Get.offAllNamed("/get_equipment");
  }

  bool loading = false;

  // 获取 云端
  getTRAcquireData() async {
    setState(() {
      loading = true;
    });
    printInfo(info: 'sn在这里有值吗-------$sn');
    // var parameterNames = [
    //   "InternetGatewayDevice.WEB_GUI.ScheduleReboot.Enable",
    //   "InternetGatewayDevice.WEB_GUI.ScheduleReboot.DateToReboot",
    //   "InternetGatewayDevice.WEB_GUI.ScheduleReboot.Time",
    // ];
    var parameterNames = {
      "method": "get",
      "nodes": [
        "systemScheduleRebootEnable",
        "systemScheduleRebootDays",
        "systemScheduleRebootTime"
      ]
    };
    var res = await Request().getACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      printInfo(info: '````$jsonObj');
      setState(() {
        // typeEnable = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
        //     ["ScheduleReboot"]["DateToReboot"]["_type"]!;
        // typeDateToReboot = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
        //     ["ScheduleReboot"]["Enable"]["_type"]!;
        // typeTime = jsonObj["data"]["InternetGatewayDevice"]["WEB_GUI"]
        //     ["ScheduleReboot"]["Time"]["_type"]!;

        if (jsonObj["data"]["systemScheduleRebootEnable"] == false) {
          isCheck = false;
          checkVal = 0;
        } else {
          isCheck = true;
          checkVal = 1;
        }

        tranfer = jsonObj["data"]["systemScheduleRebootDays"];
        if (tranfer != '') {
          // 展示获取回来的重启日期
          arr = tranfer.split(';').map((String text) => (text)).toList();
          if (arr[0] == '1') {
            currentDate = S.of(context).Sun;
            arrList.add(S.of(context).Sun);
          }
          if (arr[1] == '1') {
            currentDate = S.of(context).mon;
            arrList.add(S.of(context).mon);
          }
          if (arr[2] == '1') {
            currentDate = S.of(context).Tue;
            arrList.add(S.current.Tue);
          }
          if (arr[3] == '1') {
            currentDate = S.of(context).Wed;
            arrList.add(S.current.Wed);
          }
          if (arr[4] == '1') {
            currentDate = S.of(context).Thu;
            arrList.add(S.current.Thu);
          }
          if (arr[5] == '1') {
            currentDate = S.of(context).fri;
            arrList.add(S.current.fri);
          }
          if (arr[6] == '1') {
            currentDate = S.of(context).Sat;
            arrList.add(S.current.Sat);
          }
        }

        num = jsonObj["data"]["systemScheduleRebootTime"];
        // if (num != '') {
        //   startVal = [
        //     '0',
        //     '1',
        //     '2',
        //     '3',
        //     '4',
        //     '5',
        //     '6',
        //     '7',
        //     '8',
        //     '9',
        //     '10',
        //     '11',
        //     '12',
        //     '13',
        //     '14',
        //     '15',
        //     '16',
        //     '17',
        //     '18',
        //     '19',
        //     '20',
        //     '21',
        //     '22',
        //     '23',
        //   ].indexOf(num.split(':')[0].toString());
        //   startShowVal = num.split(':')[0];
        //   endVal = [
        //     '0',
        //     '1',
        //     '2',
        //     '3',
        //     '4',
        //     '5',
        //     '6',
        //     '7',
        //     '8',
        //     '9',
        //     '10',
        //     '11',
        //     '12',
        //     '13',
        //     '14',
        //     '15',
        //     '16',
        //     '17',
        //     '18',
        //     '19',
        //     '20',
        //     '21',
        //     '22',
        //     '23',
        //   ].indexOf(num.split(':')[1].toString());
        //   endShowVal = num.split(':')[1];
        // }
      });
    } catch (e) {
      debugPrint('获取信息失败：${e.toString()}');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // 设置 云端
  setTRAcquireData() async {
    // var parameterNames = [
    //   [
    //     "InternetGatewayDevice.WEB_GUI.ScheduleReboot.Enable",
    //     isCheck,
    //     typeEnable
    //   ],
    //   [
    //     "InternetGatewayDevice.WEB_GUI.ScheduleReboot.DateToReboot",
    //     tranfer,
    //     typeDateToReboot
    //   ],
    //   [
    //     "InternetGatewayDevice.WEB_GUI.ScheduleReboot.Time",
    //     '$startShowVal:$endShowVal',
    //     typeTime
    //   ]
    // ];

    var isEnable = isCheck == true ? "1" : "0";

    var parameterNames = {
      "method": "set",
      "nodes": {
        "systemScheduleRebootEnable": isEnable,
        "systemScheduleRebootDays": tranfer,
        "systemScheduleRebootTime": '$startShowVal:$endShowVal'
      }
    };
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      debugPrint('获取返回结果：$jsonObj');
      setState(() {});
    } catch (e) {
      ToastUtils.toast("获取信息失败：${e.toString()}");
      debugPrint('获取信息失败：${e.toString()}');
    }
  }

  // 重启定时提交
  void getTrestsetData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param':
          '{"systemScheduleRebootEnable":"$checkVal","systemScheduleRebootDays":"$tranfer","systemScheduleRebootTime":"$startShowVal:$endShowVal"}',
    };
    debugPrint("${data.toString()}");
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          restart = MaintainData.fromJson(d);
          debugPrint(restart.toString());
          if (restart.success == true) {
            ToastUtils.toast(S.current.success);
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  // 重启定时 获取
  void getTrestsetAcquireData() async {
    Map<String, dynamic> data = {
      'method': 'obj_get',
      'param':
          '["systemScheduleRebootEnable","systemScheduleRebootDays","systemScheduleRebootTime"]'
    };
    try {
      var response = await XHttp.get('/data.html', data);
      var d = json.decode(response.toString());
      setState(() {
        acquireData = MaintainTrestsetData.fromJson(d);
        if (acquireData.systemScheduleRebootEnable.toString() == '0') {
          isCheck = false;
          checkVal = 0;
        } else {
          isCheck = true;
          checkVal = 1;
        }

        num = acquireData.systemScheduleRebootTime.toString();
        // if (num != '') {
        //   startVal = [
        //     '0',
        //     '1',
        //     '2',
        //     '3',
        //     '4',
        //     '5',
        //     '6',
        //     '7',
        //     '8',
        //     '9',
        //     '10',
        //     '11',
        //     '12',
        //     '13',
        //     '14',
        //     '15',
        //     '16',
        //     '17',
        //     '18',
        //     '19',
        //     '20',
        //     '21',
        //     '22',
        //     '23',
        //   ].indexOf(num.split(':')[0].toString());
        //   startShowVal = num.split(':')[0];
        //   endVal = [
        //     '0',
        //     '1',
        //     '2',
        //     '3',
        //     '4',
        //     '5',
        //     '6',
        //     '7',
        //     '8',
        //     '9',
        //     '10',
        //     '11',
        //     '12',
        //     '13',
        //     '14',
        //     '15',
        //     '16',
        //     '17',
        //     '18',
        //     '19',
        //     '20',
        //     '21',
        //     '22',
        //     '23',
        //   ].indexOf(num.split(':')[1].toString());
        //   endShowVal = num.split(':')[1];
        // }

        tranfer = acquireData.systemScheduleRebootDays.toString();
        if (tranfer != '') {
          // 展示获取回来的重启日期
          arr = tranfer.split(';').map((String text) => (text)).toList();
          if (arr[0] == '1') {
            arrList.add(S.of(context).Sun);
          }
          if (arr[1] == '1') {
            arrList.add(S.of(context).mon);
          }
          if (arr[2] == '1') {
            arrList.add(S.current.Tue);
          }
          if (arr[3] == '1') {
            arrList.add(S.current.Wed);
          }
          if (arr[4] == '1') {
            arrList.add(S.current.Thu);
          }
          if (arr[5] == '1') {
            arrList.add(S.current.fri);
          }
          if (arr[6] == '1') {
            arrList.add(S.current.Sat);
          }
        }
      });
    } catch (e) {
      debugPrint('获取重启定时 失败：$e.toString()');
      ToastUtils.toast(S.current.error);
    }
  }

  // 恢复出厂 云端
  Future getfactoryResetData() async {
    var parameterNames = {
      "method": "set",
      "nodes": {"systemFactoryReset": "1", "systemReboot": "1"}
    };
    var res = await Request().setACSNode(parameterNames, sn);
    try {
      var jsonObj = jsonDecode(res);
      debugPrint('响应------>$jsonObj');
      if (jsonObj['code'] == 200) {
        ToastUtils.toast(S.current.success);
        loginout();
      } else {
        ToastUtils.toast(S.current.error);
      }
    } catch (e) {
      ToastUtils.error(S.current.contimeout);
    }
    // App.post('/platform/tr069/factoryReset?deviceId=$sn').then((res) {
    //   var d = json.decode(res.toString());
    //   debugPrint('响应------>$d');
    //   if (d['code'] == 200) {
    //     ToastUtils.toast(S.current.success);
    //     loginout();
    //   } else {
    //     ToastUtils.toast(S.current.error);
    //   }
    // }).catchError((err) {
    //   ToastUtils.error(S.current.contimeout);
    // });
  }

  // 恢复出厂
  void getfactoryReset() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param': '{"systemFactoryReset":"1","systemRebootFlag":"1"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          factoryReset = MaintainData.fromJson(d);
          if (factoryReset.success == true) {
            ToastUtils.toast(S.current.success);
            loginout();
          } else {
            ToastUtils.toast(S.current.error);
          }
        });
      } on FormatException catch (e) {
        ToastUtils.toast(S.current.error);
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast(S.current.error);
    });
  }

  // 日期弹窗
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
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
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
                child: Text(S.current.cancel,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(checkboxList);
                setState(() {
                  tranfer = dateFormat(checkboxList);
                  debugPrint("当前设置的日期是:$tranfer");
                  // 选中后更新重启日期
                  arrList = [];
                  if (arrList != []) {
                    arr = tranfer
                        .split(';')
                        .map((String text) => (text))
                        .toList();
                    if (arr[0] == '1') {
                      arrList.add(S.of(context).Sun);
                    }
                    if (arr[1] == '1') {
                      arrList.add(S.of(context).mon);
                    }
                    if (arr[2] == '1') {
                      arrList.add(S.current.Tue);
                    }
                    if (arr[3] == '1') {
                      arrList.add(S.current.Wed);
                    }
                    if (arr[4] == '1') {
                      arrList.add(S.current.Thu);
                    }
                    if (arr[5] == '1') {
                      arrList.add(S.current.fri);
                    }
                    if (arr[6] == '1') {
                      arrList.add(S.current.Sat);
                    }
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
                child: Text(S.of(context).confirm,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
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
              height: 460.sp,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: S.current.maintainSettings),
      body: loading
          ? const Center(
              child: SizedBox(
                height: 80,
                width: 80,
                child: WaterLoading(
                  color: Color.fromARGB(255, 65, 167, 251),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(240, 240, 240, 1)),
                height: 1400.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TitleWidger(title: S.current.RebootScheduler),
                    InfoBox(
                        boxCotainer: Column(children: [
                      // 开启冲重定时
                      BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.current.EnableRebootScheduler),
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
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      // 重启日期
                      Offstage(
                        offstage: !isCheck,
                        child: GestureDetector(
                          onTap: () {
                            // 勾选框的状态
                            if (arrList.contains(S.of(context).Sun)) {
                              checkboxList[0]['value'] = true;
                            }
                            if (arrList.contains(S.of(context).mon)) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(S.of(context).EnableScheduler,
                                      style: TextStyle(fontSize: 30.sp)),
                                  Row(
                                    children: [
                                      Text(currentDate,
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
                      ),
                      // 开始时间
                      Offstage(
                        offstage: !isCheck,
                        child: GestureDetector(
                          onTap: () {
                            // Get.offAllNamed('/change_password');
                            _openTimePickerSheet(context);
                            // var result = CommonPicker.showPicker(
                            //   context: context,
                            //   options: [
                            //     '0',
                            //     '1',
                            //     '2',
                            //     '3',
                            //     '4',
                            //     '5',
                            //     '6',
                            //     '7',
                            //     '8',
                            //     '9',
                            //     '10',
                            //     '11',
                            //     '12',
                            //     '13',
                            //     '14',
                            //     '15',
                            //     '16',
                            //     '17',
                            //     '18',
                            //     '19',
                            //     '20',
                            //     '21',
                            //     '22',
                            //     '23',
                            //   ],
                            //   value: startVal,
                            // );
                            // result?.then((selectedValue) => {
                            //       if (startVal != selectedValue &&
                            //           selectedValue != null)
                            //         {
                            //           setState(() => {
                            //                 startVal = selectedValue,
                            //                 startShowVal = [
                            //                   '0',
                            //                   '1',
                            //                   '2',
                            //                   '3',
                            //                   '4',
                            //                   '5',
                            //                   '6',
                            //                   '7',
                            //                   '8',
                            //                   '9',
                            //                   '10',
                            //                   '11',
                            //                   '12',
                            //                   '13',
                            //                   '14',
                            //                   '15',
                            //                   '16',
                            //                   '17',
                            //                   '18',
                            //                   '19',
                            //                   '20',
                            //                   '21',
                            //                   '22',
                            //                   '23',
                            //                 ][startVal],
                            //               })
                            //         }
                            //     });
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
                                      Text(restartTime,
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
                      ),
                      // 结束时间
                      // Offstage(
                      //   offstage: !isCheck,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       var result = CommonPicker.showPicker(
                      //         context: context,
                      //         options: [
                      //           '0',
                      //           '1',
                      //           '2',
                      //           '3',
                      //           '4',
                      //           '5',
                      //           '6',
                      //           '7',
                      //           '8',
                      //           '9',
                      //           '10',
                      //           '11',
                      //           '12',
                      //           '13',
                      //           '14',
                      //           '15',
                      //           '16',
                      //           '17',
                      //           '18',
                      //           '19',
                      //           '20',
                      //           '21',
                      //           '22',
                      //           '23',
                      //         ],
                      //         value: endVal,
                      //       );
                      //       result?.then((selectedValue) => {
                      //             if (endVal != selectedValue &&
                      //                 selectedValue != null)
                      //               {
                      //                 setState(() => {
                      //                       endVal = selectedValue,
                      //                       endShowVal = [
                      //                         '0',
                      //                         '1',
                      //                         '2',
                      //                         '3',
                      //                         '4',
                      //                         '5',
                      //                         '6',
                      //                         '7',
                      //                         '8',
                      //                         '9',
                      //                         '10',
                      //                         '11',
                      //                         '12',
                      //                         '13',
                      //                         '14',
                      //                         '15',
                      //                         '16',
                      //                         '17',
                      //                         '18',
                      //                         '19',
                      //                         '20',
                      //                         '21',
                      //                         '22',
                      //                         '23',
                      //                       ][endVal],
                      //                     })
                      //               }
                      //           });
                      //     },
                      //     child: BottomLine(
                      //       rowtem: Row(
                      //           mainAxisAlignment:
                      //               MainAxisAlignment.spaceBetween,
                      //           children: [
                      //             Text(S.of(context).TimeReboot,
                      //                 style: TextStyle(fontSize: 30.sp)),
                      //             Row(
                      //               children: [
                      //                 Text(endShowVal,
                      //                     style: TextStyle(fontSize: 30.sp)),
                      //                 Icon(
                      //                   Icons.arrow_forward_ios_outlined,
                      //                   color: const Color.fromRGBO(
                      //                       144, 147, 153, 1),
                      //                   size: 30.w,
                      //                 )
                      //               ],
                      //             ),
                      //           ]),
                      //     ),
                      //   ),
                      // )
                    ])),
                    Center(
                      child: SizedBox(
                        height: 70.sp,
                        width: 680.sp,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 48, 118, 250))),
                          onPressed: () {
                            ToastUtils.toast("Saved successfully");
                            if (tranfer == '0;0;0;0;0;0;0' && isCheck == true) {
                              ToastUtils.toast(S.current.mustSuccess);
                            } else {
                              if (mounted) {
                                if (loginController.login.state == 'cloud' &&
                                    sn.isNotEmpty) {
                                  setTRAcquireData();
                                } else if (loginController.login.state ==
                                    'local') {
                                  getTrestsetData();
                                }
                              }
                            }
                          },
                          child: Text(S.of(context).save,style:const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.sp)),
                    TitleWidger(title: S.current.Reboot),
                    InfoBox(
                      boxCotainer: BottomLine(
                        rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.current.clickReboot,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 70.sp,
                        width: 680.sp,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 48, 118, 250))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text(S.current.hint),
                                      content: Text(S.of(context).isRestart),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(S.current.cancel),
                                          onPressed: () {
                                            //取消
                                            Navigator.pop(context, 'Cancle');
                                          },
                                        ),
                                        TextButton(
                                            child: Text(S.current.confirm),
                                            onPressed: () {
                                              //确定
                                              Navigator.pop(context, "Ok");
                                              Navigator.push(
                                                  context,
                                                  DialogRouter(
                                                      LoadingDialog()));
                                              if (mounted) {
                                                if (loginController
                                                            .login.state ==
                                                        'cloud' &&
                                                    sn.isNotEmpty) {
                                                  getReBootData();
                                                }
                                                if (loginController
                                                        .login.state ==
                                                    'local') {
                                                  getmaintaData();
                                                }
                                              }
                                              Navigator.pop(context);
                                            })
                                      ]);
                                });
                          },
                          child: Text(S.current.Reboot,style:const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.sp)),
                    TitleWidger(title: S.current.FactoryReset),
                    InfoBox(
                      boxCotainer: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          BottomLine(
                            rowtem: Text(
                              S.current.clickFactory,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 70.sp,
                        width: 680.sp,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 48, 118, 250))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text(S.current.hint),
                                      content: Text(S.of(context).isReset),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(S.current.cancel),
                                          onPressed: () {
                                            //取消
                                            Navigator.pop(context, 'Cancle');
                                          },
                                        ),
                                        TextButton(
                                            child: Text(S.current.confirm),
                                            onPressed: () {
                                              //确定
                                              Navigator.pop(context, "Ok");
                                              Navigator.push(
                                                  context,
                                                  DialogRouter(
                                                      LoadingDialog()));
                                              if (mounted) {
                                                if (loginController
                                                            .login.state ==
                                                        'cloud' &&
                                                    sn.isNotEmpty) {
                                                  getfactoryResetData();
                                                }
                                                if (loginController
                                                        .login.state ==
                                                    'local') {
                                                  getfactoryReset();
                                                }
                                              }
                                              Navigator.pop(context);
                                            })
                                      ]);
                                });
                          },
                          child: Text(S.current.FactoryReset,style:const TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
