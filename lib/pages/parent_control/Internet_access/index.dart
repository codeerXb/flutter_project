import 'dart:convert';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';

dynamic sn = Get.arguments['sn'];
bool loading = false;

/// Internetaccess access time managemen
class Internetaccess extends StatefulWidget {
  const Internetaccess({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InternetaccessState();
}

class _InternetaccessState extends State<Internetaccess> {
  List accessList = []; //家长控制列表
  List keyList = []; //家长控制列表
  @override
  void initState() {
    super.initState();
    getACSNodeFn();
  }

  bool enable = false;

  openLoading() {
    setState(() {
      loading = true;
    });
  }

  //云端
  getACSNodeFn() async {
    setState(() {
      loading = true;
    });

    try {
      var parameterNames = [
        "InternetGatewayDevice.WEB_GUI.ParentalControls",
      ];
      //获取云端数据
      var res = await Request().getACSNode(parameterNames, sn);
      Map<String, dynamic> d = jsonDecode(res);
      var resList = d['data']['InternetGatewayDevice']['WEB_GUI']
          ['ParentalControls']['List'];
      setState(() {
        resList.remove('_object');
        resList.remove('_timestamp');
        resList.remove('_writable');
        accessList = [];
        keyList = [];
      });

      resList.forEach((key, value) {
        setState(() {
          accessList.add(value);
          keyList.add(key);
        });
      });
      setState(() {
        enable = d['data']['InternetGatewayDevice']['WEB_GUI']
            ['ParentalControls']['Enable']['_value'];
      });
    } catch (e) {
      // 处理异常
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  final TextEditingController editTitleVal = TextEditingController();

  //选择日期
  String date = 'timePeriod';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppbar(
            context: context, title: 'Internet access time scheduling '),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //time period
                TextButton(
                  onPressed: () {
                    setState(() {
                      date = 'timePeriod';
                    });
                  },
                  child: Text(
                    'Time Period',
                    style: TextStyle(
                        color: date == 'timePeriod'
                            ? Colors.blue
                            : Colors.black54),
                  ),
                ),
                //Duration
                TextButton(
                  onPressed: () {
                    setState(() {
                      date = 'Duration';
                    });
                  },
                  child: Text(
                    'Duration',
                    style: TextStyle(
                        color:
                            date == 'Duration' ? Colors.blue : Colors.black54),
                  ),
                ),
              ],
            ),
            if (date == 'timePeriod')
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Enable'),
                              Switch(
                                value: enable,
                                onChanged: (value) {
                                  setState(() {
                                    enable = value;
                                  });

                                  String prefix =
                                      'InternetGatewayDevice.WEB_GUI.ParentalControls.Enable';
                                  var parameterNames = [
                                    [prefix, value, 'xsd:string'],
                                  ];
                                  //设置
                                  Request().setACSNode(parameterNames, sn);
                                },
                              ),
                            ],
                          ),
                          //家长控制列表 遍历
                          Expanded(
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height: 1.sh - 70,
                                width: 1.sw,
                                child: ListView.builder(
                                    itemCount: accessList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        clipBehavior: Clip.hardEdge,
                                        elevation: 5,
                                        shape: const RoundedRectangleBorder(
                                          //设置卡片圆角
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                              '${accessList[index]['TimeStart']['_value']}-${accessList[index]['TimeStop']['_value']}'),
                                          subtitle: Text(accessList[index]
                                                  ['Weekdays']['_value']
                                              .toString()),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return MyDialog(
                                                          week: accessList[
                                                                      index]
                                                                  ['Weekdays']
                                                              ['_value'],
                                                          time:
                                                              '${accessList[index]['TimeStart']['_value']}-${accessList[index]['TimeStop']['_value']}',
                                                          id: keyList[index],
                                                          getACSNodeFn:
                                                              getACSNodeFn,
                                                          openLoading:
                                                              openLoading);
                                                    },
                                                  );
                                                  //输入框
                                                  // TextField(
                                                  //   autofocus: true,
                                                  //   controller: editTitleVal,
                                                  //   decoration:
                                                  //       InputDecoration(
                                                  //     contentPadding:
                                                  //         EdgeInsets.only(
                                                  //             left: 20.w),
                                                  //     border:
                                                  //         OutlineInputBorder(
                                                  //       borderRadius:
                                                  //           BorderRadius
                                                  //               .circular(10),
                                                  //     ),
                                                  //     hintText: S.current
                                                  //         .pleaseEnter,
                                                  //     suffixIcon: IconButton(
                                                  //       icon: const Icon(
                                                  //           Icons.clear),
                                                  //       onPressed: () {
                                                  //         // 清空输入框中的内容
                                                  //         editTitleVal
                                                  //             .clear();
                                                  //       },
                                                  //     ),
                                                  //   ),
                                                  //   onChanged: (value) {
                                                  //     setState(() {});
                                                  //   },
                                                  // );
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () async {
                                                  await Request().addOrDeleteObject(
                                                      "InternetGatewayDevice.WEB_GUI.ParentalControls.List.${keyList[index]}",
                                                      sn,
                                                      'deleteObject');
                                                  getACSNodeFn();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 1.sw,
                            child: Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MyDialog(
                                          getACSNodeFn: getACSNodeFn,
                                          openLoading: openLoading);
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10), // 指定圆角的半径
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue),
                                ),
                                child: const Text(
                                  'ADD PERIOD',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            if (date == 'Duration')
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Text(
                      '  Set daily limits for how long your child can use the Internet. They can only use  Internet time during the specified time periods',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  InfoBox(
                    boxCotainer: Column(children: [
                      BottomLine(
                          rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [Text('1h'), Text('Mon')],
                          ),
                          const Icon(Icons.keyboard_arrow_right_sharp)
                        ],
                      )),
                      BottomLine(
                          rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [
                              Text('2h'),
                              Text(
                                'Thu',
                                style: TextStyle(
                                  color: Color(0xFF6c7481),
                                ),
                              )
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_right_sharp)
                        ],
                      )),
                      BottomLine(
                          rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [
                              Text('5h'),
                              Text(
                                'Wed',
                                style: TextStyle(
                                  color: Color(0xFF6c7481),
                                ),
                              )
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_right_sharp)
                        ],
                      )),
                      BottomLine(
                          rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [
                              Text(
                                '1h',
                                style: TextStyle(
                                  color: Color(0xFF6c7481),
                                ),
                              ),
                              Text(
                                'Thu',
                              )
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_right_sharp)
                        ],
                      )),
                      BottomLine(
                          rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [
                              Text('1h'),
                              Text(
                                'Fri',
                                style: TextStyle(
                                  color: Color(0xFF6c7481),
                                ),
                              )
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_right_sharp)
                        ],
                      )),
                      BottomLine(
                          rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [
                              Text('1h'),
                              Text(
                                'Sat',
                                style: TextStyle(
                                  color: Color(0xFF6c7481),
                                ),
                              )
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_right_sharp)
                        ],
                      )),
                      BottomLine(
                          rowtem: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: const [
                              Text('1h'),
                              Text(
                                'Sun',
                                style: TextStyle(
                                  color: Color(0xFF6c7481),
                                ),
                              )
                            ],
                          ),
                          const Icon(Icons.keyboard_arrow_right_sharp)
                        ],
                      )),
                    ]),
                  )
                ],
              )
          ],
        ));
  }
}

class MyDialog extends StatefulWidget {
  final Function getACSNodeFn;
  final Function openLoading;
  var id;
  var time;
  var week;

  MyDialog(
      {Key? key,
      required this.getACSNodeFn,
      required this.openLoading,
      this.id = '',
      this.week = '',
      this.time = ''})
      : super(key: key);

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final List<String> _selectedDays = []; //日期选择列表

  // 开始时间
  String startTim = '';
  String startTimeH = '';
  String startTimeM = '';
  @override

// 结束时间
  String stopTim = '';
  String stopTimeH = '';
  String stopTimeM = '';
  String lastKey = ''; //当前设置项
  @override
  void initState() {
    super.initState();

    if (widget.time != '') {
      startTimeH = widget.time.split('-')[0].split(':')[0];
      startTimeM = widget.time.split('-')[0].split(':')[1];
      stopTimeH = widget.time.split('-')[1].split(':')[0];
      stopTimeM = widget.time.split('-')[1].split(':')[1];
      // _selectedDays.addAll(widget.week);
      print(_selectedDays);
    }
  }

  //设置云端数据
  setData() async {
    Navigator.of(context).pop();
    widget.openLoading();
    //添加云端数据
    await Request().addOrDeleteObject(
        "InternetGatewayDevice.WEB_GUI.ParentalControls.List", sn, 'addObject');
    //获取云端数据
    var res = await Request().getACSNode([
      "InternetGatewayDevice.WEB_GUI.ParentalControls",
    ], sn);
    Map<String, dynamic> d = jsonDecode(res);
    var list = d['data']['InternetGatewayDevice']['WEB_GUI']['ParentalControls']
        ['List'];
    //遍历取得最后一个key
    for (var key in list.keys) {
      lastKey = key;
    }
    String prefix =
        'InternetGatewayDevice.WEB_GUI.ParentalControls.List.$lastKey.';
    var parameterNames = [
      // ['${prefix}Device', '22:4C:35:D1:20:CA', 'xsd:string'],
      // ['${prefix}Name', 'HONOR_30-cd4d8ae98e5a0d4f', 'xsd:string'],
      ['${prefix}TimeStart', '$startTimeH:$startTimeM', 'xsd:string'],
      ['${prefix}TimeStop', '$stopTimeH:$stopTimeM', 'xsd:string'],
      ['${prefix}Weekdays', '${_selectedDays.join(',')}', 'xsd:string'],
    ];

    //设置
    await Request().setACSNode(parameterNames, sn);
    Future.delayed(Duration(milliseconds: 500), () {
      widget.getACSNodeFn();
    });
  }

  Time _time = Time(hour: 11, minute: 30);
  void onTimeChanged(Time newTime) {
    setState(() {
      _time = newTime;
    });
  }

  void _showStartTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        onChange: onTimeChanged,
        minuteInterval: TimePickerInterval.FIVE,
        // Optional onChange to receive value as DateTime
        onChangeDateTime: (DateTime dateTime) {
          startTim = dateTime.toString();
          startTimeH = startTim.split(' ')[1].split(':')[0];
          startTimeM = startTim.split(' ')[1].split(':')[1];
        },
      ),
    );
  }

  void _showEndTimePicker() {
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: _time,
        onChange: onTimeChanged,
        minuteInterval: TimePickerInterval.FIVE,
        // Optional onChange to receive value as DateTime
        onChangeDateTime: (DateTime dateTime) {
          stopTim = dateTime.toString();
          stopTimeH = stopTim.split(' ')[1].split(':')[0];
          stopTimeM = stopTim.split(' ')[1].split(':')[1];
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            // start
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    _showStartTimePicker();
                  },
                  child: const Text(
                    "select the start time",
                  ),
                ),
                Text(startTimeH + ' ' + startTimeM),
              ],
            ),
            // end
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    _showEndTimePicker();
                  },
                  child: const Text(
                    "select the end time",
                  ),
                ),
                Text(stopTimeH + ' ' + stopTimeM),
              ],
            ),

            //日期
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (String day in [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun'
                  ])
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_selectedDays.contains(day)) {
                                _selectedDays.remove(day);
                              } else {
                                _selectedDays.add(day);
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: _selectedDays.contains(day),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked != null && checked) {
                                      _selectedDays.add(day);
                                    } else {
                                      _selectedDays.remove(day);
                                    }
                                  });
                                },
                              ),
                              Text(day, style: const TextStyle(fontSize: 10)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // 弹框按钮点击事件处理
            Navigator.of(context).pop(); // 关闭弹框
          },
          child: Text('Close'),
        ),
        TextButton(
          onPressed: () {
            if (startTimeH.length == 0 || stopTimeH.length == 0) return;

            setData();
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
