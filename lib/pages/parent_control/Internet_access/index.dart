import 'dart:convert';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/request/request.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../../generated/l10n.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

dynamic sn = Get.arguments['sn'];
dynamic MACAddress = Get.arguments['MACAddress'];
dynamic name = Get.arguments['name'];
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
    MACAddress = Get.arguments['MACAddress'].toString();
    name = Get.arguments['name'].toString();
    sn = Get.arguments['sn'];
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
        //过滤列表
        accessList =
            accessList.where((element) => element['Device']['_value'] == MACAddress).toList();
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
                  ? Expanded(
                      child: const Center(child: CircularProgressIndicator()))
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
                                                // 编辑
                                                icon: Icon(Icons.edit),
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
                                                },
                                              ),
                                              IconButton(
                                                //删除
                                                icon: Icon(Icons.delete),
                                                color: Color.fromRGBO(
                                                    232, 7, 30, 1),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            S.current.delPro),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text(S
                                                                .current
                                                                .cancel),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text(S
                                                                .current
                                                                .delete),
                                                            onPressed:
                                                                () async {
                                                              // Perform delete operation here
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              openLoading();
                                                              await Request()
                                                                  .addOrDeleteObject(
                                                                      "InternetGatewayDevice.WEB_GUI.ParentalControls.List.${keyList[index]}",
                                                                      sn,
                                                                      'deleteObject');
                                                              getACSNodeFn();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
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
                                          id: '',
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
  List<String> _selectedDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ]; //日期选择列表
  PickedTime _initTime = PickedTime(h: 0, m: 0);
  PickedTime _endTime = PickedTime(h: 8, m: 0);

  String lastKey = ''; //当前设置项
  @override
  void initState() {
    super.initState();
//编辑回显数据
    if (widget.id != '') {
      _initTime = PickedTime(
          h: int.parse(widget.time.split('-')[0].split(':')[0]),
          m: int.parse(widget.time.split('-')[0].split(':')[1]));
      _endTime = PickedTime(
          h: int.parse(widget.time.split('-')[1].split(':')[0]),
          m: int.parse(widget.time.split('-')[1].split(':')[1]));
      _selectedDays = widget.week.split(',');
    }
  }

  //设置云端数据
  setData() async {
    Navigator.of(context).pop();
    widget.openLoading();
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
      ['${prefix}Device', MACAddress, 'xsd:string'],
      ['${prefix}Name', name, 'xsd:string'],
      ['${prefix}TimeStart', '${_initTime.h}:${_initTime.m}', 'xsd:string'],
      ['${prefix}TimeStop', '${_endTime.h}:${_endTime.m}', 'xsd:string'],
      ['${prefix}Weekdays', '${_selectedDays.join(',')}', 'xsd:string'],
    ];

    //设置
    await Request().setACSNode(parameterNames, sn);
    Future.delayed(Duration(milliseconds: 500), () {
      widget.getACSNodeFn();
    });
  }

  //设置更新云端数据
  upData() async {
    Navigator.of(context).pop();
    widget.openLoading();

    String prefix =
        'InternetGatewayDevice.WEB_GUI.ParentalControls.List.${widget.id}.';

    var parameterNames = [
      ['${prefix}Device', MACAddress, 'xsd:string'],
      ['${prefix}Name', name, 'xsd:string'],
      ['${prefix}TimeStart', '${_initTime.h}:${_initTime.m}', 'xsd:string'],
      ['${prefix}TimeStop', '${_endTime.h}:${_endTime.m}', 'xsd:string'],
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Time Reriod',
              style: TextStyle(fontSize: 40.w, color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w),
            ),
            //选中的时间 显示
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 242, 241),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(
                      top: 7, bottom: 7, left: 12, right: 12),
                  child: Text(
                    '${_initTime.h}:${_initTime.m}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 96, 98, 97),
                    ),
                  ),
                ),
                Text('   --   '),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 242, 241),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(
                      top: 7, bottom: 7, left: 12, right: 12),
                  child: Text(
                    '${_endTime.h}:${_endTime.m}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 96, 98, 97),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w),
            ),

            //时间选择
            TimePicker(
              initTime: _initTime,
              endTime: _endTime,
              onSelectionChange: (start, end, isDisableRange) {
                setState(() {
                  _initTime = start;
                  _endTime = end;
                });
              },
              onSelectionEnd: (start, end, isDisableRange) {
                setState(() {
                  _initTime = start;
                  _endTime = end;
                });
              },
              child: Image.asset(
                'assets/images/circletime.png',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Repeat',
                style: TextStyle(
                  fontSize: 34.w,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.w),
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
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (_selectedDays.contains(day)) {
                                _selectedDays.remove(day);
                              } else {
                                _selectedDays.add(day);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedDays.contains(day)
                                  ? Colors.blue
                                  : null,
                            ),
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 15,
                                color: _selectedDays.contains(day)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
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
            if (widget.id == '') {
              print('新增');
              setData();
            } else {
              print('编辑');
              upData();
            }
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
