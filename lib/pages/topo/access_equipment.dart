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
  int day = 0;
  int hour = 0;
  int min = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      data = Get.arguments;
    });

    var time = int.parse(data.leaseTime.toString());
    day = time ~/ (24 * 3600);
    hour = (time - day * 24 * 3600) ~/ 3600;
    min = (time - day * 24 * 3600 - hour * 3600) ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context: context, title: data.hostName.toString()),
      body: SingleChildScrollView(
        child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(240, 240, 240, 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(children: [
                  TitleWidger(title: S.current.deviceInfo),
                ]),
                InfoBox(
                  boxCotainer: Column(
                    children: [
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.current.MACAddress,
                        righText: data.mAC.toString(),
                      )),
                      BottomLine(
                          rowtem: RowContainer(
                        leftText: S.of(context).IPAddress,
                        righText: data.iP.toString(),
                      )),
                      BottomLine(
                        rowtem: RowContainer(
                          leftText: S.current.LeaseTime,
                          righText: day.toString() +
                              S.of(context).date +
                              hour.toString() +
                              S.of(context).hour +
                              min.toString() +
                              S.of(context).minute,
                        ),
                      ),
                      BottomLine(
                        rowtem: RowContainer(
                          leftText: S.current.type,
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
