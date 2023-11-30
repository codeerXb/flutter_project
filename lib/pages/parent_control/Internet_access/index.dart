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

class _InternetaccessState extends State<Internetaccess>
    with SingleTickerProviderStateMixin {
  List accessList = []; //家长控制列表
  List keyList = []; //家长控制列表
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getACSNodeFn();
    _tabController = TabController(length: 2, vsync: this);
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
    var parameterNames = {
      "method": "get",
      "nodes": ["FwParentControlTable", "securityParentControlEnable"]
    };
    try {
      // var parameterNames = [
      //   "InternetGatewayDevice.WEB_GUI.ParentalControls",
      // ];
      //获取云端数据
      var res = await Request().getACSNode(parameterNames, sn);
      Map<String, dynamic> d = jsonDecode(res);
      var resList = d['data']['List'];
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
        accessList = accessList
            .where((element) => element['Device']['_value'] == MACAddress)
            .toList();
        // enable = d['data']['InternetGatewayDevice']['WEB_GUI']
        //     ['ParentalControls']['Enable']['_value'];
        enable = d['data']['Enable'];
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: const Text(
          'Internet access time scheduling',
          style: TextStyle(color: Colors.black),
        ),
        // backgroundColor: Colors.white,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          //设置状态栏的背景颜色
          statusBarColor: Colors.transparent,
          //状态栏的文字的颜色
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.black,
          labelColor: Colors.blue,
          tabs: const [
            Tab(text: 'Time Period'),
            Tab(text: 'Duration'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              loading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
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

                                  // String prefix =
                                  //     'InternetGatewayDevice.WEB_GUI.ParentalControls.Enable';
                                  var parameterNames = {
                                    "method": "set",
                                    "nodes": {
                                      "securityParentControlEnable": value,
                                    }
                                  };
                                  // var parameterNames = [
                                  //   [prefix, value, 'xsd:string'],
                                  // ];
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
                                                icon: const Icon(Icons.delete),
                                                color: const Color.fromRGBO(
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
                                                              var parameterNames =
                                                                  {
                                                                "method": "set",
                                                                "nodes": {
                                                                  "FwParentControlTable":
                                                                      '${keyList[index]}'
                                                                }
                                                              };
                                                              await Request()
                                                                  .addOrDeleteObject(
                                                                      parameterNames,
                                                                      sn);
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
            ],
          ),
          DurationPage(),
        ],
      ),
    );
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
    var parameters = {
      "method": "get",
      "nodes": ["FwParentControlTable"]
    };
    await Request().addOrDeleteObject(parameters, sn);
    //获取云端数据
    var res = await Request().getACSNode(parameters, sn);
    Map<String, dynamic> d = jsonDecode(res);
    // var list = d['data']['InternetGatewayDevice']['WEB_GUI']['ParentalControls']
    //     ['List'];
    var list = d['data'];
    //遍历取得最后一个key
    for (var key in list.keys) {
      lastKey = key;
    }

    // String prefix =
    //     'InternetGatewayDevice.WEB_GUI.ParentalControls.List.$lastKey.';

    String selectDays = _selectedDays.join(',');

    var parameterNames = {
      "method": "set",
      "nodes": {
        "Host": MACAddress,
        "Name": name,
        "TimeStart":
            '${_initTime.h.toString().padLeft(2, '0')}:${_initTime.m.toString().padLeft(2, '0')}',
        "TimeStop":
            '${_endTime.h.toString().padLeft(2, '0')}:${_endTime.m.toString().padLeft(2, '0')}',
        "Weekdays": selectDays
      }
    };

    // var parameterNames = [
    //   ['${prefix}Device', MACAddress, 'xsd:string'],
    //   ['${prefix}Name', name, 'xsd:string'],
    //   [
    //     '${prefix}TimeStart',
    //     '${_initTime.h.toString().padLeft(2, '0')}:${_initTime.m.toString().padLeft(2, '0')}',
    //     'xsd:string'
    //   ],
    //   [
    //     '${prefix}TimeStop',
    //     '${_endTime.h.toString().padLeft(2, '0')}:${_endTime.m.toString().padLeft(2, '0')}',
    //     'xsd:string'
    //   ],
    //   ['${prefix}Weekdays', '$selectDays', 'xsd:string'],
    // ];

    //设置
    await Request().setACSNode(parameterNames, sn);
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.getACSNodeFn();
    });
  }

  //设置更新云端数据
  upData() async {
    Navigator.of(context).pop();
    widget.openLoading();

    // String prefix =
    //     'InternetGatewayDevice.WEB_GUI.ParentalControls.List.${widget.id}.';
    String selectDays = _selectedDays.join(',');
    var parameterNames = {
      "method": "set",
      "nodes": {
        "Host": MACAddress,
        "Name": name,
        "TimeStart":
            '${_initTime.h.toString().padLeft(2, '0')}:${_initTime.m.toString().padLeft(2, '0')}',
        "TimeStop":
            '${_endTime.h.toString().padLeft(2, '0')}:${_endTime.m.toString().padLeft(2, '0')}',
        "Weekdays": selectDays
      }
    };
    // var parameterNames = [
    //   ['${prefix}Device', MACAddress, 'xsd:string'],
    //   ['${prefix}Name', name, 'xsd:string'],
    //   [
    //     '${prefix}TimeStart',
    //     '${_initTime.h.toString().padLeft(2, '0')}:${_initTime.m.toString().padLeft(2, '0')}',
    //     'xsd:string'
    //   ],
    //   [
    //     '${prefix}TimeStop',
    //     '${_endTime.h.toString().padLeft(2, '0')}:${_endTime.m.toString().padLeft(2, '0')}',
    //     'xsd:string'
    //   ],
    //   ['${prefix}Weekdays', '${_selectedDays.join(',')}', 'xsd:string'],
    // ];

    //设置
    await Request().setACSNode(parameterNames, sn);
    Future.delayed(const Duration(milliseconds: 500), () {
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
                    '${_initTime.h.toString().padLeft(2, '0')}:${_initTime.m.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 96, 98, 97),
                    ),
                  ),
                ),
                const Text('   --   '),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 240, 242, 241),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(
                      top: 7, bottom: 7, left: 12, right: 12),
                  child: Text(
                    '${_endTime.h.toString().padLeft(2, '0')}:${_endTime.m.toString().padLeft(2, '0')}',
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
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            if (widget.id == '') {
              debugPrint('新增');
              setData();
            } else {
              debugPrint('编辑');
              upData();
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

class DurationPage extends StatelessWidget {
  const DurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
