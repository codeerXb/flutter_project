import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'access_time.dart';
import 'access_workday.dart';

class AccessEquipment extends StatefulWidget {
  const AccessEquipment({super.key});

  @override
  State<AccessEquipment> createState() => _AccessEquipmentState();
}

class _AccessEquipmentState extends State<AccessEquipment> {
  OnlineDeviceTable data = OnlineDeviceTable(mAC: '');
  String uNKTitle = '设备信息';

  String accTitle = '家长控制';

  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
    });
    print(Get.arguments);
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
      body: Container(
        padding: const EdgeInsets.all(10.0),
        decoration:
            const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
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
                    leftText: 'IP地址',
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
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Row(children: [
              TitleWidger(title: accTitle),
            ]),
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
                      SizedBox(width: 50, child: Workday())
                    ],
                  )),
                  BottomLine(
                      rowtem: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('时间',
                          style: TextStyle(
                            color: Color.fromARGB(255, 5, 0, 0),
                          )),
                      SizedBox(width: 140, child: DatePickerPage())
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
