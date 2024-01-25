import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';
import 'package:flutter_spinner_time_picker/flutter_spinner_time_picker.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ParentConfigPage extends StatefulWidget {
  const ParentConfigPage({super.key});

  @override
  State<ParentConfigPage> createState() => _ParentConfigPageState();
}

class _ParentConfigPageState extends State<ParentConfigPage> {
  FocusNode fousNode = FocusNode();
  TextEditingController nameController = TextEditingController();
  var currentPanelIndex = 0; // 当前panel的index
  String date = 'Mon';
  bool isOpened = false;
  DateTime dateTimeSelected = DateTime.now();
  DateTime endTimeSelected = DateTime.now();
  final List<String> _selectedItems = [];
  final List<String> _selectedvideoItems = [];
  final List<String> _selectedshopItems = [];
  final List<String> _selectedwebItems = [];
  final List<String> _selectedappStoreItems = [];
  var datasMap = {
    "Shopping": [
      'Flutter',
      'Node.js',
      'React Native',
      'Java',
      'Docker',
      'MySQL'
    ],
    "Video": ['ddd', 'FDSSSSs', 'TTTTTTTT', 'JHHHHH', 'DYYYYYYr', 'MQQQQQQL'],
    "App Store": ['ertt', '43rr', 'Rrrre', 'gggg', 'Docggr', 'Mgg'],
    "Social Media": [
      'ffff',
      'Nfhtyuty',
      'Rgfdfgdfe',
      'Java',
      'Dggr',
      'Merterdfvdgdf'
    ],
    // "Website List": [
    //   '6yrtybnfg',
    //   'ffffZxdqwqw',
    //   '2werujjff',
    //   'Java',
    //   'Dottt',
    //   'Mthrr'
    // ],
  };

  bool switchValue = true;
  RxList websiteList = [].obs;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Configure',
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          // actions: [
          //   FlutterSwitch(
          //     width: 100.0,
          //     height: 40.0,
          //     activeText: "Blacklist",
          //     inactiveText: "Whitelist",
          //     activeColor: const Color.fromARGB(255, 22, 136, 230),
          //     inactiveColor: !switchValue ? Color.fromARGB(255, 22, 136, 230) : Colors.grey,
          //     activeTextColor: Colors.white,
          //     inactiveTextColor: Colors.blue[50]!,
          //     value: switchValue,
          //     valueFontSize: 12.0,
          //     borderRadius: 30.0,
          //     showOnOff: true,
          //     onToggle: (val) {
          //       setState(() {
          //         switchValue = val;
          //       });
          //     },
          //   ),
          //   // SizedBox(
          //   //   width: 40,
          //   //   child: CupertinoSwitch(
          //   //     value: switchValue,
          //   //     onChanged: (value) {
          //   //       setState(() {
          //   //         switchValue = value;
          //   //       });
          //   //     },
          //   //     thumbColor: CupertinoColors.white,
          //   //     activeColor: CupertinoColors.activeBlue,
          //   //   ),
          //   // ),
          //   const SizedBox(
          //     width: 15,
          //   )
          // ],
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.black12),
          padding: EdgeInsets.only(bottom: 20),
          child: SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100,
              // maxHeight: 100000
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: SizedBox(
                    height: 75,
                    child: Card(
                      margin: EdgeInsets.all(5),
                      elevation: 2,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white, width: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(padding:const EdgeInsets.only(left: 15,right: 10),
                          child: Image.asset("assets/images/name.png",width: 25,height: 25,)
                          ),
                          Expanded(
                              child: TextField(
                            controller: nameController,
                            autofocus: true,
                            focusNode: fousNode,
                            keyboardType: TextInputType.text,
                            decoration:const InputDecoration(
                              // prefixIcon: 
                              border: InputBorder.none,
                              // labelText: 'User Name',
                              hintText: 'Enter Your Name',
                            ),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: !switchValue,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _buildList(),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(5),
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 20,right: 5),
                    horizontalTitleGap: 5,
                    leading: Image.asset(
                      'assets/images/weblist.png',
                      width: 25,
                      height: 25,
                    ),
                    title: const Text(
                      "Website List",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Get.toNamed("/websiteConfigPage");
                      },
                      icon: Image.asset(
                        'assets/images/edit_parent.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xffe5e5e5)))),
                        child: ListTile(
                        title: Text(
                          "www.baidu.com",
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                      );
                    }),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.only(top: 28.w, bottom: 28.w),
                      ),
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 30, 104, 233)),
                    ),
                    onPressed: () {
                      Get.toNamed("/websiteDevicePage");
                    },
                    child: Text(
                      "Next Step",
                      style: TextStyle(
                          fontSize: 32.sp, color: const Color(0xffffffff)),
                    ),
                  ),
                ),
                // setUpWeeklyView(),
                // Center(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: <Widget>[
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //               'Time ${dateTimeSelected.hour}:${dateTimeSelected.minute}'),
                //           ElevatedButton(
                //             onPressed: () => _openTimePickerSheet(context),
                //             child: Text('Starting time'),
                //           ),
                //         ],
                //       ),
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //               'Time ${endTimeSelected.hour}:${endTimeSelected.minute}'),
                //           ElevatedButton(
                //             onPressed: () => _openConfigTimePickerSheet(context),
                //             child: Text('End Time'),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Column(
                //       children: [
                //         const Text(
                //           'Starting Time:',
                //           style: TextStyle(fontSize: 18),
                //         ),
                //         const SizedBox(height: 10),
                //         Text(
                //           '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                //           style: const TextStyle(
                //               fontSize: 30, fontWeight: FontWeight.bold),
                //         ),
                //         const SizedBox(height: 20),
                //         FilledButton(
                //           onPressed: _showTimePicker,
                //           child: const Text('Pick a Time'),
                //         ),
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         const Text(
                //           'End Time:',
                //           style: TextStyle(fontSize: 18),
                //         ),
                //         const SizedBox(height: 10),
                //         Text(
                //           '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                //           style: const TextStyle(
                //               fontSize: 30, fontWeight: FontWeight.bold),
                //         ),
                //         const SizedBox(height: 20),
                //         FilledButton(
                //           onPressed: _showTimePicker,
                //           child: const Text('Pick a Time'),
                //         ),
                //       ],
                //     )
                //   ],
                // ),
              ],
            ),
          )),
        ));
  }

  void _itemChange(String itemValue, String type, bool isSelected) {
    setState(() {
      if (type == "Social Media") {
        if (isSelected) {
          _selectedItems.add(itemValue);
        } else {
          _selectedItems.remove(itemValue);
        }
      } else if (type == "Video") {
        if (isSelected) {
          _selectedvideoItems.add(itemValue);
        } else {
          _selectedvideoItems.remove(itemValue);
        }
      } else if (type == "Shopping") {
        if (isSelected) {
          _selectedshopItems.add(itemValue);
        } else {
          _selectedshopItems.remove(itemValue);
        }
      }else {
        if (isSelected) {
          _selectedappStoreItems.add(itemValue);
        } else {
          _selectedappStoreItems.remove(itemValue);
        }
      }
    });
  }

/*
  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          currentPanelIndex = index;
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                    value: _selectedItems.contains(item.expandedValue),
                    title: Text(item.expandedValue),
                    // subtitle: Text('${_items[index]}'),
                    controlAffinity: ListTileControlAffinity.trailing,
                    onChanged: (isChecked) {
                      setState(() {
                            // _items.removeWhere((currentItem){
                            debugPrint(
                                "当前的是$_selectedItems --- index : $isChecked");
                            //   return _items[index] == currentItem;
                            // _itemChange(_items[index], isChecked!);
                            // });
                          });
                    });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
*/

  List<Widget> _buildList() {
    List<Widget> widgets = [];
    for (var key in datasMap.keys) {
      widgets.add(_generateExpansionTileWidget(key, datasMap[key]));
    }
    return widgets;
  }

  /// 生成 ExpansionTile 组件
  Widget _generateExpansionTileWidget(title, List<String>? names) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(5),
      child: ExpansionTile(
        title: Row(
          children: [
            generateTypeIcon(title),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            )
          ],
        ),
        children: names!.map((name) => _generateWidget(name, title)).toList(),
        onExpansionChanged: (value) {
          debugPrint("当前的是: $value");
        },
      ),
    );
  }

  Widget generateTypeIcon(String type) {
    if(type == "Shopping") {
      return Image.asset(
              'assets/images/shopping.png',
              width: 25,
              height: 25,
            );
    }else if (type == "Video") {
      return Image.asset(
              'assets/images/video.png',
              width: 25,
              height: 25,
            );
    }else if(type == "Social Media") {
      return Image.asset(
              'assets/images/social media.png',
              width: 25,
              height: 25,
            );
    }else {
      return Image.asset(
              'assets/images/app store.png',
              width: 25,
              height: 25,
            );
    }
  }

  /// 生成 ExpansionTile 下的 ListView 的单个组件
  Widget _generateWidget(name, String type) {
    /// 使用该组件可以使宽度撑满
    return CheckboxListTile(
        value: isContainApplication(type, name),
        title: Text(name),
        // subtitle: Text('${_items[index]}'),
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (isChecked) {
          setState(() {
            _itemChange(name, type, isChecked!);
            debugPrint(
                "当前的是${_selectedItems.join(" ")} --$_selectedshopItems --$_selectedvideoItems --$_selectedappStoreItems --- index : $isChecked");
          });
        });
  }

  bool isContainApplication(String type, String name) {
    bool iscontain = false;
    if (type == "Social Media") {
      iscontain = _selectedItems.contains(name);
    } else if (type == "Video") {
      iscontain = _selectedvideoItems.contains(name);
    } else if (type == "Shopping") {
      iscontain = _selectedshopItems.contains(name);
    } else {
      iscontain = _selectedappStoreItems.contains(name);
    }
    return iscontain;
  }

  // Widget setUpWeeklyView() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       //Mon
  //       Expanded(
  //         child: TextButton(
  //           style: ButtonStyle(
  //               fixedSize: MaterialStateProperty.all(const Size(10, 10))),
  //           onPressed: () {
  //             setState(() {
  //               date = 'Mon';
  //             });
  //           },
  //           child: ConstrainedBox(
  //               constraints: BoxConstraints(maxWidth: 150.w),
  //               child: FittedBox(
  //                 child: Text(
  //                   'Mon',
  //                   style: TextStyle(
  //                       color: date == 'Mon' ? Colors.blue : Colors.black54),
  //                 ),
  //               )),
  //         ),
  //       ),

  //       //Tue
  //       Expanded(
  //         child: TextButton(
  //           onPressed: () {
  //             setState(() {
  //               date = 'Tue';
  //             });
  //           },
  //           child: FittedBox(
  //             child: Text(
  //               'Tue',
  //               style: TextStyle(
  //                   color: date == 'Tue' ? Colors.blue : Colors.black54),
  //             ),
  //           ),
  //         ),
  //       ),

  //       //Wed
  //       Expanded(
  //         child: TextButton(
  //           onPressed: () {
  //             setState(() {
  //               date = 'Wed';
  //             });
  //           },
  //           child: FittedBox(
  //             child: Text(
  //               'Wed',
  //               style: TextStyle(
  //                   color: date == 'Wed' ? Colors.blue : Colors.black54),
  //             ),
  //           ),
  //         ),
  //       ),

  //       //Thu
  //       Expanded(
  //         child: TextButton(
  //           onPressed: () {
  //             setState(() {
  //               date = 'Thu';
  //             });
  //           },
  //           child: FittedBox(
  //             child: Text(
  //               'Thu',
  //               style: TextStyle(
  //                   color: date == 'Thu' ? Colors.blue : Colors.black54),
  //             ),
  //           ),
  //         ),
  //       ),

  //       // Fri
  //       Expanded(
  //         child: TextButton(
  //           onPressed: () {
  //             setState(() {
  //               date = 'Fri';
  //             });
  //           },
  //           child: FittedBox(
  //             child: Text(
  //               'Fri',
  //               style: TextStyle(
  //                   color: date == 'Fri' ? Colors.blue : Colors.black54),
  //             ),
  //           ),
  //         ),
  //       ),

  //       // Sat
  //       Expanded(
  //         child: TextButton(
  //           onPressed: () {
  //             setState(() {
  //               date = 'Sat';
  //             });
  //           },
  //           child: FittedBox(
  //             child: Text(
  //               'Sat',
  //               style: TextStyle(
  //                   color: date == 'Sat' ? Colors.blue : Colors.black54),
  //             ),
  //           ),
  //         ),
  //       ),

  //       // Sun
  //       Expanded(
  //         child: TextButton(
  //           onPressed: () {
  //             setState(() {
  //               date = 'Sun';
  //             });
  //           },
  //           child: FittedBox(
  //             child: Text(
  //               'Sun',
  //               style: TextStyle(
  //                   color: date == 'Sun' ? Colors.blue : Colors.black54),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // void _openTimePickerSheet(BuildContext context) async {
  //   final resultStart = await TimePicker.show<DateTime?>(
  //     context: context,
  //     sheet: TimePickerSheet(
  //       sheetTitle: 'Please set time',
  //       minuteTitle: 'Minute',
  //       hourTitle: 'Hour',
  //       saveButtonText: 'Save',
  //       sheetCloseIconColor: Colors.grey,
  //       saveButtonColor: Colors.blue,
  //       hourTitleStyle: const TextStyle(
  //           color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
  //       minuteTitleStyle: const TextStyle(
  //           color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
  //     ),
  //   );

  //   if (resultStart != null) {
  //     setState(() {
  //       dateTimeSelected = resultStart;
  //     });
  //   }
  // }

  // void _openConfigTimePickerSheet(BuildContext context) async {
  //   final resultEnd = await TimePicker.show<DateTime?>(
  //     context: context,
  //     sheet: TimePickerSheet(
  //       sheetTitle: 'Please set time',
  //       minuteTitle: 'Minute',
  //       hourTitle: 'Hour',
  //       saveButtonText: 'Save',
  //       sheetCloseIconColor: Colors.grey,
  //       saveButtonColor: Colors.blue,
  //       hourTitleStyle: const TextStyle(
  //           color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
  //       minuteTitleStyle: const TextStyle(
  //           color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
  //     ),
  //   );

  //   if (resultEnd != null) {
  //     setState(() {
  //       endTimeSelected = resultEnd;
  //     });
  //   }
  // }
}
