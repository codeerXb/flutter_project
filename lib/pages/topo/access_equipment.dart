import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/widget/common_box.dart';
import 'package:flutter_template/core/widget/custom_app_bar.dart';
import 'package:flutter_template/pages/topo/model/equipment_datas.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../generated/l10n.dart';

class AccessEquipment extends StatefulWidget {
  const AccessEquipment({super.key});

  @override
  State<AccessEquipment> createState() => _AccessEquipmentState();
}

class _AccessEquipmentState extends State<AccessEquipment> {
  OnlineDeviceTable data = OnlineDeviceTable(mAC: '');
  String uNKTitle = '设备信息';

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
    // String formatDuration(Duration duration) {
    //   String hours = duration.inHours.toString().padLeft(0, '2');
    //   String minutes =
    //       duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    //   String seconds =
    //       duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    //   return "$hours:$minutes:$seconds";
    // }

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
                InfoBox(
                  boxCotainer: GestureDetector(
                    onTap: () {
                      Get.toNamed("/parental_control", arguments: data);
                    },
                    child: BottomLine(
                      rowtem: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('家长控制', style: TextStyle(fontSize: 30.sp)),
                            Row(
                              children: [
                                Text('', style: TextStyle(fontSize: 30.sp)),
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
              ],
            )),
      ),
    );
  }
}
