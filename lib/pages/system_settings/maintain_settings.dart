import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/widget/custom_app_bar.dart';
import '../../core/http/http.dart';
import '../../core/utils/shared_preferences_util.dart';
import '../../core/utils/toast.dart';
import '../../core/widget/common_picker.dart';
import 'model/maintain_data.dart';

/// 维护设置
class MaintainSettings extends StatefulWidget {
  const MaintainSettings({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MaintainSettingsState();
}

class _MaintainSettingsState extends State<MaintainSettings> {
  bool isCheck = false;
  MaintainData maintainVal = MaintainData();

  String showVal = '';
  String radioShowVal = '';
  int val = 0;

  @override
  void initState() {
    super.initState();
  }

// 测试
//   final List<String> _selectedItems = [];

// // This function is triggered when a checkbox is checked or unchecked
//   void _itemChange(String itemValue, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//     });
//   }

  // this function is called when the Cancel button is pressed
//   void _cancel() {
//     Navigator.pop(context);
//   }

// // this function is called when the Submit button is tapped
//   void _submit() {
//     Navigator.pop(context, _selectedItems);
//   }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: '维护设置'),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration:
              const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 20.sp)),
              Row(children: const [
                TitleWidger(title: '重启定时'),
              ]),
              InfoBox(
                  boxCotainer: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('开启重启定时'),
                      Switch(
                        value: isCheck,
                        onChanged: (newVal) {
                          setState(() {
                            isCheck = newVal;
                          });
                        },
                      ),
                    ],
                  ),
                  Offstage(
                    offstage: !isCheck,
                    child:
                        //const SizedBox(
                        // height: 150,
                        // HomePage(),

                        GestureDetector(
                      onTap: () {
                        var result = CommonPicker.showPicker(
                          context: context,
                          options: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
                          value: val,
                        );
                        result?.then((selectedValue) => {
                              if (val != selectedValue && selectedValue != null)
                                {
                                  setState(() => {
                                        val = selectedValue,
                                        showVal = [
                                          '周一',
                                          '周二',
                                          '周三',
                                          '周四',
                                          '周五',
                                          '周六',
                                          '周日'
                                        ][val],
                                      })
                                }
                            });
                      },
                      child: InfoBox(
                        boxCotainer: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('重启日期', style: TextStyle(fontSize: 30.sp)),
                              Row(
                                children: [
                                  Text(showVal,
                                      style: TextStyle(fontSize: 30.sp)),
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
                    // ),
                  ),
                  Offstage(
                    offstage: !isCheck,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
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
                          value: val,
                        );
                        result?.then((selectedValue) => {
                              if (val != selectedValue && selectedValue != null)
                                {
                                  setState(() => {
                                        val = selectedValue,
                                        showVal = [
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
                                        ][val],
                                      })
                                }
                            });
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('重启时间', style: TextStyle(fontSize: 28.sp)),
                            Row(
                              children: [
                                Text(showVal,
                                    style: TextStyle(fontSize: 28.sp)),
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
                ],
              )),
              Padding(padding: EdgeInsets.only(top: 40.sp)),
              Row(
                children: [
                  SizedBox(
                    height: 70.sp,
                    width: 710.sp,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 48, 118, 250))),
                      onPressed: () {},
                      child: const Text('提交'),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 60.sp)),
              Row(children: const [
                TitleWidger(title: '重启'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                InfoBox(
                  boxCotainer: Row(
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
              ]),
              Padding(padding: EdgeInsets.only(top: 60.sp)),
              Row(children: const [
                TitleWidger(title: '恢复出厂'),
              ]),
              Column(children: [
                Padding(padding: EdgeInsets.only(top: 10.sp)),
                InfoBox(
                  boxCotainer: Row(
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

// Multi Select widget
// This widget is reusable
// class MultiSelect extends StatefulWidget {
//   final List<String> items;
//   const MultiSelect({Key? key, required this.items}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _MultiSelectState();
// }

// class _MultiSelectState extends State<MultiSelect> {
//   // this variable holds the selected items
//   final List<String> _selectedItems = [];

//   // This function is triggered when a checkbox is checked or unchecked
//   void _itemChange(String itemValue, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//     });
//   }

//   // this function is called when the Cancel button is pressed
//   void _cancel() {
//     Navigator.pop(context);
//   }

//   // this function is called when the Submit button is tapped
//   void _submit() {
//     Navigator.pop(context, _selectedItems);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('重启时间'),
//       content: SingleChildScrollView(
//         child: ListBody(
//           children: widget.items
//               .map((item) => CheckboxListTile(
//                     value: _selectedItems.contains(item),
//                     title: Text(item),
//                     controlAffinity: ListTileControlAffinity.leading,
//                     onChanged: (isChecked) => _itemChange(item, isChecked!),
//                   ))
//               .toList(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: _cancel,
//           child: const Text('取消'),
//         ),
//         ElevatedButton(
//           onPressed: _submit,
//           child: const Text('确定'),
//         ),
//       ],
//     );
//   }
// }

// // Implement a multi select on the Home screen
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<String> _selectedItems = [];
//   void _showMultiSelect() async {
//     // a list of selectable items
//     // these items can be hard-coded or dynamically fetched from a database/API

//     final List<String> items = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];

//     final List<String>? results = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return MultiSelect(items: items);
//       },
//     );

//     // Update UI
//     if (results != null) {
//       setState(() {
//         _selectedItems = results;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // use this button to open the multi-select dialog
//           ElevatedButton(
//             onPressed: _showMultiSelect,
//             child: const Text('重启日期'),
//           ),
//           // const Divider(
//           //   height: 100,
//           // ),
//           // display selected items
//           Wrap(
//             children: _selectedItems
//                 .map((e) => Chip(
//                       label: Text(e),
//                     ))
//                 .toList(),
//           )
//         ],
//       ),
//     );
//   }
// }
