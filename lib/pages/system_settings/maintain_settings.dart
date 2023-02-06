// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_box.dart';
import '../../core/widget/common_picker.dart';
import 'model/maintain_data.dart';

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
  MaintainData maintainVal = MaintainData();

  MaintainData restart = MaintainData();

// 开始时间
  String startShowVal = '0';
  int startVal = 0;
// 结束时间
  String endShowVal = '0';
  int endVal = 0;

  String num = '';
  MaintainTrestsetData acquireData = MaintainTrestsetData();
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

//
  List arr = [];
  String b = '';
  String c = '';
  String d = '';
  String e = '';
  String f = '';
  String g = '';
  String h = '';
  List arrList = [];

  @override
  void initState() {
    super.initState();
    getTrestsetAcquireData();
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
            ToastUtils.toast('重启成功');
            loginout();
          } else {
            ToastUtils.toast('重启失败');
          }
        });
      } on FormatException catch (e) {
        print(e);
        ToastUtils.toast('重启失败');
      }
    }).catchError((onError) {
      debugPrint('失败：${onError.toString()}');
      ToastUtils.toast('重启失败');
    });
  }

  void loginout() {
    // 这里还需要调用后台接口的方法
    sharedDeleteData("loginInfo");
    sharedClearData();
    Get.offAllNamed("/get_equipment");
  }

  // 重启定时提交
  void getTrestsetData() {
    Map<String, dynamic> data = {
      'method': 'obj_set',
      'param':
          '{"systemScheduleRebootEnable":"$checkVal","systemScheduleRebootDays":"$tranfer","systemScheduleRebootTime":"$endShowVal:$startShowVal"}',
    };
    XHttp.get('/data.html', data).then((res) {
      try {
        var d = json.decode(res.toString());
        setState(() {
          restart = MaintainData.fromJson(d);
          if (restart.success == true) {
            ToastUtils.toast('提交成功');
          } else {
            ToastUtils.toast('提交失败');
          }
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
        startVal = [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
        ].indexOf(num.split(':')[0].toString());
        startShowVal = num.split(':')[0];
        endVal = [
          '0',
          '1',
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '10',
          '11',
          '12',
          '13',
          '14',
          '15',
          '16',
          '17',
          '18',
          '19',
          '20',
          '21',
          '22',
          '23',
        ].indexOf(num.split(':')[1].toString());
        endShowVal = num.split(':')[1];
        tranfer = acquireData.systemScheduleRebootDays.toString();
        // 展示获取回来的重启日期
        arr = tranfer.split(';').map((String text) => (text)).toList();
        if (arr[0] == '1') {
          arrList.add('周日');
        }
        if (arr[1] == '1') {
          arrList.add('周一');
        }
        if (arr[2] == '1') {
          arrList.add('周二');
        }
        if (arr[3] == '1') {
          arrList.add('周三');
        }
        if (arr[4] == '1') {
          arrList.add('周四');
        }
        if (arr[5] == '1') {
          arrList.add('周五');
        }
        if (arr[6] == '1') {
          arrList.add('周六');
        }
      });
    } catch (e) {
      debugPrint('获取重启定时 失败：$e.toString()');
      ToastUtils.toast('获取重启定时 失败');
    }
  }

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
                  // 选中后更新重启日期
                  arrList = [];
                  if (arrList != []) {
                    arr = tranfer
                        .split(';')
                        .map((String text) => (text))
                        .toList();
                    if (arr[0] == '1') {
                      arrList.add('周日');
                    }
                    if (arr[1] == '1') {
                      arrList.add('周一');
                    }
                    if (arr[2] == '1') {
                      arrList.add('周二');
                    }
                    if (arr[3] == '1') {
                      arrList.add('周三');
                    }
                    if (arr[4] == '1') {
                      arrList.add('周四');
                    }
                    if (arr[5] == '1') {
                      arrList.add('周五');
                    }
                    if (arr[6] == '1') {
                      arrList.add('周六');
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
      appBar: customAppbar(context: context, title: '维护设置'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 20.w, left: 30.w, right: 30.w),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          height: 2000.w,
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: '重启定时'),
              ]),
              InfoBox(
                  boxCotainer: Column(children: [
                // 开启冲重定时
                BottomLine(
                  rowtem: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('开启重启定时'),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('重启日期', style: TextStyle(fontSize: 30.sp)),
                            Row(
                              children: [
                                Text(arrList.toString(),
                                    style: TextStyle(fontSize: 30.sp)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
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
                      var result = CommonPicker.showPicker(
                        context: context,
                        options: [
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10',
                          '11',
                          '12',
                          '13',
                          '14',
                          '15',
                          '16',
                          '17',
                          '18',
                          '19',
                          '20',
                          '21',
                          '22',
                          '23',
                        ],
                        value: startVal,
                      );
                      result?.then((selectedValue) => {
                            if (startVal != selectedValue &&
                                selectedValue != null)
                              {
                                setState(() => {
                                      startVal = selectedValue,
                                      startShowVal = [
                                        '0',
                                        '1',
                                        '2',
                                        '3',
                                        '4',
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9',
                                        '10',
                                        '11',
                                        '12',
                                        '13',
                                        '14',
                                        '15',
                                        '16',
                                        '17',
                                        '18',
                                        '19',
                                        '20',
                                        '21',
                                        '22',
                                        '23',
                                      ][startVal],
                                    })
                              }
                          });
                    },
                    child: BottomLine(
                      rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('开始时间', style: TextStyle(fontSize: 30.sp)),
                            Row(
                              children: [
                                Text(startShowVal,
                                    style: TextStyle(fontSize: 30.sp)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
                // 结束时间
                Offstage(
                  offstage: !isCheck,
                  child: GestureDetector(
                    onTap: () {
                      var result = CommonPicker.showPicker(
                        context: context,
                        options: [
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10',
                          '11',
                          '12',
                          '13',
                          '14',
                          '15',
                          '16',
                          '17',
                          '18',
                          '19',
                          '20',
                          '21',
                          '22',
                          '23',
                        ],
                        value: endVal,
                      );
                      result?.then((selectedValue) => {
                            if (endVal != selectedValue &&
                                selectedValue != null)
                              {
                                setState(() => {
                                      endVal = selectedValue,
                                      endShowVal = [
                                        '0',
                                        '1',
                                        '2',
                                        '3',
                                        '4',
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9',
                                        '10',
                                        '11',
                                        '12',
                                        '13',
                                        '14',
                                        '15',
                                        '16',
                                        '17',
                                        '18',
                                        '19',
                                        '20',
                                        '21',
                                        '22',
                                        '23',
                                      ][endVal],
                                    })
                              }
                          });
                    },
                    child: BottomLine(
                      rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('结束时间', style: TextStyle(fontSize: 30.sp)),
                            Row(
                              children: [
                                Text(endShowVal,
                                    style: TextStyle(fontSize: 30.sp)),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: const Color.fromRGBO(144, 147, 153, 1),
                                  size: 30.w,
                                )
                              ],
                            ),
                          ]),
                    ),
                  ),
                )
              ])),
              Padding(padding: EdgeInsets.only(top: 10.w)),
              Center(
                  child: SizedBox(
                height: 70.sp,
                width: 680.sp,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 48, 118, 250))),
                  onPressed: () {
                    if (tranfer == '0;0;0;0;0;0;0') {
                      ToastUtils.toast('重启日期必须选一个');
                    } else {
                      getTrestsetData();
                    }
                  },
                  child: const Text('提交'),
                ),
              )),
              Padding(padding: EdgeInsets.only(top: 60.sp)),
              Row(children: const [
                TitleWidger(title: '重启'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                InfoBox(
                  boxCotainer: BottomLine(
                    rowtem: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '点击 重启 按钮重启设备',
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 48, 118, 250))),
                          onPressed: () {
                            getmaintaData();
                          },
                          child: const Text('重启'),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Padding(padding: EdgeInsets.only(top: 60.sp)),
              Row(children: const [
                TitleWidger(title: '恢复出厂'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                InfoBox(
                  boxCotainer: BottomLine(
                    rowtem: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '点击 恢复出厂 按钮进行恢复出厂操作',
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 48, 118, 250))),
                          onPressed: () {},
                          child: const Text('恢复出厂'),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleWidger extends StatelessWidget {
  final String title;

  const TitleWidger({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.blueAccent, fontSize: 32.sp),
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
        padding: EdgeInsets.all(10.0.sp),
        margin: EdgeInsets.only(bottom: 5.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: boxCotainer);
  }
}
